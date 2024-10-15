// light_mode.dart
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey.shade300,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade800, // Dark icon for light mode
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.grey[800],
        displayColor: Colors.black,
      ),
);
