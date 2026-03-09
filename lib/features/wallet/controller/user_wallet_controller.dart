import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../state/auth_state.dart';
import '../../../../services/stripe_service.dart';
import '../../../../services/wallet_service.dart';
import '../../../../models/wallet_model.dart';

/// User wallet controller (MVC pattern - Controller layer)
class UserWalletController extends GetxController {
  final AuthState _authState = AuthState();
  final StripeService _stripeService = StripeService();
  final WalletService _walletService = WalletService();

  final _depositAmount = 0.0.obs;
  final _isLoading = false.obs;
  final _isLoadingSummary = false.obs;
  final _errorMessage = ''.obs;
  final _walletSummary = Rxn<WalletSummary>();

  double get depositAmount => _depositAmount.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingSummary => _isLoadingSummary.value;
  String? get errorMessage => _errorMessage.value.isEmpty ? null : _errorMessage.value;
  WalletSummary? get walletSummary => _walletSummary.value;

  @override
  void onInit() {
    super.onInit();
    loadWalletSummary();
  }

  void setDepositAmount(String value) {
    final amount = double.tryParse(value) ?? 0.0;
    _depositAmount.value = amount;
    _errorMessage.value = '';
  }

  /// Load wallet summary from API
  Future<void> loadWalletSummary() async {
    _isLoadingSummary.value = true;
    _walletSummary.value = null;
    try {
      final data = await _walletService.getWalletSummary();
      _walletSummary.value = WalletSummary.fromJson(data);
      print('UserWalletController: Wallet summary loaded: ${_walletSummary.value?.balance}');
    } catch (e) {
      print('UserWalletController.loadWalletSummary error: $e');
      // Show empty summary so UI doesn't stay blank
      _walletSummary.value = const WalletSummary(
        balance: 0,
        pendingBalance: 0,
        totalDeposits: 0,
        totalWithdrawals: 0,
        thisMonthDeposits: 0,
        thisMonthWithdrawals: 0,
        recentTransactions: [],
      );
    } finally {
      _isLoadingSummary.value = false;
    }
  }

  Future<void> deposit(BuildContext context) async {
    if (_depositAmount.value <= 0) {
      _errorMessage.value = 'Please enter a valid amount';
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final response = await _stripeService.handleDeposit(_depositAmount.value);

      if (response['success'] == true) {
        final msg = response['message']?.toString() ??
            'Deposit of ${_depositAmount.value} AED successful!';

        // Web opens new tab - no refresh until user returns. Mobile: refresh now
        await _authState.refreshUser();
        await loadWalletSummary();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.green),
          );
          if (!msg.contains('window opened')) {
            if (_authState.wallet?.isVerified ?? false) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account verified! You can now bid and purchase parts.'),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          }
        }
        _depositAmount.value = 0.0;
      } else {
        _errorMessage.value = response['message'] ?? 'Deposit failed';
      }
    } catch (e) {
      print('UserWalletController.deposit error: $e');
      String msg = 'Deposit failed. Please try again.';
      if (e.toString().contains('StripeConfigException')) {
        msg = 'Stripe payment is only supported on Android and iOS. Please use the mobile app or emulator.';
      } else if (e.toString().contains('Exception:')) {
        msg = e.toString().split('Exception:').last.trim();
      } else if (e.toString().contains('SocketException') || e.toString().contains('Connection refused')) {
        msg = 'Cannot connect to server. Is Laravel backend running on ${ApiEndpoints.baseUrl}?';
      } else if (e.toString().contains('404')) {
        msg = 'Stripe API not found. Check if backend has /api/v1/payments/stripe routes.';
      } else if (e.toString().contains('401') || e.toString().contains('403')) {
        msg = 'Authentication failed. Please login again.';
      }
      _errorMessage.value = msg;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> quickDeposit(BuildContext context, double amount) async {
    _depositAmount.value = amount;
    await deposit(context);
  }
}

