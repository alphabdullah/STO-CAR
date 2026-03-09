import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../state/theme_state.dart';
import '../theme/app_design_system.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = Get.find<ThemeState>();

    return Obx(() {
      final isDark = themeState.isDarkMode.value;
      return InkWell(
        onTap: () => themeState.toggleTheme(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 70,
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark
                ? AppDesign.darkBgTertiary
                : AppDesign.lightBgTertiary,
            border: Border.all(
              color: isDark ? AppDesign.darkBorder : AppDesign.lightBorder,
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isDark
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppDesign.primary : Colors.amber.shade600,
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? AppDesign.primary : Colors.amber)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.light_mode_rounded,
                        size: 12,
                        color: isDark ? Colors.grey : Colors.transparent,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.dark_mode_rounded,
                        size: 12,
                        color: isDark ? Colors.transparent : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
