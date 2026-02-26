import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

/// Parts Service - Matched with sto_car backend
/// Handles all parts-related API calls
class PartsService {
  PartsService._();

  static final PartsService _instance = PartsService._();
  factory PartsService() => _instance;

  final ApiClient _apiClient = ApiClient();

  /// Get all parts with filters - Supports all backend options
  ///
  /// Returns a map containing:
  /// - data: List of part maps
  /// - meta: Pagination metadata
  Future<Map<String, dynamic>> getParts({
    int? page,
    String? category,
    int? perPage,
    String? brand,
    String? condition,
    String? make,
    String? model,
    int? year,
    double? minPrice,
    double? maxPrice,
    String? search,
    bool? featured,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (page != null) queryParams['page'] = page.toString();
      if (category != null) queryParams['category'] = category;
      if (perPage != null) queryParams['per_page'] = perPage.toString();
      if (brand != null) queryParams['brand'] = brand;
      if (condition != null) queryParams['condition'] = condition;
      if (make != null) queryParams['make'] = make;
      if (model != null) queryParams['model'] = model;
      if (year != null) queryParams['year'] = year.toString();
      if (minPrice != null) queryParams['min_price'] = minPrice.toString();
      if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
      if (search != null) queryParams['search'] = search;
      if (featured != null) queryParams['featured'] = featured.toString();

      final response = await _apiClient.get(
        ApiEndpoints.getParts,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        requiresAuth: false,
      );

      if (response['success'] == true && response['data'] != null) {
        return {
          'data': response['data'] is List
              ? response['data']
              : (response['data']['data'] ?? []),
          'meta': response['meta'] ?? response['data']['meta'] ?? {},
        };
      }

      throw ApiException('Invalid response format from server');
    } catch (e) {
      rethrow;
    }
  }

  /// Get part categories
  Future<List<String>> getCategories() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getPartCategories,
        requiresAuth: false,
      );

      if (response['success'] == true && response['data'] != null) {
        return List<String>.from(response['data']);
      }

      throw ApiException('Invalid response format from server');
    } catch (e) {
      rethrow;
    }
  }

  /// Purchase a part
  Future<Map<String, dynamic>> purchasePart(
    String partId, {
    int quantity = 1,
    required String shippingAddress,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.purchasePart(partId),
        body: {'quantity': quantity, 'shipping_address': shippingAddress},
        requiresAuth: true,
      );

      if (response['success'] == true) {
        return response['data'] ?? {};
      }

      throw ApiException(response['message'] ?? 'Purchase failed');
    } catch (e) {
      rethrow;
    }
  }

  /// Add/Remove from favorites
  Future<void> toggleFavorite(String partId, bool isFavorite) async {
    try {
      if (isFavorite) {
        await _apiClient.post(
          ApiEndpoints.addPartToFavorites(partId),
          requiresAuth: true,
        );
      } else {
        await _apiClient.delete(
          ApiEndpoints.removePartFromFavorites(partId),
          requiresAuth: true,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user's parts
  Future<List<dynamic>> getMyParts() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getMyParts,
        requiresAuth: true,
      );
      if (response['success'] == true) {
        return response['data'] is List
            ? response['data']
            : (response['data']['data'] ?? []);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
