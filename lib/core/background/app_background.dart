import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Global background widget - single source for app background
/// Wraps user-facing screens with background image
class AppBackground extends StatelessWidget {
  final Widget child;
  final bool showBackground;

  const AppBackground({
    super.key,
    required this.child,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBackground) {
      return child;
    }

    return Container(
      color: AppTheme.bgPrimary,
      child: child,
    );
  }
}

