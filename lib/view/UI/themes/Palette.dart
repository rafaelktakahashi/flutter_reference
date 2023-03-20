import 'dart:ui';

/// Color palette for your app.
/// A color palette does not describe the _purpose_ of colors,
/// only their exact shade. One or more color _themes_ will take
/// these colors and give them purpose.
class MyCompanyPalette {
  // todo: Would be better to read this from a file in runtime, or using
  // a code generator.
  static const red = Color(0xFFF55D45);
  static const darkRed = Color(0xFF8F2100);
  static const yellow = Color(0xFFE9E233);
  static const darkBlue = Color(0xFF230B87);
  static const lightBlue = Color(0xFF34D1E3);
  static const blue = Color(0xFF0C41ED);
  static const green = Color(0xFF00E8A5);
  static const white = Color(0xFFFFFFFF);
  static const offWhite = Color(0xFFF0F0F0);
  static const black = Color(0xFF000000);
  static const purple = Color(0xFF8B2CE1);
}

/// You can define separate palettes if the
/// colors come from somewhere else (i.e. a
/// different company's colors).
class SpecialPalette {
  static const pink = Color(0xFFE3008F);
}
