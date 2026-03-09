import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../services/admin_service.dart';
import '../../../core/api/api_client.dart' as api;
import '../../../models/auction_model.dart';
import '../../../core/api/api_client.dart';
import '../../../state/auth_state.dart';
import '../../../state/auction_state.dart';

/// Admin auction controller (MVC pattern - Controller layer)
class AdminAuctionController extends GetxController {
  static final AdminAuctionController _instance =
      AdminAuctionController._internal();
  factory AdminAuctionController() => _instance;
  AdminAuctionController._internal();

  final AdminService _adminService = AdminService();
  final _isLoading = false.obs;
  final _pendingAuctions = <AuctionModel>[].obs;
  final _isLoadingPending = false.obs;
  bool _hasLoadedPendingAuctions = false;

  bool get isLoading => _isLoading.value;
  bool get isLoadingPending => _isLoadingPending.value;
  List<AuctionModel> get pendingAuctions => _pendingAuctions;

  /// Load pending auctions from API
  ///
  /// [forceRefresh] - If true, will reload even if data already exists
  Future<void> loadPendingAuctions({bool forceRefresh = false}) async {
    // If already loaded and not forcing refresh, skip
    if (_hasLoadedPendingAuctions &&
        !forceRefresh &&
        _pendingAuctions.isNotEmpty) {
      print(
        'AdminAuctionController: Pending auctions already loaded (${_pendingAuctions.length} items), skipping...',
      );
      return;
    }

    // Check if user is authenticated
    final authState = Get.find<AuthState>();
    final token = authState.currentUser?.token;

    if (token == null || token.isEmpty) {
      print('AdminAuctionController: Cannot load pending auctions - no token');
      return;
    }

    // Ensure token is set in ApiClient
    final apiClient = ApiClient();
    if (apiClient.token != token) {
      apiClient.setToken(token);
    }

    print('AdminAuctionController: Token (full): $token');
    print('AdminAuctionController: ApiClient token (full): ${apiClient.token}');

    if (_isLoadingPending.value) {
      print(
        'AdminAuctionController: Already loading, skipping duplicate request',
      );
      return; // Already loading
    }

    _isLoadingPending.value = true;

    try {
      print('AdminAuctionController: Fetching pending auctions from API...');
      final auctionsData = await _adminService.getPendingAuctions();
      print(
        'AdminAuctionController: Received ${auctionsData.length} pending auctions',
      );

      // Parse each auction from JSON
      final auctions = auctionsData
          .map((json) => AuctionModel.fromJson(json))
          .toList();

      _pendingAuctions.value = auctions;
      _hasLoadedPendingAuctions = true;
      print('AdminAuctionController: Parsed ${auctions.length} auctions');
    } on api.ApiException catch (e) {
      print('AdminAuctionController: API error - ${e.message}');
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('AdminAuctionController: Unexpected error - $e');
      Get.snackbar(
        'Error',
        'Failed to load pending auctions. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoadingPending.value = false;
    }
  }

  Future<void> approveAuction(String auctionId) async {
    _isLoading.value = true;
    try {
      await _adminService.approveAuction(auctionId);
      Get.snackbar(
        AppStrings.success,
        'Auction approved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      // Remove from pending list and refresh
      _pendingAuctions.removeWhere((a) => a.id == auctionId);
      // Reload to get fresh data
      await loadPendingAuctions(forceRefresh: true);
    } on api.ApiException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to approve auction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> rejectAuction(String auctionId) async {
    _isLoading.value = true;
    try {
      await _adminService.rejectAuction(auctionId);
      Get.snackbar(
        AppStrings.success,
        'Auction rejected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      // Remove from pending list and refresh
      _pendingAuctions.removeWhere((a) => a.id == auctionId);
      // Reload to get fresh data
      await loadPendingAuctions(forceRefresh: true);
    } on api.ApiException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject auction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateAuctionPrice(
    String auctionId, {
    required double startingBid,
    double? currentBid,
    double? bidIncrement,
  }) async {
    _isLoading.value = true;
    try {
      await _adminService.updateAuction(
        auctionId,
        startingBid: startingBid,
        currentBid: currentBid,
        bidIncrement: bidIncrement,
      );
      Get.snackbar(
        AppStrings.success,
        'Auction price updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      await loadPendingAuctions(forceRefresh: true);
      Get.find<AuctionState>().loadAuctions(forceRefresh: true);
    } on api.ApiException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update auction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
