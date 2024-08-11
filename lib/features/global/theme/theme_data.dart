import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_clone/features/global/theme/style.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(primary: Colors.white70),
  brightness: Brightness.light,
  primaryColor: Colors.grey[300],
  scaffoldBackgroundColor: Colors.grey[300],
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.white,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(primary: backgroundColorDarkGray),
  brightness: Brightness.dark,
  primaryColor: colorGrayLight,
  scaffoldBackgroundColor: colorDarkGray,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.black,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
  ),
);
