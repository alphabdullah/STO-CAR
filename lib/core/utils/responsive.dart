import 'package:flutter/material.dart';

/// Responsive utilities - all mobile devices, ultra-modern breakpoints
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static const double mobileMax = 600;
  static const double tabletMax = 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileMax &&
      MediaQuery.of(context).size.width < tabletMax;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;

  static double width(BuildContext context) => MediaQuery.of(context).size.width;
  static double height(BuildContext context) => MediaQuery.of(context).size.height;

  /// Adaptive padding - responsive for small phones to tablets
  static double hp(BuildContext context) {
    final w = width(context);
    if (w < 360) return 12;
    if (w < 600) return 16;
    if (w < 768) return 20;
    return 24;
  }

  static Widget constrained(Widget child, {double maxWidth = 1200}) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = width(context);
    if (w >= tabletMax) return desktop;
    if (w >= mobileMax && tablet != null) return tablet!;
    return mobile;
  }
}
