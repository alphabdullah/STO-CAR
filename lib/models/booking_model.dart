/// Booking status enumeration
enum BookingStatus {
  pending,
  approved,
  rejected,
  completed,
  cancelled,
}

/// Booking field type enumeration
enum BookingFieldType {
  text,
  number,
  date,
  time,
  dropdown,
  checkbox,
  textarea,
}

/// Booking field model for dynamic forms
class BookingField {
  final String id;
  final String label;
  final BookingFieldType type;
  final bool isRequired;
  final String? placeholder;
  final List<String>? options; // For dropdown
  final dynamic value;

  const BookingField({
    required this.id,
    required this.label,
    required this.type,
    this.isRequired = false,
    this.placeholder,
    this.options,
    this.value,
  });

  BookingField copyWith({
    String? id,
    String? label,
    BookingFieldType? type,
    bool? isRequired,
    String? placeholder,
    List<String>? options,
    dynamic value,
  }) {
    return BookingField(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      isRequired: isRequired ?? this.isRequired,
      placeholder: placeholder ?? this.placeholder,
      options: options ?? this.options,
      value: value ?? this.value,
    );
  }
}

/// Booking model representing service booking
class BookingModel {
  final String id;
  final String userId;
  final String userName;
  final String serviceType;
  final BookingStatus status;
  final List<BookingField> fields;
  final Map<String, dynamic> formData;
  final DateTime createdAt;
  final DateTime? scheduledDate;
  final String? notes;
  final String? adminNotes;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.serviceType,
    required this.status,
    required this.fields,
    this.formData = const {},
    required this.createdAt,
    this.scheduledDate,
    this.notes,
    this.adminNotes,
  });

  bool get isPending => status == BookingStatus.pending;
  bool get isApproved => status == BookingStatus.approved;
  bool get isRejected => status == BookingStatus.rejected;
  bool get isCompleted => status == BookingStatus.completed;

  /// Parse BookingStatus from string
  static BookingStatus _parseStatus(dynamic statusValue) {
    if (statusValue == null) return BookingStatus.pending;
    final statusStr = statusValue.toString().toLowerCase();
    switch (statusStr) {
      case 'pending':
        return BookingStatus.pending;
      case 'approved':
        return BookingStatus.approved;
      case 'rejected':
        return BookingStatus.rejected;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
      case 'canceled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }

  /// Parse DateTime from string
  static DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return null;
    try {
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      }
    } catch (e) {
      print('BookingModel: Error parsing date: $dateValue - $e');
    }
    return null;
  }

  /// Create BookingModel from JSON
  /// Supports API schema: id, booking_number, full_name, phone_number, car_name,
  /// car_model, description, prefered_time, prefered_date, status, created_at
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    try {
      final formData = <String, dynamic>{};

      // Handle nested user object
      final userObj = json['user'];
      String? userNameFromObj;
      String? userIdFromObj;
      
      if (userObj is Map<String, dynamic>) {
        userNameFromObj = userObj['name']?.toString();
        userIdFromObj = userObj['id']?.toString();
      }

      // Primary schema: full_name, phone_number, car_name, car_model, description, prefered_time, prefered_date
      final fullName = json['full_name']?.toString() ?? userNameFromObj;
      final phoneNumber = json['phone_number']?.toString();
      final carName = json['car_name']?.toString();
      final carModel = json['car_model']?.toString();
      final description = json['description']?.toString();
      final preferedTime = json['prefered_time']?.toString();
      final preferedDate = json['prefered_date']?.toString();

      if (fullName != null) formData['name'] = fullName;
      if (phoneNumber != null) formData['phoneNumber'] = phoneNumber;
      if (carName != null) formData['carName'] = carName;
      if (carModel != null) formData['carModel'] = carModel;
      if (description != null) formData['description'] = description;
      if (preferedTime != null) formData['time'] = preferedTime;
      if (preferedDate != null) formData['date'] = preferedDate;

      // Booking number for display
      final bookingNumber = json['booking_number']?.toString();
      if (bookingNumber != null) formData['bookingNumber'] = bookingNumber;

      // Legacy/alternate schema fallbacks
      if (formData['carName'] == null && json['vehicle_make'] != null) {
        formData['carName'] = json['vehicle_make'].toString();
      }
      if (formData['carModel'] == null && json['vehicle_model'] != null) {
        formData['carModel'] = json['vehicle_model'].toString();
      }
      if (json['vehicle_year'] != null) formData['carYear'] = json['vehicle_year'].toString();
      if (json['vehicle_plate'] != null) formData['vehiclePlate'] = json['vehicle_plate'].toString();
      if (formData['time'] == null && json['booking_time'] != null) {
        formData['time'] = json['booking_time'].toString();
      }
      if (formData['date'] == null && json['booking_date'] != null) {
        formData['date'] = json['booking_date'].toString();
      }
      if (json['service_type'] != null) {
        if (json['service_type'] is Map<String, dynamic>) {
          final st = json['service_type'] as Map<String, dynamic>;
          formData['serviceType'] = st['name']?.toString() ?? 'Service Booking';
        } else {
          formData['serviceType'] = json['service_type'].toString();
        }
      }

      final createdAt = _parseDateTime(json['created_at'] ?? json['createdAt']);
      final scheduledDate = _parseDateTime(
        preferedDate ?? json['booking_date'] ?? json['scheduled_date'] ?? json['prefered_date'],
      );

      final id = json['id']?.toString() ?? json['booking_number']?.toString() ?? '';
      final userName = fullName ?? json['user_name']?.toString() ?? userNameFromObj ?? '';
      final userId = json['user_id']?.toString() ?? json['userId']?.toString() ?? userIdFromObj ?? '';
      String serviceTypeName = 'Service Booking';
      if (formData['serviceType'] != null) {
        serviceTypeName = formData['serviceType'] as String;
      }

      return BookingModel(
        id: id,
        userId: userId,
        userName: userName,
        serviceType: serviceTypeName,
        status: _parseStatus(json['status']),
        fields: const [],
        formData: formData,
        createdAt: createdAt ?? DateTime.now(),
        scheduledDate: scheduledDate,
        notes: description ?? json['notes']?.toString() ?? json['description']?.toString(),
        adminNotes: json['admin_notes']?.toString() ?? json['adminNotes']?.toString(),
      );
    } catch (e) {
      print('BookingModel.fromJson: Error parsing booking: $e');
      print('BookingModel.fromJson: JSON: $json');
      rethrow;
    }
  }

  BookingModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? serviceType,
    BookingStatus? status,
    List<BookingField>? fields,
    Map<String, dynamic>? formData,
    DateTime? createdAt,
    DateTime? scheduledDate,
    String? notes,
    String? adminNotes,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      fields: fields ?? this.fields,
      formData: formData ?? this.formData,
      createdAt: createdAt ?? this.createdAt,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      notes: notes ?? this.notes,
      adminNotes: adminNotes ?? this.adminNotes,
    );
  }
}

