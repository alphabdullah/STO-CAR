import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../models/notification_model.dart';
import '../state/notification_state.dart';
import '../state/auction_state.dart';

/// Notification Service
/// Handles both API-based notifications and FCM Push Notifications
class NotificationService extends GetxService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  final ApiClient _apiClient = ApiClient();
  FirebaseMessaging get _fcm => FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Audio player for notification sounds
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Initialize Firebase Messaging & Local Notifications
  Future<void> initialize() async {
    // Skip if Firebase is not initialized correctly (e.g. on web without config)
    if (Firebase.apps.isEmpty) {
      debugPrint(
        'NotificationService: Firebase not initialized, skipping setup.',
      );
      return;
    }

    // 1. Request Permission (iOS/Android 13+)
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // 2. Get Token
      String? token = await _fcm.getToken();
      if (token != null) {
        await updateFcmToken(token);
      }

      // 3. Listen for Token Refresh
      _fcm.onTokenRefresh.listen(updateFcmToken);

      // 4. Setup Local Notifications for Foreground
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await _localNotifications.initialize(initializationSettings);

      // 5. Handle FG Messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 6. Handle Interaction (App opened from notification)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);
    }
  }

  /// Update FCM token on backend
  Future<void> updateFcmToken(String token) async {
    try {
      await _apiClient.post(
        ApiEndpoints.updateFcmToken,
        body: {'fcm_token': token},
        requiresAuth: true,
      );
    } catch (e) {
      // Slient fail if not logged in
    }
  }

  /// Foreground message handler
  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true, // Default system sound for the channel
          ),
        ),
        payload: message.data['auction_id'],
      );

      // 🔥 Play custom pop sound for foreground notifications
      _playCustomSound();

      // Update UI Notification State
      if (Get.isRegistered<NotificationState>()) {
        Get.find<NotificationState>().fetchNotifications();
      }
      if (Get.isRegistered<AuctionState>()) {
        Get.find<AuctionState>().loadAuctions(forceRefresh: true);
      }
    }
  }

  /// Play custom pop sound
  Future<void> _playCustomSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/notification_pop.mp3'));
    } catch (e) {
      debugPrint('Error playing notification sound: $e');
    }
  }

  /// Handle click when app launches from notification
  void _handleNotificationClick(RemoteMessage message) {
    final auctionId = message.data['auction_id'];
    if (auctionId != null) {
      Get.toNamed('/auctions/$auctionId');
    }
  }

  /// Get notifications from API
  Future<List<NotificationModel>> getNotifications({
    bool unreadOnly = false,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getNotifications,
        queryParameters: unreadOnly ? {'unread': 'true'} : null,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        final items = response['data'] as List<dynamic>? ?? [];
        return items
            .map((e) => _parseNotification(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getUnreadCount,
        requiresAuth: true,
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'] as Map<String, dynamic>;
        return (data['count'] as num?)?.toInt() ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String id) async {
    await _apiClient.post(
      ApiEndpoints.markNotificationAsRead(id),
      requiresAuth: true,
    );
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    await _apiClient.post(
      ApiEndpoints.markAllNotificationsAsRead,
      requiresAuth: true,
    );
  }

  NotificationModel _parseNotification(Map<String, dynamic> json) {
    final typeStr = (json['type'] ?? 'system').toString().toLowerCase();
    NotificationType type = NotificationType.system;
    if (typeStr.contains('auction') || typeStr == 'bid')
      type = NotificationType.auction;
    else if (typeStr.contains('booking'))
      type = NotificationType.booking;
    else if (typeStr.contains('wallet'))
      type = NotificationType.wallet;
    else if (typeStr.contains('verif'))
      type = NotificationType.verification;
    else if (typeStr.contains('part'))
      type = NotificationType.parts;

    final data = json['data'] as Map<String, dynamic>?;
    final auctionId = data?['auction_id'];
    final actionUrl = auctionId != null ? '/auctions/$auctionId' : null;

    return NotificationModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      type: type,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isRead: json['is_read'] == true,
      actionUrl: actionUrl,
      metadata: data,
    );
  }
}
