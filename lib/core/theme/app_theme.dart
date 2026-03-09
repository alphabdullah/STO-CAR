import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_design_system.dart';

/// STO Car - Full UI Theme
/// Automotive marketplace: professional, responsive, accessible
class AppTheme {
  AppTheme._();

  // ==================== COLORS (Design System Constants) ====================
  // We keep these 'static const' to prevent breaking legacy 'const' widgets.
  // Note: These will always return the dark-mode variants for legacy constants.
  static const Color bgPrimary = AppDesign.darkBgPrimary;
  static const Color bgSecondary = AppDesign.darkBgSecondary;
  static const Color bgElevated = AppDesign.darkBgElevated;
  static const Color bgCard = AppDesign.darkBgCard;
  static const Color border = AppDesign.darkBorder;
  static const Color borderLight = AppDesign.darkBorderLight;

  static const Color redPrimary = AppDesign.primary;
  static const Color redPressed = AppDesign.primaryHover;
  static const Color redSoft = AppDesign.primaryLight;

  static const Color textPrimary = AppDesign.darkTextPrimary;
  static const Color textSecondary = AppDesign.darkTextSecondary;
  static const Color textMuted = AppDesign.darkTextTertiary;

  static const Color success = AppDesign.success;
  static const Color warning = AppDesign.warning;
  static const Color error = AppDesign.error;
  static const Color info = AppDesign.info;

  // ==================== DESIGN TOKENS ====================
  static const double radiusSm = AppDesign.radiusSm;
  static const double radiusMd = AppDesign.radiusMd;
  static const double radiusLg = AppDesign.radiusLg;
  static const double radiusXl = AppDesign.radiusXl;
  static const double radius2xl = AppDesign.radiusXl;
  static const double radius3xl = 28;

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 20;
  static const double spacing2xl = 24;

  static const Duration animFast = AppDesign.fast;
  static const Duration animNormal = AppDesign.normal;
  static const Duration animSlow = Duration(milliseconds: 400);

  static const String fontFamily = 'Poppins';

  // ==================== THEMES ====================

  static ThemeData get lightTheme => _createTheme(Brightness.light);
  static ThemeData get darkTheme => _createTheme(Brightness.dark);

  static ThemeData _createTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final Color bgPrimary = isDark
        ? AppDesign.darkBgPrimary
        : AppDesign.lightBgPrimary;
    final Color bgSecondary = isDark
        ? AppDesign.darkBgSecondary
        : AppDesign.lightBgSecondary;
    final Color textPrimary = isDark
        ? AppDesign.darkTextPrimary
        : AppDesign.lightTextPrimary;
    final Color textSecondary = isDark
        ? AppDesign.darkTextSecondary
        : AppDesign.lightTextSecondary;
    final Color border = isDark ? AppDesign.darkBorder : AppDesign.lightBorder;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: AppDesign.primary,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppDesign.primary,
        onPrimary: Colors.white,
        secondary: bgSecondary,
        onSecondary: textPrimary,
        error: AppDesign.error,
        onError: Colors.white,
        surface: bgSecondary,
        onSurface: textPrimary,
        surfaceContainerHighest: isDark
            ? AppDesign.darkBgElevated
            : AppDesign.lightBgTertiary,
        onSurfaceVariant: textSecondary,
        outline: border,
      ),
      scaffoldBackgroundColor: bgPrimary,
      textTheme: GoogleFonts.poppinsTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ).apply(bodyColor: textPrimary, displayColor: textPrimary),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        iconTheme: IconThemeData(color: textPrimary, size: 24),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        ),
        color: isDark ? AppDesign.darkBgCard : AppDesign.lightBgCard,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppDesign.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: border,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          borderSide: const BorderSide(color: AppDesign.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
