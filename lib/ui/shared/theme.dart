import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  accentColor: Colors.black,
  textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black,
      selectionColor: Colors.black.withOpacity(0.4),
      selectionHandleColor: Colors.black),
  primaryTextTheme: Get.textTheme
      .apply(bodyColor: Colors.grey[800], displayColor: Colors.grey[800]),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
              const TextStyle(fontWeight: FontWeight.bold)))),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black), foregroundColor: MaterialStateProperty.all(Colors.white))),
  appBarTheme: AppBarTheme(brightness: Brightness.light, color: Colors.white, iconTheme: IconThemeData(color: Colors.black)),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
    },
  ),
);

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  appBarTheme: AppBarTheme(
    color: Colors.black,
    iconTheme: IconThemeData(color: Colors.grey[200])
  ),
  accentColor: Colors.grey[200],
  elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[200]), foregroundColor: MaterialStateProperty.all(Colors.black))),
  primaryTextTheme: Get.textTheme
      .apply(bodyColor: Colors.grey[200], displayColor: Colors.grey[200]),
  primaryColor: Colors.grey[200],
  colorScheme: ColorScheme.dark(primary: Colors.grey),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all(
              const TextStyle(fontWeight: FontWeight.bold)))),
  errorColor: Colors.red.shade400,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);
