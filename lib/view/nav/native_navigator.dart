// Currently, this file only uses the method channel to make a call to native
// code. In a real project, there would be more stuff here.
import 'package:flutter/services.dart';

// This navigator isn't very important. The main point of this project is
// to showcase the interop bloc. Go look there.
class NativeNavigator {
  NativeNavigator._();
  static const platform =
      MethodChannel("br.com.rtakahashi.playground.flutter_reference/navigator");
  static NativeNavigator? _instance;
  static NativeNavigator instance() => _instance ??= NativeNavigator._();

  Future<void> navigate(String pageName) {
    return platform.invokeMethod("navigate", {pageName: pageName});
  }
}
