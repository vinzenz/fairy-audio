import 'package:flutter/material.dart';

class AppTheme {
  // Core Palette
  static const Color charcoalDark = Color(0xFF0F0F12);
  static const Color charcoalSurface = Color(0xFF16161A);
  static const Color neonPurple = Color(0xFF8B5CF6);
  static const Color neonOrange = Color(0xFFFF7A45);
  static const Color electricBlue = Color(0xFF4F9DFF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFAAAAAA);

  static ThemeData get darkLuxe {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: charcoalDark,
      primaryColor: neonPurple,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: neonPurple,
        secondary: electricBlue,
        tertiary: neonOrange,
        surface: charcoalSurface,
        background: charcoalDark,
        onSurface: textWhite,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: charcoalDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter', // Assuming system font if not loaded
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: textWhite,
        ),
        iconTheme: IconThemeData(color: textWhite),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: charcoalSurface,
        selectedItemColor: neonPurple,
        unselectedItemColor: textGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: false, // Minimalist
        showUnselectedLabels: false,
      ),

      // Card / Containers
      cardTheme: CardTheme(
        color: charcoalSurface,
        elevation: 4,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Input Decoration (Search)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: charcoalSurface,
        hintStyle: const TextStyle(color: textGrey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: neonPurple, width: 1.5),
        ),
      ),

      // Text
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textWhite,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textWhite,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textWhite,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textGrey,
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: neonPurple,
              foregroundColor: textWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 4,
          ),
      ),
    );
  }
}
