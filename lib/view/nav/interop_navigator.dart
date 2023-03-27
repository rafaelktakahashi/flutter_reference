import 'package:flutter_reference/data/bridge/channel_bridge.dart' as bridge;

// This navigator isn't very important. You'd implement this depending on
// what you have in your own project.
// This particular navigator (to be used as an example) simply has a `navigate`
// method that needs to be implemented natively.

/// Example of a native navigator. This class has a native implementation in
/// native code that can open certain native pages by name.
///
/// We don't have a Flutter navigator that receives native calls in this
/// example, but you could implement one in a similar way because both sides
/// of our bridge work in the same way.
class InteropNavigator {
  InteropNavigator._();

  // Our connection to the bridge. This port communicates with the corresponding
  // port in native code.
  static final _bridgePort = () {
    return bridge.openBridgePort("InteropNavigator");
  }();

  static InteropNavigator? _instance;
  static InteropNavigator instance() => _instance ??= InteropNavigator._();

  Future<void> navigate(String pageName,
      [Map<String, dynamic>? parameters]) async {
    // We always send an object as a parameter, with 'pageName' and optionally
    // 'parameters'.
    // Avoid sending parameters to pages whenever possible.
    return await _bridgePort.call("navigate", arguments: {
      "pageName": pageName,
      "parameters": parameters,
    });
    // The fields that you have to pass here depends on the native code that's
    // listening. In this project, the native navigator requires a "pageName"
    // and optionally "parameters" which must be a map with Strings as keys.
  }
}
