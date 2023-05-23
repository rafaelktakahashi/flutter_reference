import 'dart:io';

/// This is nothing more than a utility method for more easily declaring values
/// that depend on the platform. In this example project we only support Android
/// and iOS.
///
/// Usage:
/// ```
/// final someVariable = select(whenAndroid: "ABC", whenIos: "DEF");
/// ```
T select<T>({required T whenAndroid, required T whenIos}) {
  if (Platform.isAndroid) {
    return whenAndroid;
  } else if (Platform.isIOS) {
    return whenIos;
  }
  throw AssertionError("This code only supports Android and iOS!");
}
