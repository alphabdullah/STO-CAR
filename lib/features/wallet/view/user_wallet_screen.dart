import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared_widgets/custom_card.dart';
import '../../../core/shared_widgets/custom_button.dart';
import '../../../core/background/app_background.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../core/theme/app_theme.dart';
import '../../../state/auth_state.dart';
import '../../../models/wallet_model.dart';
import '../controller/user_wallet_controller.dart';
import '../../../core/utils/responsive.dart';
import '../../../services/stripe_service.dart';

/// User wallet screen
class UserWalletScreen extends StatefulWidget {
  const UserWalletScreen({super.key});

  @override
  State<UserWalletScreen> createState() => _UserWalletScreenState();
}

class _UserWalletScreenState extends State<UserWalletScreen> {
  @override
  void initState() {
    super.initState();
    // When returning from Stripe Checkout (web) with success + session_id
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final state = GoRouterState.of(context);
        final sessionId = state.uri.queryParameters['session_id'];
        if (state.uri.queryParameters['payment'] == 'success' && sessionId != null) {
          final controller = Get.find<UserWalletController>();
          final authState = Get.find<AuthState>();
          try {
            final stripeService = StripeService();
            final res = await stripeService.verifyCheckoutSession(sessionId);
            if (res['success'] == true && res['data']?['credited'] == true) {
              await controller.loadWalletSummary();
              await authState.refreshUser();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Payment successful! Balance updated.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              await controller.loadWalletSummary();
              await authState.refreshUser();
            }
          } catch (_) {
            await controller.loadWalletSummary();
            await authState.refreshUser();
          }
          if (mounted) context.go('/wallet');
        }
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthState>();
    final controller = Get.put(UserWalletController());

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          title: Text(
            AppStrings.wallet,
            style: TextStyle(
              color: AppDesign.getTextPrimary(context),
              fontWeight: FontWeight.w600,
              fontFamily: AppTheme.fontFamily,
            ),
          ),
        ),
        body: SafeArea(
          child: Responsive.constrained(
            RefreshIndicator(
              onRefresh: () async {
                await controller.loadWalletSummary();
                await authState.refreshUser();
              },
              color: AppTheme.redPrimary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() {
                      final walletSummary = controller.walletSummary;
                      final isVerified = authState.isVerified;
                      final isLoadingSummary = controller.isLoadingSummary;

                      if (isLoadingSummary && walletSummary == null) {
                        return CustomCard(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.redPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      final balance = walletSummary?.balance ?? 0.0;
                      return CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              AppStrings.balance,
                              style: TextStyle(
                                color: AppDesign.getTextSecondary(context),
                                fontSize: 14,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$balance ${AppConstants.currency}',
                              style: TextStyle(
                                color: AppTheme.info,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isVerified ? Icons.verified : Icons.warning,
                                  color: isVerified
                                      ? AppTheme.success
                                      : AppTheme.warning,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isVerified
                                      ? 'Account Verified'
                                      : 'Verification Required',
                                  style: TextStyle(
                                    color: isVerified
                                        ? AppTheme.success
                                        : AppTheme.warning,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    Obx(() {
                      final walletSummary = controller.walletSummary;
                      final transactions =
                          walletSummary?.recentTransactions ?? [];

                      if (transactions.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Transactions',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          CustomCard(
                            child: Column(
                              children: transactions.map((transaction) {
                                return _TransactionItem(
                                  transaction: transaction,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),
                    Obx(() {
                      final isVerified = authState.isVerified;
                      if (isVerified) return const SizedBox.shrink();

                      return CustomCard(
                        color: AppTheme.warning.withValues(alpha: 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppTheme.warning,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppStrings.verificationRequired,
                                  style: TextStyle(
                                    color: AppDesign.getTextPrimary(context),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.verificationDescription,
                              style: TextStyle(
                                color: AppDesign.getTextSecondary(context),
                                fontSize: 14,
                                fontFamily: AppTheme.fontFamily,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.info.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    color: AppTheme.info,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${AppConstants.requiredWalletDeposit} ${AppConstants.currency}',
                                    style: TextStyle(
                                      color: AppTheme.info,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppTheme.fontFamily,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Text(
                      'Deposit Amount',
                      style: TextStyle(
                        color: AppDesign.getTextPrimary(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextField(
                        onChanged: controller.setDepositAmount,
                        decoration: InputDecoration(
                          labelText: 'Amount (${AppConstants.currency})',
                          hintText: 'Enter deposit amount',
                          prefixIcon: const Icon(Icons.account_balance_wallet),
                          errorText: controller.errorMessage,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomButton(
                        text: 'Deposit with Stripe',
                        onPressed: controller.depositAmount > 0
                            ? () => controller.deposit(context)
                            : null,
                        isLoading: controller.isLoading,
                        icon: Icons.credit_card,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Quick Deposit',
                      style: TextStyle(
                        color: AppDesign.getTextPrimary(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text:
                                '${AppConstants.requiredWalletDeposit} ${AppConstants.currency}',
                            onPressed: () => controller.quickDeposit(
                              context,
                              AppConstants.requiredWalletDeposit,
                            ),
                            backgroundColor: AppTheme.info,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/// Transaction item widget
class _TransactionItem extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == 'deposit';
    final amount = transaction.amount;
    final date = DateFormat('MMM dd, yyyy').format(transaction.timestamp);
    final time = DateFormat('hh:mm a').format(transaction.timestamp);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDeposit
                  ? AppTheme.success.withValues(alpha: 0.1)
                  : AppTheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
              color: isDeposit ? AppTheme.success : AppTheme.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ??
                      (isDeposit ? 'Deposit' : 'Withdrawal'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date at $time',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppDesign.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isDeposit ? '+' : '-'}${amount.toStringAsFixed(2)} ${AppConstants.currency}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isDeposit ? AppTheme.success : AppTheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
