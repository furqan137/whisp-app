import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // ------------------------------------------------------------------
    // 1️⃣ REQUEST NOTIFICATION PERMISSION FIRST (Required for iOS)
    // ------------------------------------------------------------------
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("🔔 Permission status: ${settings.authorizationStatus}");

    // ------------------------------------------------------------------
    // 2️⃣ INITIALIZE LOCAL NOTIFICATIONS (Android + iOS)
    // ------------------------------------------------------------------
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // ------------------------------------------------------------------
    // 3️⃣ IOS → WAIT FOR APNS TOKEN BEFORE GETTING FCM TOKEN
    // ------------------------------------------------------------------
    if (Platform.isIOS) {
      String? apnsToken = await _messaging.getAPNSToken();
      print("📡 APNS Token: $apnsToken");

      if (apnsToken == null) {
        print("⏳ APNS not available yet. Skipping FCM token for now.");
        return; // Stop here; try again later
      }
    }

    // ------------------------------------------------------------------
    // 4️⃣ NOW SAFELY GET THE FCM TOKEN
    // ------------------------------------------------------------------
    String? fcmToken = await _messaging.getToken();
    print("📱 FCM Token: $fcmToken");

    // ------------------------------------------------------------------
    // 5️⃣ HANDLE FOREGROUND NOTIFICATIONS
    // ------------------------------------------------------------------
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',
              'Notifications',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
    });

    // ------------------------------------------------------------------
    // 6️⃣ HANDLE NOTIFICATION CLICKED (App in background)
    // ------------------------------------------------------------------
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("🚀 Notification clicked: ${message.data}");
    });
  }
}
