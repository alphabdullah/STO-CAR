import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../../../models/cart_item_model.dart';
import '../../../state/cart_state.dart';
import '../../../state/auth_state.dart';
import '../../../state/parts_state.dart';

/// Cart screen - view items, update quantity, checkout
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = Get.put(CartState());
    final authState = Get.put(AuthState());

    return Scaffold(
      backgroundColor: AppDesign.getBgPrimary(context),
      appBar: AppBar(
        title: const Text(
          AppStrings.cart,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppConstants.routeParts),
        ),
      ),
      body: authState.isAuthenticated
          ? Responsive.constrained(
              Obx(() {
                if (cartState.isLoading.value && cartState.items.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.redPrimary,
                    ),
                  );
                }
                if (cartState.items.isEmpty) {
                  return _EmptyCart();
                }
                return RefreshIndicator(
                  onRefresh: () => cartState.fetchCart(),
                  color: AppTheme.redPrimary,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    children: [
                      const SizedBox(height: 8),
                      if (cartState.error.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppTheme.error,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    cartState.error.value,
                                    style: const TextStyle(
                                      color: AppTheme.error,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ...cartState.items.map(
                        (item) =>
                            _CartItemCard(item: item, cartState: cartState),
                      ),
                      const SizedBox(height: 24),
                      _CheckoutSummary(cartState: cartState),
                    ],
                  ),
                );
              }),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, size: 64, color: AppDesign.getTextTertiary(context)),
                  const SizedBox(height: 16),
                  const Text(
                    'Login required to view cart',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.push(AppConstants.routeLogin),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.redPrimary,
                    ),
                    child: const Text(AppStrings.login),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: authState.isAuthenticated
          ? const RoleBottomNav(currentIndex: -1)
          : null,
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppDesign.getTextTertiary(context),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.yourCartIsEmpty,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.continueShopping,
              style: TextStyle(color: AppDesign.getTextSecondary(context)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go(AppConstants.routeParts),
              icon: const Icon(Icons.storefront_rounded),
              label: const Text(AppStrings.continueShopping),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.redPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final CartState cartState;

  const _CartItemCard({required this.item, required this.cartState});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.imageUrl != null
                  ? Image.network(
                      item.imageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, __) => _placeholder(ctx),
                    )
                  : _placeholder(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price.toStringAsFixed(0)} ${item.currency} × ${item.quantity} = ${item.subtotal.toStringAsFixed(0)} ${item.currency}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppDesign.getTextSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QtySelector(
                        value: item.quantity,
                        onDecrement: () {
                          if (item.quantity > 1)
                            cartState.updateQuantity(
                              item.id,
                              item.quantity - 1,
                            );
                        },
                        onIncrement: () => cartState.updateQuantity(
                          item.id,
                          item.quantity + 1,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppTheme.error,
                          size: 22,
                        ),
                        onPressed: () => cartState.removeFromCart(item.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
    width: 80,
    height: 80,
    color: AppDesign.getBgElevated(context),
    child: Icon(Icons.image_not_supported, color: AppDesign.getTextTertiary(context)),
  );
}

class _QtySelector extends StatelessWidget {
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QtySelector({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppDesign.getBorder(context)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: onDecrement,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$value',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton.filledTonal(
            icon: const Icon(Icons.add, size: 18),
            onPressed: onIncrement,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

class _CheckoutSummary extends StatelessWidget {
  final CartState cartState;

  const _CheckoutSummary({required this.cartState});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = cartState.subtotal.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppDesign.getBgSecondary(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppDesign.getBorder(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: TextStyle(color: AppDesign.getTextSecondary(context)),
                ),
                Text(
                  '${total.toStringAsFixed(0)} ${AppConstants.currency}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: total > 0
                    ? () => _showCheckoutSheet(context, cartState)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.redPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  AppStrings.checkout,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showCheckoutSheet(BuildContext context, CartState cartState) {
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppDesign.getBgSecondary(ctx),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter shipping address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Full address, city, postal code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  onPressed: cartState.isLoading.value
                      ? null
                      : () async {
                          final addr = addressController.text.trim();
                          if (addr.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please enter shipping address',
                              backgroundColor: AppTheme.error.withOpacity(0.8),
                            );
                            return;
                          }
                          final result = await cartState.checkout(addr);
                          if (context.mounted) Navigator.pop(ctx);
                          if (result != null) {
                            Get.find<PartsState>().loadMyPurchases();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Purchase complete! Total: ${result['total_amount']} ${AppConstants.currency}',
                                ),
                                backgroundColor: AppTheme.success,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            context.go(AppConstants.routeParts);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.redPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: cartState.isLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Confirm Purchase'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
