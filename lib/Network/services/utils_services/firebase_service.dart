import 'dart:developer';
import 'dart:io';

import 'package:cph_stocks/Network/services/utils_services/awesome_notification_service.dart';
import 'package:cph_stocks/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static late FirebaseApp fbApp;
  static late FirebaseMessaging fbmInstance;

  /// Init Firebase Plugin and Related Libs [ex. FirebaseMessaging]
  static Future<void> init({bool isBackground = false}) async {
    fbApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    fbmInstance = FirebaseMessaging.instance;

    if (!isBackground) {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }

    await setupFlutterNotifications();
  }

  /// Request Permission
  static Future<NotificationSettings> requestPermission() async {
    return await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      alert: true,
      badge: false,
      sound: true,
    );
  }

  /// Get FCM token
  static Future<String?> getFcmToken() async {
    final settings = await requestPermission();
    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }
    if (settings.authorizationStatus == AuthorizationStatus.authorized || settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (Platform.isIOS) {
        final apnsToken = await fbmInstance.getAPNSToken();
        if (kDebugMode) {
          print("APNS Token: $apnsToken");
        }
        if (apnsToken != null) {
          final token = await fbmInstance.getToken();
          if (kDebugMode) {
            print("FCM Token: $token");
          }
          return token;
        }
      } else {
        final token = await fbmInstance.getToken();
        if (kDebugMode) {
          print("FCM Token: $token");
        }
        return token;
      }
      return null;
    }
    return null;
  }

  /// Setup Flutter Notification
  static Future<void> setupFlutterNotifications() async {
    await fbmInstance.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
    );

    await firebaseMessagingForegroundHandler();

    await setupInteractedMessage();
  }

  /// Show notification
  static void showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    log("\x1B[32m✅ Message Received:\x1B[0m 📩 ${message.toMap()}");
    log("\x1B[34m🔔 Notification Object:\x1B[0m 📢 ${notification?.toMap()}");

    _handleMethodWhenNotificationReceived();
    if (notification != null && android != null && !kIsWeb) {
      await AwesomeNotificationService.createNotification(notification: notification);
    }
  }

  /// Interacted Message from Terminal -> Open App
  static Future<void> firebaseMessagingForegroundHandler() async {
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  /// Interacted Message from Terminal -> Open App
  static Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// Message/Notification Handle Method
  static void _handleMessage(RemoteMessage message) {}
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseService.init(isBackground: true);
  await AwesomeNotificationService.init();

  log("Handling a background message: ${message.messageId}");
  log("\x1B[32m✅ Message Received:\x1B[0m 📩 ${message.toMap()}");
  log("\x1B[34m🔔 Notification Object:\x1B[0m 📢 ${message.notification?.toMap()}");

  _handleMethodWhenNotificationReceived();
  if (defaultTargetPlatform != TargetPlatform.android) {
    FirebaseService.showFlutterNotification(message);
  }
}

Future<void> _handleMethodWhenNotificationReceived() async {}
