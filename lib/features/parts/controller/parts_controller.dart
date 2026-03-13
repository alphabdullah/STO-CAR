import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/guards/verification_guard_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../state/parts_state.dart';
import '../../../state/cart_state.dart';
import '../../../state/auth_state.dart';

/// Unified parts controller for both guest and logged-in users
class PartsController extends GetxController {
  final PartsState _partsState = PartsState();

  /// Navigate to company parts screen
  void navigateToCompanyParts(BuildContext context, String companyId) {
    context.push('${AppConstants.routeParts}/$companyId');
  }

  /// Purchase a part
  Future<void> purchasePart(BuildContext context, String partId) async {
    final part = _partsState.selectedPart;
    if (part == null) {
      _partsState.selectPart(partId);
    }
    final selectedPart = _partsState.selectedPart;
    if (selectedPart == null) return;

    final success = await _partsState.purchasePart(partId, 1);
    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.purchasedSuccess(selectedPart.name)),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.purchaseFailed),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void showPartDetails(BuildContext context, String partId) {
    _partsState.selectPart(partId);
    final part = _partsState.selectedPart;

    if (part == null) return;

    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final isCompact = screenWidth < 380;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: screenWidth < 600 ? 16 : 40,
          vertical: 24,
        ),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520),
          decoration: BoxDecoration(
            color: AppDesign.getBgSecondary(context),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppDesign.getBorder(context).withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black).withValues(alpha: 0.25),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 📸 Hero Image Section (Carousel)
              Stack(
                children: [
                  Container(
                    height: screenWidth < 400 ? 220 : 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppDesign.getBgElevated(context),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: part.images.isNotEmpty
                        ? PageView.builder(
                            itemCount: part.images.length,
                            itemBuilder: (context, index) => ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                              child: Image.network(
                                part.images[index],
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 40,
                                    color: AppDesign.getTextTertiary(c),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : (part.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(32),
                                  ),
                                  child: Image.network(
                                    part.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 40,
                                        color: AppDesign.getTextTertiary(c),
                                      ),
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.settings_suggest_outlined,
                                    color: AppTheme.redPrimary,
                                    size: 80,
                                  ),
                                )),
                  ),
                  // Top Row Actions
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (part.isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.warning,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.bolt, color: Colors.black, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.of(context)!.featured,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        Row(
                          children: [
                            _blurActionButton(
                              icon: Icons.favorite_border_rounded,
                              onTap: () {},
                            ),
                            const SizedBox(width: 10),
                            _blurActionButton(
                              icon: Icons.close_rounded,
                              onTap: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Image Indicators
                  if (part.images.length > 1)
                    Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          part.images.length,
                          (index) => Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // 📝 Info Section
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 16 : 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.redPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              part.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.redPrimary,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getConditionColor(context, part.condition)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              part.condition.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getConditionColor(context, part.condition),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        part.name,
                        style: TextStyle(
                          fontSize: isCompact ? 22 : 26,
                          fontWeight: FontWeight.w800,
                          color: AppDesign.getTextPrimary(context),
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.business_rounded,
                            size: 16,
                            color: AppTheme.redPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            part.brand ?? part.companyName,
                            style: TextStyle(
                              fontSize: 15,
                              color: AppDesign.getTextSecondary(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        part.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppDesign.getTextSecondary(context).withValues(alpha: 0.9),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // 🛠 Specifications Grid
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppDesign.getBgElevated(context),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppDesign.getBorder(context).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildSpecRow(context, AppLocalizations.of(context)!.partInventoryNumber, part.partNumber ?? 'N/A'),
                            Divider(
                              height: 24,
                              color: AppDesign.getBorder(context).withValues(alpha: 0.5),
                            ),
                            _buildSpecRow(context, AppLocalizations.of(context)!.oemReferenceNumber, part.oemNumber ?? 'N/A'),
                            Divider(
                              height: 24,
                              color: AppDesign.getBorder(context).withValues(alpha: 0.5),
                            ),
                            _buildSpecRow(
                              context,
                              'Compatibility',
                              '${part.compatibleMake ?? ""} ${part.compatibleModel ?? ""}'.trim(),
                            ),
                            if (part.yearFrom != null) ...[
                              Divider(
                                height: 24,
                                color: AppDesign.getBorder(context).withValues(alpha: 0.5),
                              ),
                              _buildSpecRow(
                                context,
                                AppLocalizations.of(context)!.yearCompatibility,
                                '${part.yearFrom} - ${part.yearTo ?? AppLocalizations.of(context)!.present}',
                              ),
                            ],
                            Divider(
                              height: 24,
                              color: AppDesign.getBorder(context).withValues(alpha: 0.5),
                            ),
                            _buildSpecRow(
                              context,
                              AppLocalizations.of(context)!.stockStatus,
                              part.stockQuantity > 0
                                  ? AppLocalizations.of(context)!.unitsAvailable(part.stockQuantity)
                                  : AppLocalizations.of(context)!.contactForRestocking,
                              valueColor: part.stockQuantity > 0
                                  ? AppTheme.success
                                  : AppTheme.redPrimary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 💰 Price and CTA section
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final canRow = constraints.maxWidth > 340;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (part.hasDiscount)
                                        Text(
                                          '${part.price.toStringAsFixed(0)} ${part.currency}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppDesign.getTextTertiary(context),
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            part.currentPrice.toStringAsFixed(
                                              0,
                                            ),
                                            style: TextStyle(
                                              fontSize: isCompact ? 32 : 40,
                                              fontWeight: FontWeight.w900,
                                              color: AppDesign.getTextPrimary(context),
                                              letterSpacing: -1.5,
                                              height: 1,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 6,
                                            ),
                                            child: Text(
                                              part.currency,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.redPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (part.isInStock)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      margin: const EdgeInsets.only(bottom: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.success.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppTheme.success.withOpacity(
                                            0.2,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.verified_rounded,
                                            size: 14,
                                            color: AppTheme.success,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            AppLocalizations.of(context)!.inStock.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w900,
                                              color: AppTheme.success,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 28),

                              // 🔥 Action Buttons
                              if (canRow)
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _compactSecondaryButton(
                                        context: context,
                                        onPressed: part.isInStock
                                            ? () => _addToCart(context, part.id)
                                            : null,
                                        label: AppLocalizations.of(context)!.addToCart,
                                        icon: Icons.add_shopping_cart_rounded,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 3,
                                      child: _premiumPrimaryButton(
                                        context: context,
                                        onPressed: part.isInStock
                                            ? () => _purchasePart(
                                                context,
                                                part.id,
                                              )
                                            : null,
                                        label: AppLocalizations.of(context)!.buyNow,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Column(
                                  children: [
                                    _premiumPrimaryButton(
                                      context: context,
                                      onPressed: part.isInStock
                                          ? () =>
                                                _purchasePart(context, part.id)
                                          : null,
                                      label: AppLocalizations.of(context)!.buyNow,
                                      width: double.infinity,
                                    ),
                                    const SizedBox(height: 12),
                                    _compactSecondaryButton(
                                      context: context,
                                      onPressed: part.isInStock
                                          ? () => _addToCart(context, part.id)
                                          : null,
                                      label: AppLocalizations.of(context)!.addToCart,
                                      icon: Icons.add_shopping_cart_rounded,
                                      width: double.infinity,
                                    ),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blurActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _premiumPrimaryButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required String label,
    double? width,
  }) {
    return VerificationGuardWidget(
      actionDescription: AppLocalizations.of(context)!.verifyAccountToPurchase,
      inline: true,
      child: Container(
        width: width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppTheme.redPrimary, AppTheme.redPressed],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.redPrimary.withOpacity(0.35),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _compactSecondaryButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required String label,
    required IconData icon,
    double? width,
  }) {
    return SizedBox(
      width: width,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.redPrimary, width: 1.8),
          foregroundColor: AppTheme.redPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(BuildContext context, String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppDesign.getTextTertiary(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppDesign.getTextPrimary(context),
            ),
          ),
        ),
      ],
    );
  }

  Color _getConditionColor(BuildContext context, String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
        return AppTheme.success;
      case 'used':
        return AppTheme.warning;
      case 'refurbished':
        return AppTheme.info;
      default:
        return AppDesign.getTextTertiary(context);
    }
  }

  Future<void> _addToCart(BuildContext context, String partId) async {
    final authState = Get.isRegistered<AuthState>()
        ? Get.find<AuthState>()
        : null;
    if (authState == null || !authState.isAuthenticated) {
      Navigator.pop(context);
      context.push(AppConstants.routeLogin);
      return;
    }
    final cartState = Get.put(CartState(), permanent: false);
    final ok = await cartState.addToCart(partId);
    if (context.mounted) {
      Navigator.pop(context); // Close dialog
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.productAddedToCart),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _purchasePart(BuildContext context, String partId) async {
    final part = _partsState.selectedPart;
    if (part == null) return;

    final success = await _partsState.purchasePart(partId, 1);
    if (context.mounted) {
      Navigator.pop(context); // Close dialog
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.purchasedSuccess(part.name)),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.purchaseFailed),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
