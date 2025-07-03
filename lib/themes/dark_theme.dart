import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'Montserrat',
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFEAEAEA),
    onPrimary: Color(0xFF121212),
    secondary: Color(0xFF303030),
    onSecondary: Color(0xFFF5F5F5),
    surface: Color(0xFF1A1A1A),
    onSurface: Color(0xFFF5F5F5),
    error: Color(0xFFB71C1C),
    onError: Color(0xFFFFFFFF),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  useMaterial3: true,
);
