import 'package:flutter/material.dart';

/// Responsive value helpers - all screen sizes
class ResponsiveValues {
  static double width(BuildContext c) => MediaQuery.of(c).size.width;
  static double height(BuildContext c) => MediaQuery.of(c).size.height;

  static bool isXs(BuildContext c) => width(c) < 360;
  static bool isSm(BuildContext c) => width(c) < 600;
  static bool isMd(BuildContext c) => width(c) >= 600 && width(c) < 900;
  static bool isLg(BuildContext c) => width(c) >= 900;

  /// Horizontal padding - 12/16/20/24
  static double hp(BuildContext c) {
    final w = width(c);
    if (w < 360) return 12;
    if (w < 600) return 16;
    if (w < 900) return 20;
    return 24;
  }

  /// Button height - 48/50/52 (prevents overflow on small screens)
  static double buttonHeight(BuildContext c) {
    final w = width(c);
    if (w < 360) return 48;
    if (w < 600) return 50;
    return 52;
  }

  /// Icon size - 20/24/28
  static double iconSize(BuildContext c) {
    final w = width(c);
    if (w < 360) return 20;
    if (w < 600) return 24;
    return 28;
  }
}
