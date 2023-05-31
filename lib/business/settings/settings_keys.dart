import 'package:flutter_reference/data/service/platform_select.dart';

// Keys used in the settings bloc.
// You can also use constant strings if you prefer, but constant strings don't
// let you decide values in runtime. If you use non-constant strings, some
// things like switch-cases won't work.
// Using enums with extensions like these is more work, but combines the
// safety of constants with the flexibility of values decided at runtime.

/// Enum for the names of keys.
///
/// This may not be the only place to write keys; if other blocs use other keys,
/// you could have other enums there too.
///
/// Alternatively, you can choose to store everything in one enum, to minimize
/// the chance of using repeated key strings accidentally. But if you want that
/// safety and a centralized place for the strings, I would recommend reading
/// them from a configuration file.
enum SettingsKey {
  settingOneKey,
  settingTwoKey,
  settingThreeKey,
  settingAbcKey,
  settingNumberKey,
}

/// This extension is only necessary if the names of keys don't correspond to
/// the names in the enum.
///
/// Normally, you can already use `MyEnum.myValue.name`, but that'll give you
/// exactly the name that was declared in the enum (`"myValue"` in this case).
/// The getter in this extension lets you decide the name that corresponds to
/// each value in runtime, without losing the ability to use the enum itself as
/// a const.
extension SettingsKeyNames on SettingsKey {
  /// Get the actual string that's used as the key for this setting in local
  /// storage. The local storage service does not know about this or other
  /// enums; it only receives keys as strings.
  ///
  /// Note that the `name` property is always available in an enum since Dart
  /// 2.15, and we're defining our own logic to get the name.
  String get name {
    switch (this) {
      case SettingsKey.settingOneKey:
        return select(whenAndroid: "SETTING_1", whenIos: "setting1");
      case SettingsKey.settingTwoKey:
        return select(whenAndroid: "SETTING_2", whenIos: "setting2");
      case SettingsKey.settingThreeKey:
        return select(whenAndroid: "SETTING_3", whenIos: "setting3");
      case SettingsKey.settingAbcKey:
        return select(whenAndroid: "SETTING_ABC", whenIos: "settingAbc");
      case SettingsKey.settingNumberKey:
        return select(whenAndroid: "SETTING_NUMBER", whenIos: "settingNumber");
    }
    // Note that this is just an example. There's no advantage to using
    // different strings depending on platform (or depending on other things).
    // I wrote this example because you may need backward compatibility with
    // variables that already exist in native code, or you may need to follow
    // naming conventions that already exist in your project.
    //
    // Generally speaking, these limitations should not exist in a brand new
    // Flutter project, and in that case you don't need this extension. Your
    // code remains future-proof because you can add this extension at any time,
    // since the "name" property already exists in enums.
    //
    // Additionally, you may also need an extension like this if you're reading
    // values from a configuration file but still want to use these keys in
    // switch-cases and const classes.
  }
}
