import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import 'auth_state.dart';

/// Notification state controller
/// Manages user notifications (loads from API)
class NotificationState extends GetxController {
  static final NotificationState _instance = NotificationState._internal();
  factory NotificationState() => _instance;
  NotificationState._internal();

  final NotificationService _notificationService = NotificationService();

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
    // Fetch notifications automatically if user is authenticated
    final authState = Get.isRegistered<AuthState>()
        ? Get.find<AuthState>()
        : null;
    if (authState != null && authState.isAuthenticated) {
      fetchNotifications();
    }
  }

  /// Fetch notifications from API (call when user is authenticated)
  Future<void> fetchNotifications() async {
    _isLoading.value = true;
    try {
      final list = await _notificationService.getNotifications();
      _notifications.value = list;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Refresh unread count from API
  Future<int> refreshUnreadCount() async {
    final count = await _notificationService.getUnreadCount();
    // Sync local unread state if needed - we don't have count-only, so fetch triggers update
    return count;
  }

  /// Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _notificationService.markAsRead(notificationId);
    }
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    _notifications.value = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    _notificationService.markAllAsRead();
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
