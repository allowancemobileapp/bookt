import 'package:flutter/material.dart';

final ThemeData cyberpunkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Deep, dark background
  primaryColor: const Color(0xFF08F7FE), // Neon aqua
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF08F7FE), // Neon aqua
    secondary: Color(0xFFFF009D), // Neon pink accent
    surface: Color(0xFF1A1A1A),
    // background: Color(0xFF0A0A0A), // Removed to avoid deprecation warning
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1A1A1A),
    elevation: 2,
    titleTextStyle: TextStyle(
      color: Color(0xFF08F7FE),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF08F7FE),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF08F7FE), // Neon aqua button
      foregroundColor: Colors.black, // Text color on buttons
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Cyberpunk', // Your custom font
      fontSize: 16,
      color: Colors.white,
    ),
  ),
);
