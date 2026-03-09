import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/purchase_history_model.dart';
import '../../../state/parts_state.dart';

/// Screen showing user's part purchase history
class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<PartsState>().loadMyPurchases();
  }

  @override
  Widget build(BuildContext context) {
    final partsState = Get.find<PartsState>();

    return Scaffold(
      backgroundColor: AppDesign.getBgPrimary(context),
      appBar: AppBar(
        backgroundColor: AppDesign.getBgPrimary(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppDesign.getTextPrimary(context)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Purchase History',
          style: TextStyle(
            color: AppDesign.getTextPrimary(context),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (partsState.isLoadingPurchases && partsState.purchaseHistory.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: AppTheme.redPrimary,
            ),
          );
        }

        final purchases = partsState.purchaseHistory;

        if (purchases.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: AppDesign.getTextTertiary(context),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No purchases yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppDesign.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Parts you purchase will appear here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppDesign.getTextSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go(AppConstants.routeParts),
                    icon: const Icon(Icons.storefront_rounded, size: 20),
                    label: const Text('Browse Parts'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.redPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => partsState.loadMyPurchases(),
          color: AppTheme.redPrimary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              final p = purchases[index];
              return _PurchaseHistoryCard(purchase: p);
            },
          ),
        );
      }),
    );
  }
}

class _PurchaseHistoryCard extends StatelessWidget {
  final PurchaseHistoryModel purchase;

  const _PurchaseHistoryCard({required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppDesign.getBgSecondary(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppDesign.getBorder(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: purchase.partImageUrl != null && purchase.partImageUrl!.isNotEmpty
                  ? Image.network(
                      purchase.partImageUrl!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, __) => _buildPlaceholder(ctx),
                    )
                  : _buildPlaceholder(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    purchase.partName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppDesign.getTextPrimary(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Seller: ${purchase.sellerName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppDesign.getTextSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${purchase.quantity} × ${AppConstants.currency} ${purchase.soldPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppDesign.getTextTertiary(context),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppConstants.currency} ${purchase.totalAmount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.redPrimary,
                        ),
                      ),
                      Text(
                        DateFormat('MMM d, yyyy').format(purchase.purchasedAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppDesign.getTextTertiary(context),
                        ),
                      ),
                    ],
                  ),
                  if (purchase.trackingNumber != null && purchase.trackingNumber!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Tracking: ${purchase.trackingNumber}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.info,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      color: AppDesign.getBgElevated(context),
      child: Icon(Icons.build_rounded, color: AppDesign.getTextTertiary(context), size: 28),
    );
  }
}
