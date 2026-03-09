import 'package:flutter/material.dart';
import '../theme/app_design_system.dart';
import '../utils/responsive.dart';

/// Responsive card - consistent padding and radius
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final p = padding ?? EdgeInsets.all(Responsive.hp(context));

    return Container(
      decoration: BoxDecoration(
        color: color ?? AppDesign.bgCard,
        borderRadius: BorderRadius.circular(AppDesign.radiusLg),
        border: Border.all(color: AppDesign.border.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDesign.radiusLg),
          child: Padding(padding: p, child: child),
        ),
      ),
    );
  }
}
