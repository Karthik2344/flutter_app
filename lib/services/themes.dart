// themes.dart

import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  primaryColor: const Color(0xFF007A33),
  hintColor: Colors.white,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
  ),
);

final darkTheme = ThemeData(
  primaryColor: const Color(0xFF007A33),
  hintColor: Colors.white,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
);
