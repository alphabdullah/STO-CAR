import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// STO Car - Complete Design System
/// Automotive marketplace: auctions, parts, bookings
/// Professional, responsive, accessible
class AppDesign {
  AppDesign._();

  // ==================== COMMON COLORS ====================
  static const Color primary = Color(0xFFDC2626); // Automotive Red
  static const Color primaryHover = Color(0xFFB91C1C);
  static const Color primaryLight = Color(0xFFFEE2E2);
  static const Color secondary = Color(0xFFF59E0B); // Amber
  static const Color secondaryLight = Color(0xFFFEF3C7);
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ==================== DARK PALETTE ====================
  static const Color darkBgPrimary = Color(0xFF0A0C0F);
  static const Color darkBgSecondary = Color(0xFF14171C);
  static const Color darkBgTertiary = Color(0xFF1C2028);
  static const Color darkBgCard = Color(0xFF171A21);
  static const Color darkBgElevated = Color(0xFF1E232C);
  static const Color darkBorder = Color(0xFF252A33);
  static const Color darkBorderLight = Color(0xFF2D343F);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

  // ==================== LIGHT PALETTE ====================
  static const Color lightBgPrimary = Color(0xFFF8FAFC);
  static const Color lightBgSecondary = Color(0xFFFFFFFF);
  static const Color lightBgTertiary = Color(0xFFF1F5F9);
  static const Color lightBgCard = Color(0xFFFFFFFF);
  static const Color lightBgElevated = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightBorderLight = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary = Color(0xFF94A3B8);

  // ==================== DYNAMIC GETTERS ====================
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color getBgPrimary(BuildContext context) =>
      isDark(context) ? darkBgPrimary : lightBgPrimary;
  static Color getBgSecondary(BuildContext context) =>
      isDark(context) ? darkBgSecondary : lightBgSecondary;
  static Color getBgTertiary(BuildContext context) =>
      isDark(context) ? darkBgTertiary : lightBgTertiary;
  static Color getBgCard(BuildContext context) =>
      isDark(context) ? darkBgCard : lightBgCard;
  static Color getBgElevated(BuildContext context) =>
      isDark(context) ? darkBgElevated : lightBgElevated;
  static Color getBorder(BuildContext context) =>
      isDark(context) ? darkBorder : lightBorder;
  static Color getTextPrimary(BuildContext context) =>
      isDark(context) ? darkTextPrimary : lightTextPrimary;
  static Color getTextSecondary(BuildContext context) =>
      isDark(context) ? darkTextSecondary : lightTextSecondary;
  static Color getTextTertiary(BuildContext context) =>
      isDark(context) ? darkTextTertiary : lightTextTertiary;

  // ==================== ALIASES (Fixed as constants for legacy support) ====================
  static const Color bgPrimary = darkBgPrimary;
  static const Color bgSecondary = darkBgSecondary;
  static const Color bgTertiary = darkBgTertiary;
  static const Color bgCard = darkBgCard;
  static const Color bgElevated = darkBgElevated;
  static const Color border = darkBorder;
  static const Color borderLight = darkBorderLight;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textTertiary = darkTextTertiary;
  static const Color textMuted = darkTextTertiary;
  static const Color redPrimary = primary;
  static const Color redPressed = primaryHover;

  static const Color bgPrimaryStatic = darkBgPrimary;
  static const Color bgSecondaryStatic = darkBgSecondary;

  // ==================== RADIUS ====================
  static const double radiusXs = 6;
  static const double radiusSm = 10;
  static const double radiusMd = 14;
  static const double radiusLg = 18;
  static const double radiusXl = 24;

  // ==================== TYPOGRAPHY ====================
  static TextStyle heading1(BuildContext context) => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle heading2(BuildContext context) => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle heading3(BuildContext context) => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );
  static TextStyle caption(BuildContext context) => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.outline,
  );

  // ==================== ANIMATION ====================
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
}
