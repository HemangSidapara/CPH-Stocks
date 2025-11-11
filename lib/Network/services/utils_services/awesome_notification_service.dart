import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cph_stocks/Constants/app_assets.dart';
import 'package:cph_stocks/Constants/app_colors.dart';
import 'package:cph_stocks/Constants/app_constance.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class AwesomeNotificationService {
  static ReceivedAction? initialAction;

  /// Init Awesome Notification Plugin
  static Future<void> init() async {
    final isInit = await AwesomeNotifications().initialize(
      AppAssets.notificationDrawableIcon,
      [
        NotificationChannel(
          channelGroupKey: AppConstance.notificationChannelGroupKey,
          channelKey: AppConstance.notificationChannelKey,
          channelName: 'Push Notifications',
          channelDescription: 'Notification channel for Push Notifications',
          defaultColor: AppColors.SECONDARY_COLOR,
          ledColor: AppColors.WHITE_COLOR,
          channelShowBadge: false,
          defaultPrivacy: NotificationPrivacy.Public,
          groupAlertBehavior: GroupAlertBehavior.All,
          importance: NotificationImportance.Max,
          playSound: true,
        ),
      ],
      debug: kDebugMode,
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: AppConstance.notificationChannelGroupKey,
          channelGroupName: "Push Notifications Channel Group",
        ),
      ],
    );

    if (kDebugMode) {
      print('Awesome Notification Service Initialized: $isInit');
    }

    await startListeningNotificationEvents();

    initialAction = await AwesomeNotifications().getInitialNotificationAction(removeFromActionEvents: false);
  }

  /// Request Permission for notification
  static Future<bool> requestPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    if (kDebugMode) {
      print("Awesome Notification Service Allowed: $isAllowed");
    }
    return isAllowed;
  }

  /// Listen Notification Events
  static Future<void> startListeningNotificationEvents() async {
    await requestPermission();
    final isSet = await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
    );
    if (kDebugMode) {
      print("🔔 AwesomeNotifications listener set: $isSet");
    }
  }

  /// Create Notification
  static Future<void> createNotification({required RemoteNotification notification}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notification.hashCode,
        channelKey: AppConstance.notificationChannelKey,
        title: notification.title,
        body: notification.body,
        category: NotificationCategory.Social,
        notificationLayout: NotificationLayout.BigPicture,
        wakeUpScreen: true,
        displayOnForeground: true,
        displayOnBackground: true,
        largeIcon: notification.android?.imageUrl,
      ),
    );
  }

  /// On Action Received - When Click on [Notification] or Click on [Notification Buttons]
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (kDebugMode) {
      print('Notification action received: ${receivedAction.buttonKeyPressed}');
    }
  }

  /// On Notification Displayed - When Display [Notification] in Device
  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    log('Notification displayed: "${receivedNotification.toMap()}"');
  }

  /// On Notification Created - When Created [Notification] in Device
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    if (kDebugMode) {
      print('Notification created: "${receivedNotification.toMap()}"');
    }
  }
}
