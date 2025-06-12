import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Montserrat',

  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF171717),
    onPrimary: Color(0xFFFAFAFA),
    secondary: Color(0xFFF4F4F5),
    onSecondary: Color(0xFF171717),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF0A0A0A),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  useMaterial3: true,
);
