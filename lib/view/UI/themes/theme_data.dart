import 'package:flutter/material.dart';
import 'palette.dart';

// Declare here anything that's specific to one theme. If you want to customize
// behavior across the board (in all themes), then declare that in the
// `_customize(...)` function. Everything you declare there will apply to all
// themes.
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

var _allWhiteTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: MyCompanyPalette.offWhite,
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    background: MyCompanyPalette.white,
    onBackground: MyCompanyPalette.black,
    surface: MyCompanyPalette.white,
    onSurface: MyCompanyPalette.black,
    primary: MyCompanyPalette.offWhite,
    onPrimary: MyCompanyPalette.darkBlue,
    secondary: MyCompanyPalette.blue,
    onSecondary: MyCompanyPalette.white,
    error: MyCompanyPalette.red,
    onError: MyCompanyPalette.black,
  ),
);

var _lightMapTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: Colors.lightBlue,
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    background: MyCompanyPalette.white.withAlpha(0x80),
    onBackground: MyCompanyPalette.darkBlue,
    surface: MyCompanyPalette.offWhite,
    onSurface: MyCompanyPalette.darkBlue,
    primary: Colors.lightBlue,
    secondary: MyCompanyPalette.darkBlue,
    error: MyCompanyPalette.darkRed,
    onError: MyCompanyPalette.white,
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    borderRadius: const BorderRadius.all(Radius.circular(7)),
    fillColor: Colors.lightBlue[500], // background when selected
    selectedBorderColor: Colors.lightBlue[800], // border when selected
    selectedColor: Colors.white, // text when selected
    borderColor: Colors.lightBlue[800], // border when unselected
    color: Colors.black54, // text when unselected
    textStyle:
        TextStyle(foreground: Paint()..color = MyCompanyPalette.darkBlue),
  ),
);

var _darkMapTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: Colors.lightBlue,
  colorScheme: ColorScheme.light(
    brightness: Brightness.dark,
    background: MyCompanyPalette.black.withAlpha(0x80),
    onBackground: MyCompanyPalette.lightBlue,
    surface: MyCompanyPalette.black,
    onSurface: MyCompanyPalette.lightBlue,
    primary: MyCompanyPalette.lightBlue,
    secondary: MyCompanyPalette.purple,
    error: MyCompanyPalette.red,
    onError: MyCompanyPalette.white,
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    borderRadius: const BorderRadius.all(Radius.circular(7)),
    fillColor: MyCompanyPalette.lightBlue,
    selectedBorderColor: Colors.white,
    selectedColor: Colors.white,
    borderColor: MyCompanyPalette.lightBlue,
    color: Colors.black,
    textStyle: TextStyle(foreground: Paint()..color = Colors.white),
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

/// Extra bright theme with more white than usual.
var extraBrightTheme = _customize(_allWhiteTheme);

/// Theme for components that render over the map in roadmap mode.
var lightMapTheme = _customize(_lightMapTheme);

/// Theme for components that render over the map in satellite mode.
var darkMapTheme = _customize(_darkMapTheme);
