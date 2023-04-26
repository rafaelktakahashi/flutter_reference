import 'package:flutter/material.dart';
import 'package:flutter_reference/data/bridge/channel_bridge.dart' as bridge;
import 'package:flutter_reference/view/nav/router.dart';
import 'package:go_router/go_router.dart';

// This navigator isn't very important. You'd implement this depending on
// what you have in your own project. This project uses GoRouter in the Flutter
// side, and very basic navigation in native code.
// This particular navigator (to be used as an example) simply has a `navigate`
// method that needs to be implemented natively.

/// Example of a native navigator. This class can be used to navigate to a
/// native page, and can also receive calls from native code to navigate to a
/// Flutter page (but in that case, pages outside of the Flutter view/activity
/// will not be affected.)
class InteropNavigator {
  InteropNavigator._();

  // Our connection to the bridge. This port communicates with the corresponding
  // port in native code.
  static final _bridgePort = () {
    // The code here executes once during initialization, and then we store the
    // port in a static variable..

    final port = bridge.openBridgePort("InteropNavigator");

    // This is an example of you you can receive calls from native code to
    // trigger flutter navigation from native code, but be careful! Flutter code
    // can't affect the native page stack. This means you can't make Flutter
    // pages appear above native pages, and you can't pop native pages using
    // the Flutter navigator.
    port.registerHandler("navigate", (params) {
      final url = params["url"] as String;
      final method = (params["method"] ?? "push") as String; // default "push"
      instance()._handleNavigate(url, method);
    });

    return port;
  }();

  static InteropNavigator? _instance;
  static InteropNavigator instance() => _instance ??= InteropNavigator._();

  /// Function for navigating to a native page.
  ///
  /// This function can be called from Flutter code to navigate to native
  /// pages. A corresponding InteropNavigator in native code will receive this
  /// call.
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

  /// Private handler for native calls for navigating to a flutter page.
  ///
  /// Calls from native must specify the following parameters:
  /// - url: The route, according to what's configured in `router.dart`,
  ///   including any route parameters. Not necessary if the method is "pop".
  /// - method: "push" (default), "replace" or "pop". If "pop", then the route
  ///   will be ignored an can be anything.
  ///
  /// If you're in a native page and want to navigate to a new Flutter screen,
  /// then this function will do not what you want. You have to create a new
  /// Flutter activity or a new Flutter view, and then call the InteropNavigator
  /// after the context exists here.
  Future<void> _handleNavigate(String url, String method) async {
    // If we have a cached context, use that one. I believe this will fail if
    // you're trying to navigate to a "first" Flutter page, without having
    // another one already loaded. You'll have to instantiate a new Flutter
    // activity or a new platform view for that.
    final cachedContext = router.routerDelegate.navigatorKey.currentContext;

    if (cachedContext == null) {
      debugPrint(
        "Trying to navigate in Flutter without a context! This will not work!",
      );
      return;
    }

    switch (method.toLowerCase()) {
      case "pop":
        if (cachedContext.canPop()) {
          cachedContext.pop();
        }
        break;
      case "replace":
        cachedContext.go(url);
        break;
      case "push":
      default:
        cachedContext.push(url);
    }
  }
}
