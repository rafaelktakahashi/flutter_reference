import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The name of the method channel needs to be exactly the same
/// as in the native adapters. In this project I'm using this
/// prefix plus a name that is unique to every bloc.
const blocChannelNamePrefix =
    "br.com.rtakahashi.playground.flutter_reference/BlocChannel/";

/// Our own bloc that knows how to interact with the native side through
/// events and state updates.
abstract class InteropBloc<E, S> extends Bloc<E, S> {
  late MethodChannel platform;

  final List<String> _nativeSubscriptions;

  InteropBloc(String blocName, super.initialState)
      : _nativeSubscriptions = List.empty(growable: true) {
    // Receive events from the native side.
    platform = MethodChannel(
        "$blocChannelNamePrefix$blocName", const JSONMethodCodec());
    platform.setMethodCallHandler(_handler);

    // If we always sent messages to a fixed method, then we'd be wasting calls
    // when the other side isn't listening. Flutter blocs may exist without
    // a corresponding native bloc adapter.
    // This code is prepared to register multiple callbacks, but in practice
    // that shouldn't be needed.
    stream.listen((event) {
      for (var subscription in _nativeSubscriptions) {
        platform.invokeMethod(subscription, stateToMessage(event));
      }
    });
  }

  Future<dynamic> _handler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'sendEvent':
        return _receiveMessage(methodCall.arguments);
      case 'registerCallback':
        return _registerNativeCallback(methodCall.arguments as String);
      case 'unregisterCallback':
        return _unregisterNativeCallback(methodCall.arguments as String);
      case 'getCurrentState':
        return stateToMessage(state);
      default:
        throw MissingPluginException("notImplemented");
    }
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
