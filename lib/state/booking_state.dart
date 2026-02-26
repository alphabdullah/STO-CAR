import 'package:get/get.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';
import '../services/admin_service.dart';
import '../core/api/api_client.dart' as api;

/// Booking state controller
/// Manages service bookings and dynamic forms
class BookingState extends GetxController {
  static final BookingState _instance = BookingState._internal();
  factory BookingState() => _instance;
  BookingState._internal();

  // Observable state
  final _bookings = <BookingModel>[].obs;
  final _serviceTypes = <String>[].obs;
  final _selectedBooking = Rxn<BookingModel>();
  final _isLoading = false.obs;
  final BookingService _bookingService = BookingService();
  bool _hasLoadedBookings = false;
  bool _isLoadingInProgress = false;

  // Getters
  List<BookingModel> get bookings => _bookings;
  List<String> get serviceTypes => _serviceTypes;
  BookingModel? get selectedBooking => _selectedBooking.value;
  bool get isLoading => _isLoading.value;

  List<BookingModel> get pendingBookings =>
      _bookings.where((b) => b.isPending).toList();

  @override
  void onInit() {
    super.onInit();
    // Don't load immediately - wait for screen to call loadBookings
    _initializeServiceTypes();
  }

  /// Initialize service types from API
  Future<void> _initializeServiceTypes() async {
    try {
      final types = await _bookingService.getServiceTypes();
      if (types.isNotEmpty) {
        _serviceTypes.value = types;
      } else {
        // Fallback to minimal defaults if API returns empty but keep it lean
        _serviceTypes.value = ['General Maintenance'];
      }
    } catch (e) {
      print('BookingState: Error loading service types: $e');
    }
  }

  /// Load bookings from API
  ///
  /// [forceRefresh] - If true, will reload even if data already exists
  Future<void> loadBookings({bool forceRefresh = false}) async {
    // If already loaded and not forcing refresh, skip
    if (_hasLoadedBookings && !forceRefresh) {
      print('BookingState.loadBookings: Bookings already loaded, skipping...');
      return;
    }

    // Prevent concurrent API calls
    if (_isLoadingInProgress) {
      print('BookingState.loadBookings: Load already in progress, skipping...');
      return;
    }

    _isLoadingInProgress = true;
    _isLoading.value = true;
    update();

    try {
      print('BookingState.loadBookings: Fetching bookings from API...');
      final bookingsData = await _bookingService.getBookings();

      print(
        'BookingState.loadBookings: Received ${bookingsData.length} bookings from API',
      );

      // Parse bookings from API response
      final parsedBookings = bookingsData
          .map((bookingJson) {
            try {
              return BookingModel.fromJson(bookingJson);
            } catch (e) {
              print('BookingState.loadBookings: Error parsing booking: $e');
              print('BookingState.loadBookings: Booking JSON: $bookingJson');
              return null;
            }
          })
          .whereType<BookingModel>()
          .toList();

      print(
        'BookingState.loadBookings: Successfully parsed ${parsedBookings.length} bookings',
      );

      _bookings.value = parsedBookings;
      _hasLoadedBookings = true;
      _isLoading.value = false;
      _isLoadingInProgress = false;
      update();

      print('BookingState.loadBookings: Bookings loaded successfully');
    } on api.ApiException catch (e) {
      print('BookingState.loadBookings: API error - ${e.message}');
      _isLoading.value = false;
      _isLoadingInProgress = false;
      update();
      // Don't clear existing bookings on error, just show error
    } catch (e) {
      print('BookingState.loadBookings: Unexpected error - $e');
      _isLoading.value = false;
      _isLoadingInProgress = false;
      update();
    }
  }

  /// Get fields for a service type
  List<BookingField> getFieldsForServiceType(String serviceType) {
    // In real app, this would fetch from backend
    // For now, return a generic template
    return [
      BookingField(
        id: 'car_model',
        label: 'Car Model',
        type: BookingFieldType.text,
        isRequired: true,
        placeholder: 'Enter car model',
      ),
      BookingField(
        id: 'car_year',
        label: 'Car Year',
        type: BookingFieldType.number,
        isRequired: true,
        placeholder: 'Enter car year',
      ),
      BookingField(
        id: 'preferred_date',
        label: 'Preferred Date',
        type: BookingFieldType.date,
        isRequired: true,
      ),
      BookingField(
        id: 'preferred_time',
        label: 'Preferred Time',
        type: BookingFieldType.time,
        isRequired: true,
      ),
      BookingField(
        id: 'notes',
        label: 'Additional Notes',
        type: BookingFieldType.textarea,
        isRequired: false,
        placeholder: 'Any special requirements...',
      ),
    ];
  }

  /// Submit a booking
  Future<bool> submitBooking({
    required String serviceType,
    required List<BookingField> fields,
    required Map<String, dynamic> formData,
  }) async {
    _isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    final booking = BookingModel(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user', // Would come from auth state
      userName: 'Current User',
      serviceType: serviceType,
      status: BookingStatus.pending,
      fields: fields,
      formData: formData,
      createdAt: DateTime.now(),
    );

    _bookings.add(booking);
    _isLoading.value = false;
    update();
    return true;
  }

  /// Select a booking
  void selectBooking(String bookingId) {
    _selectedBooking.value = _bookings.firstWhereOrNull(
      (b) => b.id == bookingId,
    );
  }

  /// Approve booking (admin)
  Future<void> approveBooking(String bookingId) async {
    _isLoading.value = true;
    update();

    try {
      final adminService = AdminService();
      await adminService.approveBooking(bookingId);

      // Update local state
      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          status: BookingStatus.approved,
        );
      }
      print('BookingState: Booking $bookingId approved successfully via API');
    } on api.ApiException catch (e) {
      print('BookingState: API error approving booking - ${e.message}');
      rethrow;
    } catch (e) {
      print('BookingState: Unexpected error approving booking - $e');
      rethrow;
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  /// Reject booking (admin)
  Future<void> rejectBooking(String bookingId, {String? adminNotes}) async {
    _isLoading.value = true;
    update();

    try {
      final adminService = AdminService();
      await adminService.rejectBooking(
        bookingId,
        reason: adminNotes ?? 'Your booking was rejected.',
        notes: adminNotes,
      );

      // Update local state
      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          status: BookingStatus.rejected,
          adminNotes: adminNotes,
        );
      }
      print('BookingState: Booking $bookingId rejected successfully via API');
    } on api.ApiException catch (e) {
      print('BookingState: API error rejecting booking - ${e.message}');
      rethrow;
    } catch (e) {
      print('BookingState: Unexpected error rejecting booking - $e');
      rethrow;
    } finally {
      _isLoading.value = false;
      update();
    }
  }
}
