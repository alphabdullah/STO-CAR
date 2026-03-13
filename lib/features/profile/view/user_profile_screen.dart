import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import 'package:sto_car_app/l10n/app_localizations.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/auth_state.dart';
import '../../../state/theme_state.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/api/api_endpoints.dart';

/// User profile screen
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = Get.put(AuthState());

    return Scaffold(
      backgroundColor: AppDesign.getBgPrimary(context),
      appBar: AppBar(
        backgroundColor: AppDesign.getBgPrimary(context),
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: AppDesign.getTextPrimary(context)),
      ),
      body: SafeArea(
        child: Responsive.constrained(
          RefreshIndicator(
            onRefresh: () async {
              await authState.refreshUser();
            },
            color: AppTheme.redPrimary,
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh even when content is short
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section with Gradient
                  Obx(() {
                    final user = authState.currentUser;
                    final isVerified = user?.isVerified ?? false;

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.redPrimary.withValues(alpha: 0.2),
                            AppTheme.redPressed.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                        child: Column(
                          children: [
                            // Profile Avatar
                            Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.redPrimary,
                                        AppTheme.redPressed,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.redPrimary.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.bgSecondary,
                                    ),
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 60,
                                      color: AppTheme.redPrimary,
                                    ),
                                  ),
                                ),
                                // Verification Badge
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isVerified
                                          ? AppTheme.success
                                          : AppTheme.warning,
                                      border: Border.all(
                                        color: AppTheme.bgSecondary,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      isVerified
                                          ? Icons.verified_rounded
                                          : Icons.warning_rounded,
                                      size: 20,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // User Name
                            Text(
                              user?.name ?? 'User',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                                fontFamily: AppTheme.fontFamily,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Email
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.textSecondary,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Verification Status Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isVerified
                                      ? [
                                          AppTheme.success,
                                          AppTheme.success.withValues(
                                            alpha: 0.8,
                                          ),
                                        ]
                                      : [
                                          AppTheme.warning,
                                          AppTheme.warning.withValues(
                                            alpha: 0.8,
                                          ),
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (isVerified
                                                ? AppTheme.success
                                                : AppTheme.warning)
                                            .withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isVerified
                                        ? Icons.verified_rounded
                                        : Icons.warning_rounded,
                                    size: 20,
                                    color: AppTheme.textPrimary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isVerified
                                        ? AppLocalizations.of(context)!
                                            .verifiedAccount
                                        : AppLocalizations.of(context)!
                                            .notVerified,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                      fontFamily: AppTheme.fontFamily,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Theme Selection Section
                  _buildThemeSelector(context),

                  // Account Information Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.accountInformation,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            fontFamily: AppTheme.fontFamily,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Obx(() {
                          final user = authState.currentUser;
                          return Column(
                            children: [
                              _InfoCard(
                                icon: Icons.email_outlined,
                                iconColor: AppTheme.info,
                                label: AppLocalizations.of(context)!.email,
                                value: user?.email ?? 'N/A',
                              ),
                              const SizedBox(height: 12),
                              _InfoCard(
                                icon: Icons.badge_outlined,
                                iconColor: AppTheme.warning,
                                label: AppLocalizations.of(context)!.role,
                                value:
                                    user?.role
                                        .toString()
                                        .split('.')
                                        .last
                                        .capitalizeFirst ??
                                    'User',
                              ),
                              const SizedBox(height: 12),
                              _InfoCard(
                                icon: Icons.calendar_today_outlined,
                                iconColor: AppTheme.redPrimary,
                                label:
                                    AppLocalizations.of(context)!.memberSince,
                                value: user?.createdAt != null
                                    ? user!.createdAt!.toString().split(' ')[0]
                                    : 'N/A',
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                  Obx(() {
                    final user = authState.currentUser;
                    final front = user?.registrationImageFront;
                    final back = user?.registrationImageBack;
                    final hasFront = front != null && front.toString().trim().isNotEmpty;
                    final hasBack = back != null && back.toString().trim().isNotEmpty;
                    if (!hasFront && !hasBack) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.emiratesId,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                              fontFamily: AppTheme.fontFamily,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildIdImageCard(
                                  context,
                                  label: AppLocalizations.of(context)!.frontSide,
                                  imageUrl: hasFront ? front : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildIdImageCard(
                                  context,
                                  label: AppLocalizations.of(context)!.backSide,
                                  imageUrl: hasBack ? back : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.redPrimary, AppTheme.redPressed],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.redPrimary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showLogoutDialog(context),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  color: AppTheme.textPrimary,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  AppLocalizations.of(context)!.logout,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                    fontFamily: AppTheme.fontFamily,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const RoleBottomNav(currentIndex: 4),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    final themeState = Get.find<ThemeState>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.appTheme,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppDesign.getTextPrimary(context),
              fontFamily: AppTheme.fontFamily,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final mode = themeState.themeMode;
            return Row(
              children: [
                Expanded(
                  child: _ThemeOption(
                    label: AppLocalizations.of(context)!.lightTheme,
                    icon: Icons.light_mode_rounded,
                    isSelected: mode == ThemeMode.light,
                    onTap: themeState.setLight,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ThemeOption(
                    label: AppLocalizations.of(context)!.darkTheme,
                    icon: Icons.dark_mode_rounded,
                    isSelected: mode == ThemeMode.dark,
                    onTap: themeState.setDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ThemeOption(
                    label: AppLocalizations.of(context)!.systemTheme,
                    icon: Icons.settings_brightness_rounded,
                    isSelected: mode == ThemeMode.system,
                    onTap: themeState.setSystem,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppDesign.getBgSecondary(context),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.redPrimary.withValues(alpha: 0.2),
                        AppTheme.redPressed.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.redPrimary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    size: 32,
                    color: AppTheme.redPrimary,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  AppLocalizations.of(context)!.logoutTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppDesign.getTextPrimary(context),
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  AppLocalizations.of(context)!.logoutMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppDesign.getTextSecondary(context),
                    fontFamily: AppTheme.fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppDesign.getBgElevated(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppDesign.getBorder(context),
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppDesign.getTextPrimary(context),
                                  fontFamily: AppTheme.fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.redPrimary, AppTheme.redPressed],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.redPrimary.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final authState = AuthState();
                              await authState.logout();
                              if (context.mounted) {
                                Navigator.pop(context);
                                context.go(AppConstants.routeHomeFeature);
                              }
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.logout,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: AppTheme.fontFamily,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _resolveImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return '';
    final u = url.trim();
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
    final base = ApiEndpoints.baseUrl.replaceFirst(RegExp(r'/api.*'), '');
    return base.endsWith('/') ? '$base${u.replaceFirst(RegExp(r'^/'), '')}' : '$base$u';
  }

  Widget _buildIdImageCard(
    BuildContext context, {
    required String label,
    String? imageUrl,
  }) {
    final resolvedUrl = _resolveImageUrl(imageUrl);
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: resolvedUrl.isNotEmpty
                  ? Image.network(
                      resolvedUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppTheme.bgElevated,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(AppTheme.redPrimary),
                              value:
                                  progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIdImagePlaceholder();
                      },
                    )
                  : _buildIdImagePlaceholder(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdImagePlaceholder() {
    return Container(
      color: AppTheme.bgElevated,
      child: Center(
        child: Icon(
          Icons.document_scanner_outlined,
          size: 36,
          color: AppTheme.textMuted,
        ),
      ),
    );
  }
}

/// Theme option chip (Light / Dark / System)
class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.redPrimary.withValues(alpha: 0.15)
                : AppDesign.getBgSecondary(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppTheme.redPrimary : AppDesign.getBorder(context),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? AppTheme.redPrimary : AppDesign.getTextSecondary(context),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppTheme.redPrimary : AppDesign.getTextSecondary(context),
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Info Card Widget
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppDesign.getBgSecondary(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppDesign.getBorder(context), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: (Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black)
                .withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withValues(alpha: 0.2),
                  iconColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: iconColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppDesign.getTextSecondary(context),
                    fontWeight: FontWeight.w500,
                    fontFamily: AppTheme.fontFamily,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppDesign.getTextPrimary(context),
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.fontFamily,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
