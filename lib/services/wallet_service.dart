import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

/// Wallet Service
/// Handles all wallet-related API calls
class WalletService {
  WalletService._();

  static final WalletService _instance = WalletService._();
  factory WalletService() => _instance;

  final ApiClient _apiClient = ApiClient();

  /// Get wallet summary
  /// 
  /// Returns a map containing:
  /// - balance: double
  /// - pending_balance: double
  /// - total_deposits: double
  /// - total_withdrawals: double
  /// - this_month_deposits: double
  /// - this_month_withdrawals: double
  /// - recent_transactions: List<Map<String, dynamic>>
  /// 
  /// Throws ApiException on error
  Future<Map<String, dynamic>> getWalletSummary() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getWalletSummary,
        requiresAuth: true,
      );

      print('WalletService.getWalletSummary: Full response: $response');

      // Parse response
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        print('WalletService.getWalletSummary: Data object: $data');
        return data;
      }

      // Fallback: if response structure is different
      if (response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }

      throw ApiException('Invalid response format from server');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get wallet summary: ${e.toString()}');
    }
  }
}
