import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ThemeData kLightTheme = _buildLightTheme();
const Color primaryColor = Color(0xFFFFFFFF);
const Color secondaryColor = Color(0xFF5D4037);

ThemeData _buildLightTheme() {
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final base = ThemeData(
      brightness: Brightness.light,
      accentColorBrightness: Brightness.dark,
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: secondaryColor,
      tabBarTheme: TabBarTheme(labelColor: secondaryColor),
      toggleableActiveColor: primaryColor,
      splashColor: Colors.white24,
      inputDecorationTheme: InputDecorationTheme(
        hoverColor: secondaryColor,
      ),
      hoverColor: secondaryColor,
      cursorColor: secondaryColor,
      textSelectionHandleColor: secondaryColor,
      textSelectionColor: secondaryColor.withOpacity(0.6),
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      errorColor: const Color(0xFFB00020),
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme,
        textTheme: ButtonTextTheme.primary,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: primaryColor,
        brightness: Brightness.light,
      ));
  return base;
}
