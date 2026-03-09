import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../state/auth_state.dart';
import '../../models/user_model.dart';
import '../constants/app_constants.dart';
import '../constants/app_strings.dart';
import '../theme/app_theme.dart';
import '../theme/app_design_system.dart';
import '../utils/responsive.dart';

/// Ultra-modern bottom nav - floating pill, minimal, fast
class RoleBottomNav extends StatelessWidget {
  final int currentIndex;

  const RoleBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final authState = AuthState();
    final userRole = authState.currentUser?.role;
    final items = userRole == UserRole.admin ? _adminItems : _userItems;

    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isNarrow = Responsive.width(context) < 360;
    final hasFiveItems = items.length >= 5;
    final navHeight = hasFiveItems ? (isNarrow ? 60.0 : 64.0) : (isNarrow ? 58.0 : 62.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding > 0 ? bottomPadding + 8 : 16),
      child: Container(
        height: navHeight,
        decoration: BoxDecoration(
          color: AppDesign.getBgCard(context),
          borderRadius: BorderRadius.circular(AppDesign.radiusXl),
          border: Border.all(color: AppDesign.getBorder(context), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDesign.radiusXl),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              items.length,
              (i) => _NavTile(
                icon: items[i].icon,
                imagePath: items[i].imagePath,
                label: items[i].label,
                isSelected: i == currentIndex,
                isNarrow: isNarrow,
                onTap: () => context.go(items[i].route),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final String route;
  _NavItem({this.icon, this.imagePath, required this.label, required this.route});
}

final _userItems = [
  _NavItem(icon: Icons.home_rounded, label: AppStrings.home, route: AppConstants.routeHomeFeature),
  _NavItem(icon: Icons.calendar_today_rounded, label: AppStrings.booking, route: AppConstants.routeBookings),
  _NavItem(icon: Icons.gavel_rounded, label: AppStrings.auctions, route: AppConstants.routeAuctions),
  _NavItem(icon: Icons.build_rounded, label: AppStrings.parts, route: AppConstants.routeParts),
  _NavItem(icon: Icons.person_rounded, label: AppStrings.profile, route: AppConstants.routeProfile),
];

final _adminItems = [
  _NavItem(icon: Icons.dashboard_rounded, label: AppStrings.dashboard, route: AppConstants.routeAdminDashboard),
  _NavItem(imagePath: 'assets/images/auction.png', label: AppStrings.auctions, route: AppConstants.routeAdminAuctions),
  _NavItem(icon: Icons.build_rounded, label: AppStrings.parts, route: AppConstants.routeAdminParts),
  _NavItem(icon: Icons.calendar_today_rounded, label: AppStrings.manageBookings, route: AppConstants.routeAdminBookings),
  _NavItem(icon: Icons.shopping_bag_rounded, label: AppStrings.orders, route: AppConstants.routeAdminOrders),
  _NavItem(icon: Icons.settings_rounded, label: 'Settings', route: AppConstants.routeAdminSettings),
];

class _NavTile extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final bool isSelected;
  final bool isNarrow;
  final VoidCallback onTap;

  const _NavTile({
    this.icon,
    this.imagePath,
    required this.label,
    required this.isSelected,
    this.isNarrow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDesign.radiusXl),
          child: AnimatedContainer(
            duration: AppTheme.animFast,
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              vertical: isNarrow ? 2 : 4,
              horizontal: 2,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: AppTheme.animFast,
                    padding: EdgeInsets.all(isSelected ? 5 : 3),
                    decoration: BoxDecoration(
                      color: isSelected ? AppDesign.primary : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: imagePath != null
                        ? Image.asset(imagePath!, width: 16, height: 16, fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(icon ?? Icons.gavel_rounded,
                                color: isSelected ? Colors.white : AppDesign.getTextTertiary(context), size: 16))
                        : Icon(icon ?? Icons.circle, size: 16,
                            color: isSelected ? Colors.white : AppDesign.getTextTertiary(context)),
                  ),
                  SizedBox(height: isNarrow ? 1 : 2),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: isNarrow ? 8 : 9,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppDesign.getTextPrimary(context) : AppDesign.getTextTertiary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
