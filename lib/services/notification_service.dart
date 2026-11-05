
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase_options.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance =
      NotificationService._();

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'wowyou_notifications',
    'WowYou Notifications',
    description:
        'Event updates, announcements and ticket alerts.',
    importance: Importance.max,
  );

  Future<void> initialize() async {
    // Initialize local notifications.
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create Android notification channel.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Request notification permissions.
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Android 13+ notification permission.
    await requestAndroidPermission();

    // Foreground notifications.
    FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );

    // Notification tapped while app is backgrounded.
    FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotificationOpened,
    );
  }

  // Register this device with the backend using this token.
 Future<void> registerDevice() async {
  await _messaging.register();
}

Stream<String> get onRegistered {
  return _messaging.onRegistered.map(
    (event) => event.toString(),
  );
}

  // Display notification while app is foregrounded.
  Future<void> _handleForegroundMessage(
    RemoteMessage message,
  ) async {
    final notification = message.notification;

    if (notification == null) return;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title ?? 'WowYou',
      body: notification.body ?? '',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  // Handle notification opened from background.
  void _handleNotificationOpened(
    RemoteMessage message,
  ) {
    _handleNotificationPayload(message.data);
  }

  // Handle notification opened from foreground local notification.
  void _onNotificationTap(
    NotificationResponse response,
  ) {
    final payload = response.payload;

    if (payload == null || payload.isEmpty) return;

    try {
      final data = jsonDecode(payload);

      if (data is Map<String, dynamic>) {
        _handleNotificationPayload(data);
      }
    } catch (_) {
      // Invalid notification payload.
    }
  }

  // Notification navigation can be connected here.
  void _handleNotificationPayload(
    Map<String, dynamic> data,
  ) {
    // Example payload:
    // {
    //   "type": "event",
    //   "eventId": "123"
    // }
    //
    // Connect this to the app router.
  }

  // Notification that launched the app from terminated state.
  Future<RemoteMessage?> getInitialMessage() {
    return _messaging.getInitialMessage();
  }

  // Android 13+ notification permission.
  Future<bool?> requestAndroidPermission() async {
    return _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }
}

// Firebase background message handler.
// Must remain a top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
