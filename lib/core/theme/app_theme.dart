import 'package:flutter/material.dart';

/// Application theme configuration - Dark Automotive Performance UI
class AppTheme {
  AppTheme._();

  // Color Tokens - Dark Automotive Performance UI
  // Backgrounds
  static const Color bgPrimary = Color(0xFF0B0D10);
  static const Color bgSecondary = Color(0xFF141821);
  static const Color bgElevated = Color(0xFF1C2130);
  static const Color border = Color(0xFF242A3A);

  // Red - Only for actions and urgency
  static const Color redPrimary = Color(0xFFE10600);
  static const Color redPressed = Color(0xFFB30500);
  static const Color redSoft = Color(0xFFFF4D4D);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB4B8C5);
  static const Color textMuted = Color(0xFF7C8296);
  static const Color textDisabled = Color(0xFF4A4F63);

  // Status Colors
  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFFFA502);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF1E90FF);

  // Legacy compatibility (mapped to new colors)
  static const Color primaryColor = redPrimary;
  static const Color secondaryColor = redPressed;
  static const Color errorColor = error;
  static const Color warningColor = warning;
  static const Color successColor = success;
  static const Color backgroundColor = bgPrimary;
  static const Color surfaceColor = bgSecondary;

  // Typography - Inter font family
  static const String fontFamily = 'Inter';
  static const String fontFallback =
      'system-ui, -apple-system, BlinkMacSystemFont, sans-serif';

  // Dark Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: redPrimary,
        onPrimary: textPrimary,
        secondary: bgSecondary,
        onSecondary: textPrimary,
        error: error,
        onError: textPrimary,
        surface: bgSecondary,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: bgPrimary,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: bgPrimary,
        foregroundColor: textPrimary,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: bgSecondary,
        shadowColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: redPrimary,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textSecondary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: fontFamily,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: redPrimary, width: 2),
        ),
        hintStyle: const TextStyle(color: textMuted, fontFamily: fontFamily),
        labelStyle: const TextStyle(
          color: textSecondary,
          fontFamily: fontFamily,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        // H1: 28px
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.2,
        ),
        // H2: 22px
        displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.3,
        ),
        // H3: 18px
        displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.3,
        ),
        // Body Large: 16px
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        // Body Regular: 14px
        titleLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        // Small / Labels: 12px
        bodyLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          fontFamily: fontFamily,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          fontFamily: fontFamily,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMuted,
          fontFamily: fontFamily,
          height: 1.4,
        ),
      ),
    );
  }
}
