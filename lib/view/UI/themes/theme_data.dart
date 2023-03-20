import 'package:flutter/material.dart';
import 'palette.dart';

var _informativeTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: MyCompanyPalette.darkBlue,
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    background: MyCompanyPalette.white,
    onBackground: MyCompanyPalette.darkBlue,
    surface: MyCompanyPalette.offWhite,
    onSurface: MyCompanyPalette.darkBlue,
    primary: MyCompanyPalette.darkBlue,
    secondary: MyCompanyPalette.lightBlue,
    error: MyCompanyPalette.darkRed,
    onError: MyCompanyPalette.white,
  ),
);

// Declare other themes here. "Export" them by declaring
// a variable

/// All common customizations of all themes.
ThemeData _customize(ThemeData base) {
  // Place here everything that should apply to all themes (for example,
  // the shape of a component, icon themes, text themes.)
  return base.copyWith(
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

/// Informative theme to be used in most places of the app.
var informativeTheme = _customize(_informativeTheme);

// If we had other themes, we'd export them too.
