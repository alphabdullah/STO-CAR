import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_design_system.dart';
import '../../../core/theme/app_theme.dart';
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
      // No context in loadBookings; keep Get.snackbar for error
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> approveBooking(BuildContext context, String bookingId) async {
    try {
      await _adminService.approveBooking(bookingId);
      
      // Update local state
      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(status: BookingStatus.approved);
         _bookings.refresh();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.bookingApprovedSuccessfully)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.error}: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> rejectBooking(BuildContext context, String bookingId) async {
    _rejectNotesController.clear();
    final reasonController = TextEditingController();

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppDesign.getBgSecondary(ctx),
        title: Text(l10n.rejectBookingTitle, style: TextStyle(color: AppDesign.getTextPrimary(ctx))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.rejectBookingMessage, style: TextStyle(color: AppDesign.getTextSecondary(ctx))),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: l10n.rejectionReason,
                hintText: l10n.rejectionReasonHint,
                labelStyle: TextStyle(color: AppDesign.getTextSecondary(ctx)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rejectNotesController,
              decoration: InputDecoration(
                labelText: l10n.additionalNotes,
                hintText: l10n.additionalNotesHint,
                labelStyle: TextStyle(color: AppDesign.getTextSecondary(ctx)),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel, style: TextStyle(color: AppDesign.getTextSecondary(ctx))),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(l10n.rejectionReasonRequired)),
                );
                return;
              }
              Navigator.pop(ctx, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.reject),
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

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.bookingRejectedSuccessfully)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppLocalizations.of(context)!.error}: ${e.toString()}')),
          );
        }
      }
    }
  }

  void showBookingDetails(BuildContext context, String bookingId) {
    final booking = _bookings.firstWhereOrNull((b) => b.id == bookingId);

    if (booking == null) return;

    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppDesign.getBgSecondary(ctx),
        title: Text('${booking.serviceType} Details', style: TextStyle(color: AppDesign.getTextPrimary(ctx))),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _DetailRow(label: l10n.bookingId, value: booking.formData['bookingNumber'] ?? booking.id),
              _DetailRow(label: l10n.user, value: booking.userName),
              _DetailRow(label: l10n.status, value: _getStatusText(ctx, booking.status)),
              _DetailRow(label: l10n.date, value: booking.scheduledDate?.toString().split(' ')[0] ?? 'N/A'),
              _DetailRow(label: l10n.time, value: booking.formData['time']?.toString() ?? 'N/A'),
              const Divider(height: 24),
              Text(l10n.vehicleDetails, style: TextStyle(fontWeight: FontWeight.bold, color: AppDesign.getTextPrimary(ctx))),
              const SizedBox(height: 8),
              _DetailRow(label: l10n.car, value: booking.formData['carName']?.toString() ?? 'N/A'),
              _DetailRow(label: l10n.model, value: booking.formData['carModel']?.toString() ?? 'N/A'),
              const Divider(height: 24),
              Text(l10n.contactInfo, style: TextStyle(fontWeight: FontWeight.bold, color: AppDesign.getTextPrimary(ctx))),
              const SizedBox(height: 8),
              _DetailRow(label: l10n.phone, value: booking.formData['phoneNumber']?.toString() ?? 'N/A'),
              if (booking.notes != null) ...[
                const Divider(height: 24),
                Text(l10n.descriptionNotes, style: TextStyle(fontWeight: FontWeight.bold, color: AppDesign.getTextPrimary(ctx))),
                const SizedBox(height: 4),
                Text(booking.notes!, style: TextStyle(color: AppDesign.getTextSecondary(ctx))),
              ],
              if (booking.adminNotes != null) ...[
                const Divider(height: 24),
                Text(l10n.adminNotes, style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.info)),
                const SizedBox(height: 4),
                Text(booking.adminNotes!, style: TextStyle(color: AppDesign.getTextSecondary(ctx))),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.close, style: TextStyle(color: AppDesign.getTextSecondary(ctx))),
          ),
        ],
      ),
    );
  }

  String _getStatusText(BuildContext context, BookingStatus status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case BookingStatus.pending:
        return l10n.pending;
      case BookingStatus.approved:
        return l10n.approved;
      case BookingStatus.rejected:
        return l10n.rejected;
      case BookingStatus.completed:
        return l10n.completed;
      case BookingStatus.cancelled:
        return l10n.cancelled;
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
              style: TextStyle(fontWeight: FontWeight.bold, color: AppDesign.getTextTertiary(context)),
            ),
          ),
          Expanded(child: Text(value, style: TextStyle(color: AppDesign.getTextPrimary(context)))),
        ],
      ),
    );
  }
}

