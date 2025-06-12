import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'Montserrat',
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFAFAFA),
    onPrimary: Color(0xFF171717),
    secondary: Color(0xFF262626),
    onSecondary: Color(0xFFFAFAFA),
    surface: Color(0xFF0A0A0A),
    onSurface: Color(0xFFFAFAFA),
    error: Color(0xFF7F1D1D),
    onError: Color(0xFFFAFAFA),
  ),
  scaffoldBackgroundColor: const Color(0xFF0A0A0A),
  useMaterial3: true,
);
