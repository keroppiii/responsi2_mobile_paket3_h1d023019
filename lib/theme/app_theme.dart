import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBrown = Color(0xFF8B4513); // SaddleBrown
  static const Color accentBrown = Color(0xFFD2691E); // Chocolate
  static const Color lightBrown = Color(0xFFF5DEB3); // Wheat
  static const Color darkBrown = Color(0xFF654321); // DarkBrown

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryBrown,
      colorScheme: ColorScheme.light(
        primary: primaryBrown,
        secondary: accentBrown,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBrown,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBrown,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryBrown),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryBrown, width: 2),
        ),
      ),
    );
  }
}