import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Global events are emitted and received by any bloc with the
/// `GlobalEventAware` mixin. Each global event reaches every such bloc.
///
/// Global events are only emitted by blocs (not emitted by widgets directly)
/// and are meant to allow for one bloc to react to something that has happened
/// somewhere else. A common example is a logout, which should for example clear
/// lists that belong to the user who logged out.
///
/// Global events should only be declared for events that are relevant for
/// every bloc. If you need one specific bloc to emit an event that reaches
/// another specific bloc, then that's a sign that a Listener in the widget tree
/// or a stream would do the job better. Generally speaking, blocs want to be
/// decoupled from each other as much as possible.
///
/// Global events are not capable of directly influencing a bloc's state (see
/// that the `onGlobal` method does not make an `Emitter` available), because
/// a bloc must only change its state in response to its own events. To change
/// a bloc's state in response to a global event, you must emit a bloc event in
/// response to a global event.
abstract class GlobalEvent {
  const GlobalEvent();
}

/// Communicates to every bloc with the `GlobalEventAware` mixin that the user
/// has logged out and all information related to that user should be removed.
/// Effectively, this is an app-wide message that lets any bloc react to the
/// user's logout.
class GlobalEventLogout extends GlobalEvent {
  const GlobalEventLogout();
}

/// Mixin that gives access to global events. Any bloc with this mixin can emit
/// `GlobalEvent`s using the `addGlobal` method, and then every bloc with this
/// mixin will receive that event. Global events are handled using `onGlobal`.
///
/// Note that the bloc that sent the global event will also receive that event
/// in any handlers it has registered. Blocs do not have to handle every type
/// of global event, or any at all.
mixin GlobalEventAware<E, S> on Bloc<E, S> {
  /// Handle a global event. When an event of type `E` is emitted anywhere, the
  /// handler will be executed.
  ///
  /// Note that global events can only be emitted by any bloc with the
  /// `GlobalEventAware` mixin. It is not possible to identify the source of an
  /// event.
  ///
  /// Just that because this handler doesn't handle the bloc's events (but
  /// rather global events which are a class external to the blocs), this
  /// method doesn't let you update the bloc's state. For that, you must emit
  /// your own events inside the handler, and then those events can trigger
  /// state updates.
  onGlobal<GE extends GlobalEvent>(void Function(GE event) handler) {
    // This is our global version of a Bloc's on() method.
    // This method lets a bloc define a function that will run when a method
    // is emitted. However, unlike the Bloc's on(), this cannot provide an
    // emitter to directly influence the bloc's state. That is because the state
    // must only change in response to the bloc's own events. Accordingly, if
    // you need state changes, you must use these handlers to emit bloc events
    // in response to global events.
    // (Even if we wanted to add an `Emitter<S> emit` as a second parameter,
    // we wouldn't be able to use the Bloc's methods to directly emit a state.)
    _GlobalEventStream.I().stream.listen((event) {
      if (event is GE) {
        handler.call(event);
      }
    });
  }

  /// Send an event to every bloc that has this mixin, including the bloc that
  /// sent the event.
  addGlobal(GlobalEvent event) {
    // This is our global version of a Bloc's add() method. It notifies all
    // blocs with this mixin that an event has occurred, so that those blocs may
    // run their handlers and add their own events to handle the event.
    _GlobalEventStream.I().addEvent(event);
  }
}

/// (private class, do not use outside of the `GlobalEventAware` mixin)
///
/// Singleton that contains a
///
/// This entire singleton is an implementation detail of the `GlobalEventAware`
/// mixin, and could be implemented in other ways, such as with global variables.
/// This stream should not be used directly.
class _GlobalEventStream {
  static final _instance = _GlobalEventStream._();
  final _controller = StreamController<GlobalEvent>.broadcast();

  factory _GlobalEventStream.I() {
    return _instance;
  }

  _GlobalEventStream._();

  /// Broadcast stream for global events.
  Stream<GlobalEvent> get stream => _controller.stream.asBroadcastStream();

  // Adds an event to the global event stream.
  addEvent(GlobalEvent event) {
    _controller.sink.add(event);
  }
}
