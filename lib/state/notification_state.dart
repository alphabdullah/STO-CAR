import 'package:get/get.dart';
import '../models/notification_model.dart';

/// Notification state controller
/// Manages user notifications
class NotificationState extends GetxController {
  static final NotificationState _instance = NotificationState._internal();
  factory NotificationState() => _instance;
  NotificationState._internal();

  // Observable state
  final _notifications = <NotificationModel>[].obs;
  final _isLoading = false.obs;

  // Getters
  RxList<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading.value;

  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  int get unreadCount => unreadNotifications.length;

  @override
  void onInit() {
    super.onInit();
    // No mock data - only load from API in child classes or when requested
  }

  /// Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    _notifications.value = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
  }

  /// Delete notification
  void deleteNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  /// Clear all notifications
  void clearAll() {
    _notifications.clear();
  }

  /// Add notification (for testing or future use)
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
  }
}
