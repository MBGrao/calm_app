import 'package:flutter/material.dart';

class AppTheme {
  static const String _fontFamily = 'Inter';

  // Light Theme Colors
  static const Color _lightPrimary = Color(0xFF1B4B6F);
  static const Color _lightSecondary = Color(0xFF2C6CA9);
  static const Color _lightBackground = Color(0xFFF8FAFC);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightOnSecondary = Color(0xFFFFFFFF);
  static const Color _lightOnBackground = Color(0xFF1A202C);
  static const Color _lightOnSurface = Color(0xFF1A202C);
  static const Color _lightError = Color(0xFFE53E3E);

  // Dark Theme Colors
  static const Color _darkPrimary = Color(0xFF1B4B6F);
  static const Color _darkSecondary = Color(0xFF2C6CA9);
  static const Color _darkBackground = Color(0xFF0D1B2A);
  static const Color _darkSurface = Color(0xFF1B2631);
  static const Color _darkOnPrimary = Color(0xFFFFFFFF);
  static const Color _darkOnSecondary = Color(0xFFFFFFFF);
  static const Color _darkOnBackground = Color(0xFFF8FAFC);
  static const Color _darkOnSurface = Color(0xFFF8FAFC);
  static const Color _darkError = Color(0xFFFC8181);

  // Gradient Colors
  static const List<Color> _lightGradient = [
    Color(0xFF1B517E),
    Color(0xFF0D3550),
    Color(0xFF32366F),
    Color(0xFF1B517E),
  ];

  static const List<Color> _darkGradient = [
    Color(0xFF0D1B2A),
    Color(0xFF1B2631),
    Color(0xFF2C3E50),
    Color(0xFF0D1B2A),
  ];

  // Text Styles
  static const TextStyle _lightHeadline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: _lightOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _lightHeadline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: _lightOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _lightHeadline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: _lightOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _lightBody1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: _lightOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _lightBody2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: _lightOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _lightCaption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: _lightOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _darkHeadline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: _darkOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _darkHeadline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: _darkOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _darkHeadline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: _darkOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _darkBody1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: _darkOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _darkBody2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: _darkOnBackground,
    fontFamily: _fontFamily,
  );

  static const TextStyle _darkCaption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: _darkOnBackground,
    fontFamily: _fontFamily,
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        surface: _lightSurface,
        onPrimary: _lightOnPrimary,
        onSecondary: _lightOnSecondary,
        onSurface: _lightOnSurface,
        error: _lightError,
        onError: _lightOnPrimary,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _lightOnPrimary,
          fontFamily: _fontFamily,
        ),
        iconTheme: IconThemeData(color: _lightOnPrimary),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _lightSurface,
        selectedItemColor: _lightPrimary,
        unselectedItemColor: Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: _lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: _lightPrimary.withOpacity(0.1),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: _lightOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightError),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 16,
          fontFamily: _fontFamily,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        elevation: 4,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: _lightOnBackground,
        size: 24,
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: _lightHeadline1,
        headlineMedium: _lightHeadline2,
        headlineSmall: _lightHeadline3,
        bodyLarge: _lightBody1,
        bodyMedium: _lightBody2,
        bodySmall: _lightCaption,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        surface: _darkSurface,
        onPrimary: _darkOnPrimary,
        onSecondary: _darkOnSecondary,
        onSurface: _darkOnSurface,
        error: _darkError,
        onError: _darkOnPrimary,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkPrimary,
        foregroundColor: _darkOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _darkOnPrimary,
          fontFamily: _fontFamily,
        ),
        iconTheme: IconThemeData(color: _darkOnPrimary),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: _darkPrimary,
        unselectedItemColor: Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: _darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: _darkOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkError),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 16,
          fontFamily: _fontFamily,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _darkPrimary,
        foregroundColor: _darkOnPrimary,
        elevation: 4,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: _darkOnBackground,
        size: 24,
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: _darkHeadline1,
        headlineMedium: _darkHeadline2,
        headlineSmall: _darkHeadline3,
        bodyLarge: _darkBody1,
        bodyMedium: _darkBody2,
        bodySmall: _darkCaption,
      ),
    );
  }

  // Get gradient colors based on theme
  static List<Color> getGradientColors(bool isDark) {
    return isDark ? _darkGradient : _lightGradient;
  }

  // Get primary color based on theme
  static Color getPrimaryColor(bool isDark) {
    return isDark ? _darkPrimary : _lightPrimary;
  }

  // Get background color based on theme
  static Color getBackgroundColor(bool isDark) {
    return isDark ? _darkBackground : _lightBackground;
  }

  // Get surface color based on theme
  static Color getSurfaceColor(bool isDark) {
    return isDark ? _darkSurface : _lightSurface;
  }

  // Get text color based on theme
  static Color getTextColor(bool isDark) {
    return isDark ? _darkOnBackground : _lightOnBackground;
  }

  // Get secondary text color based on theme
  static Color getSecondaryTextColor(bool isDark) {
    return isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);
  }
} 