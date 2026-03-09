import 'package:flutter/material.dart';
import '../theme/responsive_values.dart';
import '../theme/app_design_system.dart';
import '../utils/responsive.dart';

/// Responsive primary button
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final h = ResponsiveValues.buttonHeight(context);
    final isNarrow = Responsive.width(context) < 360;

    return SizedBox(
      width: width ?? double.infinity,
      height: h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppDesign.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppDesign.border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.9)),
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: isNarrow ? 18 : 20),
                      SizedBox(width: isNarrow ? 6 : 8),
                    ],
                    Text(label, style: TextStyle(fontSize: isNarrow ? 14 : 15)),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Responsive secondary/outlined button
class AppSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AppSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final h = ResponsiveValues.buttonHeight(context);
    final isNarrow = Responsive.width(context) < 360;

    return SizedBox(
      height: h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppDesign.border),
          foregroundColor: AppDesign.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radiusMd),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: isNarrow ? 18 : 20),
                SizedBox(width: isNarrow ? 6 : 8),
              ],
              Text(label, style: TextStyle(fontSize: isNarrow ? 14 : 15)),
            ],
          ),
        ),
      ),
    );
  }
}
