import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
// import '../../../state/booking_state.dart';
import '../../../models/booking_model.dart';
import '../../../services/admin_service.dart';

/// Admin booking controller (MVC pattern - Controller layer)
class AdminBookingController extends GetxController {
  // final BookingState _bookingState = BookingState(); // Removed dependency on BookingState
  final AdminService _adminService = AdminService();
  final _rejectNotesController = TextEditingController();
  final _bookings = <BookingModel>[].obs;
  final _isLoading = false.obs;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading.value;
  List<BookingModel> get pendingBookings => _bookings.where((b) => b.isPending).toList();

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  @override
  void onClose() {
    _rejectNotesController.dispose();
    super.onClose();
  }

  /// Load bookings from Admin API
  Future<void> loadBookings() async {
    _isLoading.value = true;
    try {
      final data = await _adminService.getServiceBookings();
      _bookings.value = data.map((json) => BookingModel.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar(
        AppStrings.error,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> approveBooking(String bookingId) async {
    try {
      await _adminService.approveBooking(bookingId);
      
      // Update local state
      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(status: BookingStatus.approved);
         _bookings.refresh();
      }

      Get.snackbar(
        AppStrings.success,
        'Booking approved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
       Get.snackbar(
        AppStrings.error,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> rejectBooking(BuildContext context, String bookingId) async {
    _rejectNotesController.clear();
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to reject this booking?'),
            const SizedBox(height: 16),
             TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Rejection Reason *',
                hintText: 'e.g., Service not available',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rejectNotesController,
              decoration: const InputDecoration(
                labelText: 'Additional Notes',
                hintText: 'Please choose another date',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isEmpty) {
                Get.snackbar('Error', 'Rejection reason is required');
                return;
              }
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(AppStrings.reject),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _adminService.rejectBooking(
          bookingId,
          reason: reasonController.text,
          notes: _rejectNotesController.text,
        );
        
        // Update local state
        final index = _bookings.indexWhere((b) => b.id == bookingId);
        if (index != -1) {
          _bookings[index] = _bookings[index].copyWith(
            status: BookingStatus.rejected,
            adminNotes: '${reasonController.text} - ${_rejectNotesController.text}',
          );
          _bookings.refresh();
        }

        Get.snackbar(
          AppStrings.success,
          'Booking rejected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          AppStrings.error,
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void showBookingDetails(BuildContext context, String bookingId) {
    final booking = _bookings.firstWhereOrNull((b) => b.id == bookingId);

    if (booking == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${booking.serviceType} Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(label: 'Booking ID', value: booking.formData['bookingNumber'] ?? booking.id),
              _DetailRow(label: 'User', value: booking.userName),
              _DetailRow(label: 'Status', value: _getStatusText(booking.status)),
              _DetailRow(label: 'Date', value: booking.scheduledDate?.toString().split(' ')[0] ?? 'N/A'),
              _DetailRow(label: 'Time', value: booking.formData['time']?.toString() ?? 'N/A'),
              const Divider(height: 24),
              const Text('Vehicle Details', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _DetailRow(label: 'Car', value: booking.formData['carName']?.toString() ?? 'N/A'),
              _DetailRow(label: 'Model', value: booking.formData['carModel']?.toString() ?? 'N/A'),
              const Divider(height: 24),
               const Text('Contact Info', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _DetailRow(label: 'Phone', value: booking.formData['phoneNumber']?.toString() ?? 'N/A'),
              
              if (booking.notes != null) ...[
                const Divider(height: 24),
                const Text('Description/Notes', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(booking.notes!),
              ],
              
              if (booking.adminNotes != null) ...[
                const Divider(height: 24),
                const Text('Admin Notes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 4),
                Text(booking.adminNotes!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppStrings.pending;
      case BookingStatus.approved:
        return AppStrings.approved;
      case BookingStatus.rejected:
        return AppStrings.rejected;
      case BookingStatus.completed:
        return AppStrings.completed;
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

