import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData kLightTheme = _buildLightTheme();
const Color primaryColor = Colors.blue;
const Color secondaryColor = Colors.blue;

ThemeData _buildLightTheme() {
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final base = ThemeData(
      brightness: Brightness.light,
      accentColorBrightness: Brightness.dark,
      colorScheme: colorScheme,
      primaryColor: secondaryColor,
      buttonColor: primaryColor,
      indicatorColor: secondaryColor,
      tabBarTheme: TabBarTheme(labelColor: secondaryColor),
      appBarTheme: AppBarTheme(
        color: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.grey[600]),
      ),
      cardColor: Colors.white,
      splashColor: Colors.white24,
      inputDecorationTheme: InputDecorationTheme(
        hoverColor: secondaryColor,
      ),
      hoverColor: secondaryColor,
      textTheme: TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
      ).apply(
        bodyColor: Colors.grey[800],
        displayColor: Colors.grey[800],
      ),
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

final ThemeData kDarkTheme = _buildDarkMode();

ThemeData _buildDarkMode() {
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final base = ThemeData(
      brightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      colorScheme: colorScheme,
      primaryColor: secondaryColor,
      textTheme: TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
      ).apply(
        bodyColor: Colors.grey[100],
        displayColor: Colors.grey[100],
      ),
      appBarTheme: AppBarTheme(
        color: Colors.grey[900],
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.grey[400]),
      ),
      primaryIconTheme: IconThemeData(color: Colors.grey[400]),
      buttonColor: primaryColor,
      indicatorColor: secondaryColor,
      tabBarTheme: TabBarTheme(labelColor: secondaryColor),
      inputDecorationTheme: InputDecorationTheme(
        hoverColor: secondaryColor,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      hoverColor: secondaryColor,
      cursorColor: secondaryColor,
      textSelectionHandleColor: secondaryColor,
      textSelectionColor: secondaryColor.withOpacity(0.6),
      splashFactory: InkRipple.splashFactory,
      accentColor: secondaryColor,
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
