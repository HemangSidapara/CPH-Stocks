import 'dart:developer';
import 'dart:io';

import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:cph_stocks/Constants/get_storage.dart';
import 'package:cph_stocks/Network/services/utils_services/awesome_notification_service.dart';
import 'package:cph_stocks/Routes/app_pages.dart';
import 'package:cph_stocks/Screens/home_screen/cash_flow_scren/cash_flow_controller.dart';
import 'package:cph_stocks/Screens/home_screen/home_controller.dart';
import 'package:cph_stocks/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FirebaseService {
  static late FirebaseApp fbApp;
  static late FirebaseMessaging fbmInstance;
  static bool _isForegroundListenerAdded = false;

  /// Init Firebase Plugin and Related Libs [ex. FirebaseMessaging]
  static Future<void> init({bool isBackground = false}) async {
    fbApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    fbmInstance = FirebaseMessaging.instance;

    if (!isBackground) {
      await setupFlutterNotifications();
    }
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

    await setupBackgroundInteractedMessage();
  }

  /// Show notification
  static void showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    log("\x1B[32m✅ Message Received:\x1B[0m 📩 ${message.toMap()}");
    log("\x1B[34m🔔 Notification Object:\x1B[0m 📢 ${notification?.toMap()}");

    _handleMethodWhenNotificationReceived();
    if (notification != null && android != null) {
      await AwesomeNotificationService.createNotification(notification: notification);
    }
  }

  /// Interacted Message from Foreground -> Open App
  static Future<void> firebaseMessagingForegroundHandler() async {
    if (_isForegroundListenerAdded) return; // Prevent duplicate registration
    _isForegroundListenerAdded = true;
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  /// Interacted Message from Background -> Open App
  static Future<void> setupBackgroundInteractedMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// Interacted Message from Terminated -> Open App
  static Future<void> setupTerminatedInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      log('Firebase Terminated Interacted Message: ${initialMessage.toMap()}');
      setData(AppConstance.gotoCashFlowFromTerminated, true);
    }
  }

  /// Message/Notification Handle Method
  static void _handleMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('Firebase Notification action received: ${message.toMap()}');
    }
    if (message.notification == null) return;

    while (Get.currentRoute.isNotEmpty && Get.currentRoute != Routes.homeScreen) {
      log("🚫 Removed Route: ${Get.currentRoute}");
      Get.back(closeOverlays: true);
    }
    HomeController? homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    if (homeController != null) {
      homeController.onDrawerItemChange(index: homeController.listOfImages.indexOf(AppAssets.cashFlowIcon));
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FirebaseService.init(isBackground: true);
  await AwesomeNotificationService.init();

  log("Handling a background message: ${message.messageId}");
  log("\x1B[32m✅ Message Received:\x1B[0m 📩 ${message.toMap()}");
  log("\x1B[34m🔔 Notification Object:\x1B[0m 📢 ${message.notification?.toMap()}");

  if (defaultTargetPlatform != TargetPlatform.android) {
    FirebaseService.showFlutterNotification(message);
  }
}

Future<void> _handleMethodWhenNotificationReceived() async {
  CashFlowController? cashFlowController = Get.isRegistered<CashFlowController>() ? Get.find<CashFlowController>() : null;

  if (cashFlowController != null) {
    cashFlowController.filterCashType.value = 0;
    cashFlowController.getCashFlowApiCall(isRefresh: true);
  }
}
