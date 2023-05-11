import 'package:flutter_reference/data/bridge/channel_bridge.dart';

/// Superclass for services that need to communicate with native code. For more
/// details, see the InteropRepository class.
///
/// Unlike the InteropRepository, this doesn't extend an interface for services.
/// In general, you don't need an interface for all services because there's
/// nothing in common between all services. Each one has its own API that
/// depends on what it's used for.
abstract class InteropService {
  // Please, see the InteropRepository class for more details.
  // This class is like that one, but simpler.
  late FlutterMethodChannelBridgePort _port;

  InteropService(final serviceName) {
    _port = openBridgePort("service/$serviceName");
  }

  void exposeMethod(String name, dynamic Function(dynamic) handler) {
    _port.registerHandler(name, handler);
  }

  Future<dynamic> callNativeMethod(String methodName,
      [dynamic arguments]) async {
    return await _port.call(methodName, arguments: arguments);
  }
}
