import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

/// Auction Service
/// Handles all auction-related API calls
class AuctionService {
  AuctionService._();

  static final AuctionService _instance = AuctionService._();
  factory AuctionService() => _instance;

  final ApiClient _apiClient = ApiClient();

  /// Get all auctions with pagination
  ///
  /// Returns a map containing:
  /// - data: List of auction maps
  /// - meta: Pagination metadata
  /// - links: Pagination links
  ///
  /// Throws ApiException on error
  Future<Map<String, dynamic>> getAuctions({int? page}) async {
    try {
      print(
        'AuctionService.getAuctions: Calling endpoint: ${ApiEndpoints.getAuctions}',
      );
      final queryParams = page != null ? {'page': page.toString()} : null;

      final response = await _apiClient.get(
        ApiEndpoints.getAuctions,
        queryParameters: queryParams,
        requiresAuth: false, // Auctions can be viewed by guests
      );

      print('AuctionService.getAuctions: Full response: $response');

      // Parse response
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as List<dynamic>;
        print('AuctionService.getAuctions: Found ${data.length} auctions');

        return {
          'data': data.cast<Map<String, dynamic>>(),
          'meta': response['meta'] as Map<String, dynamic>? ?? {},
          'links': response['links'] as Map<String, dynamic>? ?? {},
        };
      }

      throw ApiException('Invalid response format from server');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get auctions: ${e.toString()}');
    }
  }

  /// Get single auction details
  ///
  /// Throws ApiException on error
  Future<Map<String, dynamic>> getAuction(String id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getAuction(id),
        requiresAuth: false,
      );

      print('AuctionService.getAuction: Full response: $response');

      if (response['success'] == true && response['data'] != null) {
        return response['data'] as Map<String, dynamic>;
      }

      throw ApiException('Invalid response format from server');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get auction: ${e.toString()}');
    }
  }

  /// Get user's bidded auctions
  ///
  /// Returns a map with 'data' (list of auctions), 'meta', and 'links'
  /// Throws ApiException on error
  Future<Map<String, dynamic>> getMyBids({int? page}) async {
    try {
      final queryParams = page != null ? {'page': page.toString()} : null;
      final response = await _apiClient.get(
        ApiEndpoints.getMyBids,
        requiresAuth: true,
        queryParameters: queryParams,
      );

      print('AuctionService.getMyBids: Full response: $response');

      if (response['success'] == true && response['data'] != null) {
        return {
          'data': response['data'] as List<dynamic>,
          'meta': response['meta'] as Map<String, dynamic>? ?? {},
          'links': response['links'] as Map<String, dynamic>? ?? {},
        };
      }

      throw ApiException('Invalid response format from server');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get my bids: ${e.toString()}');
    }
  }

  /// Place a bid on an auction
  ///
  /// Throws ApiException on error
  ///
  /// Handles responses like:
  /// - Success: {"success": true, "message": "...", "data": {...}}
  /// - Error: {"success": false, "message": "Please verify your account to place bids"}
  Future<Map<String, dynamic>> placeBid(String auctionId, double amount) async {
    try {
      print(
        'AuctionService.placeBid: ==========================================',
      );
      print('AuctionService.placeBid: Placing bid on auction $auctionId');
      print('AuctionService.placeBid: Bid amount: $amount');
      print(
        'AuctionService.placeBid: Endpoint: ${ApiEndpoints.placeBid(auctionId)}',
      );
      print('AuctionService.placeBid: Request body: {"amount": $amount}');
      print(
        'AuctionService.placeBid: ==========================================',
      );

      final response = await _apiClient.post(
        ApiEndpoints.placeBid(auctionId),
        body: {'amount': amount},
        requiresAuth: true,
      );

      print(
        'AuctionService.placeBid: ==========================================',
      );
      print('AuctionService.placeBid: FULL API RESPONSE:');
      print('AuctionService.placeBid: $response');
      print('AuctionService.placeBid: Response type: ${response.runtimeType}');
      print('AuctionService.placeBid: Success value: ${response['success']}');
      print(
        'AuctionService.placeBid: Success type: ${response['success'].runtimeType}',
      );
      print('AuctionService.placeBid: Message: ${response['message']}');
      print('AuctionService.placeBid: Data: ${response['data']}');
      print(
        'AuctionService.placeBid: ==========================================',
      );

      // Check if the API returned success: false (even with 200 status)
      // Handles responses like: {"success": false, "message": "Please verify your account to place bids"}
      final successValue = response['success'];
      print(
        'AuctionService.placeBid: Checking success value: $successValue (type: ${successValue.runtimeType})',
      );

      if (successValue == false || successValue != true) {
        final errorMessage =
            response['message']?.toString() ??
            response['error']?.toString() ??
            'Failed to place bid';
        print(
          'AuctionService.placeBid: ==========================================',
        );
        print('AuctionService.placeBid: API returned success=false');
        print('AuctionService.placeBid: Error message: $errorMessage');
        print('AuctionService.placeBid: Throwing ApiException with message');
        print(
          'AuctionService.placeBid: ==========================================',
        );
        throw ApiException(errorMessage);
      }

      // Success case
      print(
        'AuctionService.placeBid: ==========================================',
      );
      print('AuctionService.placeBid: Bid placed successfully!');
      print('AuctionService.placeBid: Response data: ${response['data']}');
      print(
        'AuctionService.placeBid: ==========================================',
      );
      return response['data'] as Map<String, dynamic>? ?? {};
    } on ApiException catch (e) {
      print(
        'AuctionService.placeBid: ==========================================',
      );
      print('AuctionService.placeBid: ApiException caught: ${e.message}');
      print('AuctionService.placeBid: Status code: ${e.statusCode}');
      print('AuctionService.placeBid: Errors: ${e.errors}');
      print(
        'AuctionService.placeBid: ==========================================',
      );
      rethrow;
    } catch (e, stackTrace) {
      print(
        'AuctionService.placeBid: ==========================================',
      );
      print('AuctionService.placeBid: Unexpected error: $e');
      print('AuctionService.placeBid: Stack trace: $stackTrace');
      print(
        'AuctionService.placeBid: ==========================================',
      );
      throw ApiException('Failed to place bid: ${e.toString()}');
    }
  }
}
