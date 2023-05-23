import 'package:flutter/material.dart';
import 'package:flutter_reference/data/bridge/channel_bridge.dart' as bridge;
import 'package:flutter_reference/view/nav/router.dart';
import 'package:flutter_reference/view/nav/nav_case_extension.dart';
import 'package:go_router/go_router.dart';

/// Example of a navigator that can be used from the other side of the bridge.
/// You must instantiate this class at least once in order to receive calls from
/// native code. We do this in `dependency_injection.dart`.
///
/// If you need to navigate in Flutter, you should simply use the navigation
/// framework of your choice directly (there is no need to use it through this
/// class). When you need to navigate in native code, it is recommended to make
/// calls _before_ you show the Flutter activity/view.
///
/// You can feel free to adapt this code to your needs, but be careful with
/// static code. There are mainly two limitations in this class:
/// 1. The handler that's registered in the bridge must reference this class'
/// `handleNavigate(...)`. I'm doing that by keeping only one cached instance
/// (a singleton), but you could also solve the same problem by making
/// everything static or using top-level variables for everything. Just be
/// careful of what code runs and what doesn't; typically, variables are only
/// initialized when they're used.
/// 2. The `registerHandler(...)` method must be called at least once (and
/// ideally only once) before native code tries to use this class. I'm doing
/// that by registering the handler in the private constructor, and calling the
/// public constructor in `dependency_injection.dart.`. You could also expose
/// a method just for registering the handler. I don't recommend making the
/// bridge reference this class (or any other classes).
///
/// Referencing this class should only be necessary if you need to send some
/// navigation command to native code. See the counter page for an example.
class InteropNavigator {
  /// This constructor always returns the same instance. It **must** be called
  /// at least once, otherwise this class may not be able to receive calls
  /// from native code.
  factory InteropNavigator() {
    _instance ??= InteropNavigator._();

    return _instance!;
  }

  /// This private constructor registers a handler in the bridge. This enables
  /// this class to receive native calls.
  InteropNavigator._() {
    _bridgePort.registerHandler("navigate", (params) {
      final url = params["url"] as String;
      final method = (params["method"] ?? "push") as String; // Default "push"
      // We can't refer to the _handleNavigate method right now because that's
      // the instance that we're building now in this constructor. We expect
      // this instance to always exist when the handler is called.
      _instance?._handleNavigate(url, method);
    });
  }

  /// Our connection to the bridge. This allows for communication with the other
  /// side of the bridge.
  ///
  /// Warning: At first, it may look like calling `..registerHandler(...)` on
  /// this static property would be a nice shortcut. However, that wouldn't
  /// necessarily work, because in Flutter, static properties like these are
  /// only computed when they're used. The handler won't be registered until
  /// someone _uses_ the `_bridgePort` variable.
  ///
  /// In this sample project the port is only *used* when Flutter code calls the
  /// Flutter `navigate` method to navigate to a native page. While that doesn't
  /// happen, the handler will not be available to be called from native code.
  ///
  /// For this reason, the `registerHandler(...)` call needs to be in a place
  /// where it is guaranteed to run early.
  /// I originally wrote this class as a singleton, but it's difficult to
  /// guarantee that static code runs when it's not used. Now it's a regular
  /// class that needs to be initialized in `dependency_injection.dart`.
  /// I recommend avoiding singletons if possible.
  static final _bridgePort = bridge.openBridgePort("InteropNavigator");

  // The following code looks like it works, but it's not guaranteed to run!
  // static final _bridgePort = bridge.openBridgePort("InteropNavigator")
  //   ..registerHandler("navigate", (params) {/** code */});

  /// Cached instance. I limit the number of instances to only once, because the
  /// bridge handlers makes reference to only one instance of this navigator.
  static InteropNavigator? _instance;

  /// Function for navigating to a native page.
  ///
  /// This function can be called from Flutter code to navigate to native
  /// pages. A corresponding InteropNavigator in native code will receive this
  /// call.
  ///
  /// If you want to navigate to a Flutter page, you should navigate normally
  /// without using this InteropNavigator. This is only for native pages.
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
  /// - method: "push" (default), "replace", "pop" or "navigation-case". If it's
  ///   "pop", then the route name will be ignored. If it's "navigation-case",
  ///   then the url should be the name of a navigation case that has been
  ///   registered in Flutter code using the NavigationCaseProvider.
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
      case "navigation-case":
        // See the `nav_case_extension.dart` file for an explanation of what
        // navigation cases are, and `redirect_pages.dart` to see an example.
        // If you haven't set that up (maybe you don't need it, and that's fine)
        // then simply remove this case.
        cachedContext.runNavigationCase(url);
        break;
      case "push":
      default:
        cachedContext.push(url);
    }
  }
}
