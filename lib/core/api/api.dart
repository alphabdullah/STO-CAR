/// API Module
///
/// Centralized API configuration and utilities for the STO Car platform.
///
/// Usage:
/// ```dart
/// import 'package:sto_car_app/core/api/api.dart';
///
/// // Use endpoints
/// final url = ApiHelper.buildUrl(ApiEndpoints.login);
///
/// // Use with query parameters
/// final url = ApiHelper.buildUrlWithQuery(
///   ApiEndpoints.getAuctions,
///   {'page': '1', 'per_page': '15'},
/// );
///
/// // Get headers
/// final headers = ApiHelper.getJsonHeadersWithAuth(token);
/// ```
library;

export 'api_endpoints.dart';
export 'api_helper.dart';
