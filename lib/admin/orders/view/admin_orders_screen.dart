import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared_widgets/role_bottom_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/admin_part_purchase_model.dart';
import '../controller/admin_orders_controller.dart';
import '../../../core/utils/responsive.dart';

/// Admin part purchases / orders screen - ecommerce orders
class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminOrdersController());

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppTheme.bgPrimary,
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading && controller.purchases.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.redPrimary),
              ),
            );
          }

          return Responsive.constrained(
            Column(
              children: [
                _Header(controller: controller),
                _StatusFilter(controller: controller),
                Expanded(
                  child: controller.purchases.isEmpty
                      ? _EmptyState(controller: controller)
                      : _OrdersList(controller: controller),
                ),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: const RoleBottomNav(currentIndex: 4),
    );
  }
}

class _Header extends StatelessWidget {
  final AdminOrdersController controller;

  const _Header({required this.controller});

  @override
  Widget build(BuildContext context) {
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          return Padding(
            padding: EdgeInsets.fromLTRB(
              isSmallScreen ? 16 : 20,
              isSmallScreen ? 16 : 20,
              isSmallScreen ? 16 : 20,
              isSmallScreen ? 20 : 24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.orders,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                          fontFamily: AppTheme.fontFamily,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallScreen ? 2 : 4),
                      Text(
                        'Part purchases & order history',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 16,
                          color: AppTheme.textSecondary,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.reload,
                  icon: const Icon(Icons.refresh_rounded, color: AppTheme.redPrimary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  final AdminOrdersController controller;

  const _StatusFilter({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: controller.statusFilter == null,
                    onTap: () => controller.setStatusFilter(null),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Pending',
                    isSelected: controller.statusFilter == 'pending',
                    onTap: () => controller.setStatusFilter('pending'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Paid',
                    isSelected: controller.statusFilter == 'paid',
                    onTap: () => controller.setStatusFilter('paid'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Shipped',
                    isSelected: controller.statusFilter == 'shipped',
                    onTap: () => controller.setStatusFilter('shipped'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Delivered',
                    isSelected: controller.statusFilter == 'delivered',
                    onTap: () => controller.setStatusFilter('delivered'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.redPrimary.withValues(alpha: 0.2)
                : AppTheme.bgSecondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppTheme.redPrimary : AppTheme.border,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppTheme.redPrimary : AppTheme.textSecondary,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AdminOrdersController controller;

  const _EmptyState({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.reload,
      color: AppTheme.redPrimary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64,
                  color: AppTheme.textSecondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Orders Yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Part purchases will appear here',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    fontFamily: AppTheme.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  final AdminOrdersController controller;

  const _OrdersList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.reload,
      color: AppTheme.redPrimary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        itemCount: controller.purchases.length + (controller.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.purchases.length) {
            controller.loadMore();
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.redPrimary),
                  ),
                ),
              ),
            );
          }
          final purchase = controller.purchases[index];
          return _OrderCard(purchase: purchase);
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final AdminPartPurchaseModel purchase;

  const _OrderCard({required this.purchase});

  @override
  Widget build(BuildContext context) {
    final part = purchase.part;
    final buyer = purchase.buyer;
    final seller = purchase.seller;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.bgSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:                 part.image != null && part.image!.isNotEmpty
                      ? Image.network(
                          part.image!,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 72,
                              height: 72,
                              color: AppTheme.border,
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.redPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            width: 72,
                            height: 72,
                            color: AppTheme.border,
                            child: const Icon(
                              Icons.build_rounded,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        )
                      : Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppTheme.border.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.build_rounded,
                            color: AppTheme.textSecondary,
                            size: 32,
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        part.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                          fontFamily: AppTheme.fontFamily,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (part.partNumber != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'PN: ${part.partNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                      ],
                      if (part.brand != null || part.category != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          [
                            if (part.brand != null) part.brand,
                            if (part.category != null) part.category,
                          ].join(' • '),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(purchase.status)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _statusColor(purchase.status)
                                    .withValues(alpha: 0.4),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              purchase.statusDisplay,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _statusColor(purchase.status),
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${AppConstants.currency} ${purchase.totalAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.redPrimary,
                              fontFamily: AppTheme.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buyer',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        buyer?.name ?? '—',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                          fontFamily: AppTheme.fontFamily,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (buyer?.email != null)
                        Text(
                          buyer!.email,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            fontFamily: AppTheme.fontFamily,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (buyer?.phone != null)
                        Text(
                          buyer!.phone!,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seller',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        seller?.name ?? '—',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                          fontFamily: AppTheme.fontFamily,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (seller?.email != null)
                        Text(
                          seller!.email,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            fontFamily: AppTheme.fontFamily,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (purchase.shippingAddress != null &&
                purchase.shippingAddress!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Address',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  fontFamily: AppTheme.fontFamily,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                purchase.shippingAddress!,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textPrimary,
                  fontFamily: AppTheme.fontFamily,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Order #${purchase.id} • ${purchase.quantity} × ${AppConstants.currency} ${purchase.soldPrice.toStringAsFixed(0)} • ${_formatDate(purchase.purchasedAt)}',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
                fontFamily: AppTheme.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.warning;
      case 'paid':
        return AppTheme.info;
      case 'shipped':
        return AppTheme.success;
      case 'delivered':
        return AppTheme.success;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
