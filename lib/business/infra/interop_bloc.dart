import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reference/data/bridge/channel_bridge.dart';

/// Our own bloc that knows how to interact with the native side through
/// events and state updates.
abstract class InteropBloc<E, S> extends Bloc<E, S> {
  /// A reference to a port in our bridge. The port has the name that
  /// is specified when this bloc is instantiated.
  late FlutterMethodChannelBridgePort port;

  final List<String> _nativeSubscriptions;

  InteropBloc(String blocName, super.initialState)
      : _nativeSubscriptions = List.empty(growable: true) {
    // Open the port with the specified name. Each port should only be
    // opened once.
    // Don't forget that the bloc itself needs to use this exact naming scheme.
    port = openBridgePort("bloc/$blocName");

    // Register each method on the bridge. Unlike the MethodChannel itself,
    // our bridge expects each handler to be registered separately.
    port.registerHandler("sendEvent", _receiveMessage);
    port.registerHandler("registerCallback", (p) => _registerNativeCallback(p));
    port.registerHandler(
        "unregisterCallback", (p) => _unregisterNativeCallback(p));
    port.registerHandler("getCurrentState", (_) => stateToMessage(state));

    // If we always sent messages to a fixed method, then we'd be wasting calls
    // when the other side isn't listening. Flutter blocs may exist without
    // a corresponding native bloc adapter.
    // This code is prepared to register multiple callbacks, but in practice
    // that shouldn't be needed.
    stream.listen((event) {
      for (var subscription in _nativeSubscriptions) {
        port.call(subscription, arguments: stateToMessage(event));
      }
    });
  }

  /// Must be overridden to produce an event that this bloc understands from
  /// a message received from the native side.
  E messageToEvent(dynamic message);

  /// Must be overridden to produce a message that the native side will
  /// undestand, containing the state.
  /// Each native bloc adapter is responsible for interpreting the messages
  /// that the corresponding Flutter bloc sends.
  dynamic stateToMessage(S state);

  void _registerNativeCallback(String callback) {
    _nativeSubscriptions.add(callback);
  }

  void _unregisterNativeCallback(String callback) {
    _nativeSubscriptions.remove(callback);
  }

  /// This receives messages from the native side and turns them to events to
  /// add them to this bloc. Once added, the events are handled by the bloc
  /// like any other event.
  void _receiveMessage(dynamic message) {
    // The message parameter is something that came from the other side of the
    // channel. We turn it into an event and add it to this bloc.
    E event = messageToEvent(message);
    add(event);
  }
}
