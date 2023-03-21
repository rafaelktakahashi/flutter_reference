// Currently, this file only uses the method channel to make a call to native
// code.
import 'package:flutter/services.dart';

// This navigator isn't very important. You'd implement this depending on
// what you have in your own project.
// This particular navigator (to be used as an example) simply has a `navigate`
// method that needs to be implemented natively.

/// Example of a native navigator. This class has a native implementation in
/// native code that can open certain native pages by name.
class NativeNavigator {
  NativeNavigator._();
  static const platform =
      MethodChannel("br.com.rtakahashi.playground.flutter_reference/navigator");
  static NativeNavigator? _instance;
  static NativeNavigator instance() => _instance ??= NativeNavigator._();

  Future<void> navigate(String pageName) {
    // Of course, you could implement parameters as well, but avoid
    // relying on parameters whenever possible.
    return platform.invokeMethod("navigate", {pageName: pageName});
  }
}
