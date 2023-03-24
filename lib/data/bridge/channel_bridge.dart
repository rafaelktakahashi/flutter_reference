import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// This exact string must be used in the native side of the bridge.
const _methodChannelName = "br.com.rtakahashi.playground.flutter_reference";

/// Flutter side of the method channel bridge.
/// Use this bridge to open a port to the native side instead of opening method
/// channels directly. Anything you would do with the method channel, do with
/// a port instead.
///
/// In practice, this means that we break the rules a bit and let the Navigator
/// in the visualization layer use this class directly. It seems better to me
/// to do this than create an additional special layer.
///
/// After having obtained an instance of [FlutterMethodChannelPort], you can use
/// it just like you would use the method channel, with a few differences:
/// - Handlers are registered one by one, by method name. You should register
/// a method name that has been registered before on the same port. If you do,
/// the previous handler will be forgotten and that may lead to bugs.
/// - Port names work like prefixes, but you don't have to worry about
/// constructing the names of methods.
/// - Everything is exposed through easy-to-use async methods.
///
/// ``` dart
/// import "(this file)" as bridge;
/// ...
///
/// final weatherPort = bridge.openMethodChannelPort("WeatherRepository");
///
/// // Send a call to the native side:
/// final forecast = await weatherPort.call("fetchWeatherForecast");
/// // or register to receive calls from the native side:
/// weatherPort.registerHandler("fetchWeatherForecast", () async {...});
/// ```
///
/// As with a regular method channel, anything you call must have a
/// corresponding implementation on the other side, with a matching port name
/// and method name. Otherwise, you'll receive a [MissingPluginException].
///
/// Additionally, you'll also receive an exception if you try to call a method
/// before the bridge (on either side) finishes its initialization. Registering
/// handlers, however, can be done even before the bridge is initialized.
FlutterMethodChannelPort openMethodChannelPort(String portName) {
  return FlutterMethodChannelPort._(portName);
}

/// Initialize this bridge. This method MUST be called, and only after
/// ensureInitialized() is called. Calls can only be made to the native side
/// after the Flutter bridge is initialized, and likewise, native calls will
/// only reach the Flutter side after the Flutter bridge has been initialized.
///
/// You'll find a similar requirement on the native side of the bridge.
void initializeBridge() {
  _sharedChannel = const MethodChannel(
    _methodChannelName,
    JSONMethodCodec(),
  );

  // Now, this is the only time we ever register a handler on the shared
  // channel. This handler checks the handlers that were registered on the
  // bridge, and calls a handler if there is one.
  _sharedChannel!.setMethodCallHandler((methodCall) async {
    final handler = _handlers[methodCall.method];
    if (handler == null) {
      throw MissingPluginException("Method does not exist in Flutter.");
    } else {
      return handler(methodCall.arguments);
    }
  });
}

/// The central idea of the bridge is that multiple "ports" can exist each
/// with their own name, but every instance will use a single shared
/// method channel. Classes can use the port in a similar way as they
/// would use the regular MethodChannel.
///
/// In summary, there is only one method channel, no matter how many ports
/// you instantiate.
///
/// You can't open a port more than once. If you try, you'll receive the same
/// port that has been opened before.
///
/// You can't close ports but you can unregister handlers if you want.
/// Generally, that shouldn't be necessary.
///
/// The shared channel is nullable because it needs to be initialized manually
/// only after having called ensureInitialized().
MethodChannel? _sharedChannel;

/// Keys are a concatenation of a port and a method name, separated by a dot.
/// Example: "WeatherRepository.fetchWeatherForecast".
Map<String, dynamic Function(dynamic)> _handlers = {};

class FlutterMethodChannelPort {
  /// Name of this bridge. In pratice, only one "bridge" exists, but each
  /// instance of this class requires a name to be used as a prefix.
  final String name;

  /// Make a new instance of this port.
  FlutterMethodChannelPort._(this.name);

  /// Send something through the shared channel.
  /// There must be a handler on the native side with the same name as this
  /// port, and a registered handler with the method name specified in
  /// [methodName].
  ///
  /// If a corresponding port with a corresponding method handler doesn't
  /// exist in the native side, or if either side of the method channel hasn't
  /// finished initializing, a [MissingPluginException] will be thrown.
  Future<dynamic> call(String methodName, {dynamic arguments}) {
    if (_sharedChannel == null) {
      throw MissingPluginException("Not initialized");
    } else {
      return _sharedChannel!.invokeMethod("$name.$methodName", arguments);
    }
  }

  /// Register a handler for a name. If a different handler was already
  /// registered for the same name, it'll be forgotten in favor of this one.
  void registerHandler(String callbackName, dynamic Function(dynamic) handler) {
    if (_handlers["$name.$callbackName"] != null) {
      debugPrint(
        "Method $callbackName for port $name has already been registered in the bridge! Overwriting!",
      );
    }

    _handlers["$name.$callbackName"] = handler;
  }

  /// Unregister a handler by name.
  void unregisterHandler(String callbackName) {
    _handlers.remove("$name.$callbackName");
  }

  /// Unregister all handlers for this port.
  void unregisterAllHandlers() {
    _handlers.removeWhere((key, value) => key.startsWith("$name."));
  }
}
