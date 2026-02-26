import 'dart:async';
import 'package:get/get.dart';
import '../models/admin_stats_model.dart';
import '../services/admin_service.dart';
import '../core/api/api_client.dart' as api;
import '../core/api/api_client.dart';
import 'auth_state.dart';

/// Admin statistics state controller
/// Fetches dashboard statistics from API
class AdminStatsState extends GetxController {
  static final AdminStatsState _instance = AdminStatsState._internal();
  factory AdminStatsState() => _instance;
  AdminStatsState._internal();

  final _stats = AdminStatsModel().obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  bool _isLoadingInProgress = false; // Guard to prevent concurrent loads

  Timer? _refreshTimer;

  final AdminService _adminService = AdminService();

  AdminStatsModel get stats => _stats.value;
  bool get isLoading => _isLoading.value;
  String? get errorMessage =>
      _errorMessage.value.isEmpty ? null : _errorMessage.value;

  @override
  void onClose() {
    stopRealTimeUpdates();
    super.onClose();
  }

  /// Start automatic real-time updates every 30 seconds
  void startRealTimeUpdates() {
    print('AdminStatsState: Starting real-time updates (30s interval)');
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      refresh();
    });
  }

  /// Stop automatic updates
  void stopRealTimeUpdates() {
    print('AdminStatsState: Stopping real-time updates');
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Load statistics from API
  Future<void> _loadStats() async {
    // Prevent concurrent loads
    if (_isLoadingInProgress) {
      print('AdminStatsState: Load already in progress, skipping...');
      return;
    }

    // Check if user is authenticated before making API call
    final authState = Get.find<AuthState>();
    final token = authState.currentUser?.token;

    if (token == null || token.isEmpty) {
      print(
        'AdminStatsState: Cannot load stats - no authentication token available',
      );
      _errorMessage.value = 'Please login to view dashboard statistics.';
      _isLoading.value = false;
      _isLoadingInProgress = false;
      return;
    }

    // Ensure token is set in ApiClient
    final apiClient = ApiClient();
    if (apiClient.token != token) {
      print('AdminStatsState: Setting token in ApiClient...');
      apiClient.setToken(token);
    }

    _isLoadingInProgress = true;
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      print('AdminStatsState: Fetching dashboard stats from API...');
      print('AdminStatsState: Token available (full): $token');
      print(
        'AdminStatsState: ApiClient token set: ${apiClient.token != null && apiClient.token!.isNotEmpty}',
      );
      if (apiClient.token != null) {
        print('AdminStatsState: ApiClient token (full): ${apiClient.token}');
      }
      final data = await _adminService.getDashboardStats();
      print('AdminStatsState: Received dashboard data: $data');

      // Parse data into AdminStatsModel
      final stats = AdminStatsModel.fromJson(data);
      print('AdminStatsState: Parsed stats model:');
      print('  - Total Users: ${stats.totalUsers}');
      print('  - Verified Users: ${stats.verifiedUsers}');
      print('  - New This Month: ${stats.newUsersThisMonth}');
      print('  - Total Auctions: ${stats.totalAuctions}');
      print('  - Live Auctions: ${stats.liveAuctions}');
      print('  - Pending Auctions: ${stats.pendingApprovalAuctions}');
      print('  - Closed Auctions: ${stats.closedAuctions}');
      print('  - Total Parts: ${stats.totalParts}');
      print('  - Available Parts: ${stats.availableParts}');
      print('  - Sold Parts: ${stats.soldParts}');
      print('  - Total Bookings: ${stats.totalBookings}');
      print('  - Pending Bookings: ${stats.pendingBookings}');
      print('  - Today Bookings: ${stats.todayBookings}');
      print('  - Completed Bookings: ${stats.completedBookings}');
      print('  - Total Auction Value: ${stats.totalAuctionValue}');
      print('  - Total Parts Sold: ${stats.totalPartsSold}');

      _stats.value = stats;
      _isLoading.value = false;
      _isLoadingInProgress = false;
    } on api.ApiException catch (e) {
      print('AdminStatsState: API error - ${e.message}');
      _errorMessage.value = e.message;
      _isLoading.value = false;
      _isLoadingInProgress = false;
    } catch (e) {
      print('AdminStatsState: Unexpected error - $e');
      _errorMessage.value =
          'Failed to load dashboard statistics. Please try again.';
      _isLoading.value = false;
      _isLoadingInProgress = false;
    }
  }

  /// Refresh statistics from API
  @override
  Future<void> refresh() async {
    await _loadStats();
  }
}
