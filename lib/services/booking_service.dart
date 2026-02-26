import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

/// Booking Service
/// Handles all booking-related API calls
class BookingService {
  BookingService._();

  static final BookingService _instance = BookingService._();
  factory BookingService() => _instance;

  final ApiClient _apiClient = ApiClient();

  /// Create a service booking
  ///
  /// Body parameters:
  /// - full_name: String
  /// - car_name: String
  /// - car_model: String
  /// - description: String
  /// - prefered_time: String (format: "HH:mm")
  /// - prefered_date: String (format: "YYYY-MM-DD")
  /// - phone_number: String
  ///
  /// Throws ApiException on error
  Future<Map<String, dynamic>> createServiceBooking({
    required String fullName,
    required String carName,
    required String carModel,
    required String description,
    required String preferedTime,
    required String preferedDate,
    required String phoneNumber,
  }) async {
    try {
      print(
        'BookingService.createServiceBooking: ==========================================',
      );
      print('BookingService.createServiceBooking: Creating service booking');
      print(
        'BookingService.createServiceBooking: Endpoint: ${ApiEndpoints.createServiceBooking}',
      );
      print('BookingService.createServiceBooking: Full Name: $fullName');
      print('BookingService.createServiceBooking: Car Name: $carName');
      print('BookingService.createServiceBooking: Car Model: $carModel');
      print('BookingService.createServiceBooking: Description: $description');
      print(
        'BookingService.createServiceBooking: Preferred Time: $preferedTime',
      );
      print(
        'BookingService.createServiceBooking: Preferred Date: $preferedDate',
      );
      print('BookingService.createServiceBooking: Phone Number: $phoneNumber');
      print(
        'BookingService.createServiceBooking: ==========================================',
      );

      final body = {
        'full_name': fullName,
        'car_name': carName,
        'car_model': carModel,
        'description': description,
        'prefered_time': preferedTime,
        'prefered_date': preferedDate,
        'phone_number': phoneNumber,
      };

      print('BookingService.createServiceBooking: Request body: $body');

      final response = await _apiClient.post(
        ApiEndpoints.createServiceBooking,
        body: body,
        requiresAuth: true,
      );

      print(
        'BookingService.createServiceBooking: ==========================================',
      );
      print('BookingService.createServiceBooking: FULL API RESPONSE:');
      print('BookingService.createServiceBooking: $response');
      print(
        'BookingService.createServiceBooking: Response type: ${response.runtimeType}',
      );
      print(
        'BookingService.createServiceBooking: Success value: ${response['success']}',
      );
      print(
        'BookingService.createServiceBooking: Message: ${response['message']}',
      );
      print(
        'BookingService.createServiceBooking: ==========================================',
      );

      // Check if the API returned success: false (even with 200 status)
      if (response['success'] == false) {
        final errorMessage = response['message'] ?? 'Failed to create booking';
        print(
          'BookingService.createServiceBooking: API returned success: false',
        );
        print(
          'BookingService.createServiceBooking: Error message: $errorMessage',
        );
        throw ApiException(errorMessage);
      }

      return response;
    } on ApiException {
      rethrow;
    } catch (e) {
      print('BookingService.createServiceBooking: Unexpected error: $e');
      throw ApiException('Failed to create booking: ${e.toString()}');
    }
  }

  /// Get user's bookings
  ///
  /// Returns a list of booking maps from the API response
  ///
  /// Throws ApiException on error
  Future<List<Map<String, dynamic>>> getBookings() async {
    try {
      print(
        'BookingService.getBookings: ==========================================',
      );
      print('BookingService.getBookings: Fetching user bookings');
      print(
        'BookingService.getBookings: Endpoint: ${ApiEndpoints.getBookings}',
      );
      print(
        'BookingService.getBookings: ==========================================',
      );

      final response = await _apiClient.get(
        ApiEndpoints.getBookings,
        requiresAuth: true,
      );

      print(
        'BookingService.getBookings: ==========================================',
      );
      print('BookingService.getBookings: FULL API RESPONSE:');
      print('BookingService.getBookings: $response');
      print(
        'BookingService.getBookings: Response type: ${response.runtimeType}',
      );
      print(
        'BookingService.getBookings: Success value: ${response['success']}',
      );
      print('BookingService.getBookings: Message: ${response['message']}');
      print('BookingService.getBookings: Data: ${response['data']}');
      print(
        'BookingService.getBookings: ==========================================',
      );

      // Check if the API returned success: false (even with 200 status)
      if (response['success'] == false) {
        final errorMessage = response['message'] ?? 'Failed to fetch bookings';
        print('BookingService.getBookings: API returned success: false');
        print('BookingService.getBookings: Error message: $errorMessage');
        throw ApiException(errorMessage);
      }

      // Parse response data
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        if (data is List) {
          print('BookingService.getBookings: Found ${data.length} bookings');
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map<String, dynamic> && data.containsKey('data')) {
          // Handle paginated response
          final bookingsList = data['data'] as List<dynamic>?;
          if (bookingsList != null) {
            print(
              'BookingService.getBookings: Found ${bookingsList.length} bookings (paginated)',
            );
            return bookingsList.cast<Map<String, dynamic>>();
          }
        }
      }

      print(
        'BookingService.getBookings: No bookings found or invalid response format',
      );
      return [];
    } on ApiException {
      rethrow;
    } catch (e) {
      print('BookingService.getBookings: Unexpected error: $e');
      throw ApiException('Failed to fetch bookings: ${e.toString()}');
    }
  }

  /// Get available service types
  Future<List<String>> getServiceTypes() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getServiceTypes,
        requiresAuth: false,
      );

      print('BookingService.getServiceTypes: Full response: $response');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        if (data is List) {
          return data.map((item) => item['name']?.toString() ?? '').toList();
        }
      }
      return [];
    } catch (e) {
      print('BookingService.getServiceTypes: Error: $e');
      return [];
    }
  }
}
