import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: fontColor),
      bodySmall: TextStyle(color: fontColor),
      titleLarge: TextStyle(color: fontColor),
      titleMedium: TextStyle(color: backgroundColor),
      titleSmall: TextStyle(color: fontColor),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(Size.zero),
        backgroundColor: WidgetStateProperty.all(primaryColor),
        foregroundColor: WidgetStateProperty.all(fontColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: backgroundColor,
  );
}
