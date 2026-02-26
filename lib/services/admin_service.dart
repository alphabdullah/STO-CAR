import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

/// Admin Service
/// Handles all admin-related API calls
class AdminService {
  AdminService._();

  static final AdminService _instance = AdminService._();
  factory AdminService() => _instance;

  final ApiClient _apiClient = ApiClient();

  /// Get dashboard statistics
  ///
  /// Returns a map containing dashboard statistics:
  /// - users: {total, verified, new_this_month}
  /// - auctions: {total, live, pending, closed}
  /// - parts: {total, available, sold}
  /// - bookings: {total, pending, today, completed}
  /// - revenue: {total_auction_value, total_parts_sold}
  ///
  /// Throws ApiException on error
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getAdminDashboard,
        requiresAuth: true,
      );

      print('AdminService.getDashboardStats: Full response: $response');

      // Parse response
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        print('AdminService.getDashboardStats: Data object: $data');
        return data;
      }

      // Fallback: if response structure is different
      if (response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }

      throw ApiException('Invalid response format from server');
    } catch (e) {
      print('AdminService.getDashboardStats: Error fetching from API: $e');
      rethrow;
    }
  }

  /// Get pending auctions for approval
  ///
  /// Returns a list of auction maps from the API response data array
  ///
  /// Throws ApiException on error
  Future<List<Map<String, dynamic>>> getPendingAuctions() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getPendingAuctions,
        requiresAuth: true,
      );

      print('AdminService.getPendingAuctions: Full response: $response');

      // Parse response
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List<dynamic>;
        print(
          'AdminService.getPendingAuctions: Found ${data.length} pending auctions',
        );
        return data.cast<Map<String, dynamic>>();
      }

      // Fallback: if response structure is different
      if (response['data'] != null && response['data'] is List) {
        return (response['data'] as List<dynamic>).cast<Map<String, dynamic>>();
      }

      throw ApiException('Invalid response format from server');
    } catch (e) {
      print('AdminService.getPendingAuctions: Error: $e');
      rethrow;
    }
  }

  /// Approve an auction
  ///
  /// Throws ApiException on error
  Future<void> approveAuction(String auctionId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.approveAuction(auctionId),
        requiresAuth: true,
      );

      print(
        'AdminService.approveAuction: Response for auction $auctionId: $response',
      );

      if (response['success'] != true) {
        throw ApiException(
          response['message']?.toString() ?? 'Failed to approve auction',
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to approve auction: ${e.toString()}');
    }
  }

  /// Reject an auction
  ///
  /// Throws ApiException on error
  Future<void> rejectAuction(String auctionId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.rejectAuction(auctionId),
        requiresAuth: true,
      );

      print(
        'AdminService.rejectAuction: Response for auction $auctionId: $response',
      );

      if (response['success'] != true) {
        throw ApiException(
          response['message']?.toString() ?? 'Failed to reject auction',
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to reject auction: ${e.toString()}');
    }
  }

  /// Get service bookings
  ///
  /// Returns a list of booking maps from the API response
  ///
  /// Throws ApiException on error
  Future<List<Map<String, dynamic>>> getServiceBookings() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getServiceBookings,
        requiresAuth: true,
      );

      print('AdminService.getServiceBookings: Full response: $response');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      }
      return [];
    } catch (e) {
      print('AdminService.getServiceBookings: Error: $e');
      rethrow;
    }
  }

  /// Approve a booking
  Future<void> approveBooking(String bookingId) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.approveBooking(bookingId),
        requiresAuth: true,
      );

      print('AdminService.approveBooking: Response: $response');

      if (response['success'] != true) {
        throw ApiException(
          response['message']?.toString() ?? 'Failed to approve booking',
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to approve booking: ${e.toString()}');
    }
  }

  /// Reject a booking
  Future<void> rejectBooking(
    String bookingId, {
    required String reason,
    String? notes,
  }) async {
    try {
      final body = {
        "rejection_reason": reason,
        "notes": notes ?? "Please choose another date",
      };

      final response = await _apiClient.post(
        ApiEndpoints.rejectBooking(bookingId),
        body: body,
        requiresAuth: true,
      );

      print('AdminService.rejectBooking: Response: $response');

      if (response['success'] != true) {
        throw ApiException(
          response['message']?.toString() ?? 'Failed to reject booking',
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to reject booking: ${e.toString()}');
    }
  }
}
