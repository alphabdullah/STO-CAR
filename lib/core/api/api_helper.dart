import 'api_endpoints.dart';

/// API Helper Utilities
/// 
/// Provides helper methods for building complete API URLs and handling
/// common API-related operations.
class ApiHelper {
  ApiHelper._();

  /// Builds a complete URL from a relative endpoint path
  /// 
  /// Example:
  /// ```dart
  /// final url = ApiHelper.buildUrl(ApiEndpoints.login);
  /// // Returns: http://localhost:8000/api/v1/auth/login
  /// ```
  static String buildUrl(String endpoint) {
    // Remove leading slash if present to avoid double slashes
    final cleanEndpoint = endpoint.startsWith('/') 
        ? endpoint.substring(1) 
        : endpoint;
    
    return '${ApiEndpoints.baseUrl}/$cleanEndpoint';
  }

  /// Builds a complete URL with query parameters
  /// 
  /// Example:
  /// ```dart
  /// final url = ApiHelper.buildUrlWithQuery(
  ///   ApiEndpoints.getAuctions,
  ///   {'page': '1', 'per_page': '15'},
  /// );
  /// // Returns: http://localhost:8000/api/v1/auctions?page=1&per_page=15
  /// ```
  static String buildUrlWithQuery(
    String endpoint,
    Map<String, String> queryParameters,
  ) {
    final baseUrl = buildUrl(endpoint);
    
    if (queryParameters.isEmpty) {
      return baseUrl;
    }

    final queryString = queryParameters.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseUrl?$queryString';
  }

  /// Gets the authorization header value for Bearer token
  /// 
  /// Example:
  /// ```dart
  /// final headers = {
  ///   'Authorization': ApiHelper.getBearerToken('your_token_here'),
  /// };
  /// ```
  static String getBearerToken(String token) => 'Bearer $token';

  /// Gets standard headers for JSON requests
  /// 
  /// Example:
  /// ```dart
  /// final headers = ApiHelper.getJsonHeaders();
  /// ```
  static Map<String, String> getJsonHeaders() => {
        'Content-Type': ApiEndpoints.contentTypeJson,
        'Accept': ApiEndpoints.acceptJson,
      };

  /// Gets standard headers for JSON requests with authorization
  /// 
  /// Example:
  /// ```dart
  /// final headers = ApiHelper.getJsonHeadersWithAuth('your_token_here');
  /// ```
  static Map<String, String> getJsonHeadersWithAuth(String token) => {
        'Content-Type': ApiEndpoints.contentTypeJson,
        'Accept': ApiEndpoints.acceptJson,
        'Authorization': getBearerToken(token),
      };

  /// Gets headers for multipart/form-data requests
  /// 
  /// Example:
  /// ```dart
  /// final headers = ApiHelper.getMultipartHeaders();
  /// ```
  static Map<String, String> getMultipartHeaders() => {
        'Content-Type': ApiEndpoints.contentTypeMultipart,
        'Accept': ApiEndpoints.acceptJson,
      };

  /// Gets headers for multipart/form-data requests with authorization
  /// 
  /// Example:
  /// ```dart
  /// final headers = ApiHelper.getMultipartHeadersWithAuth('your_token_here');
  /// ```
  static Map<String, String> getMultipartHeadersWithAuth(String token) => {
        'Content-Type': ApiEndpoints.contentTypeMultipart,
        'Accept': ApiEndpoints.acceptJson,
        'Authorization': getBearerToken(token),
      };
}
