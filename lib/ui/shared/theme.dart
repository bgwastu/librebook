import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final ThemeData kLightTheme = _buildLightTheme();
const Color primaryColor = Colors.indigo;
const Color secondaryColor = Colors.indigo;

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
      toggleableActiveColor: primaryColor,
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
