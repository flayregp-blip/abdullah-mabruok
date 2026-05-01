import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart' show SessionManager;
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/service/navigation/navigate_with_controller.dart';
import 'package:shortzz/model/chat/chat_thread.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/screen/chat_screen/chat_screen.dart';
import 'package:shortzz/screen/chat_screen/chat_screen_controller.dart';
import 'package:shortzz/screen/dashboard_screen/dashboard_screen_controller.dart';
import 'package:shortzz/screen/reels_screen/reels_screen.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/screen/post_screen/single_post_screen.dart';
import 'package:shortzz/utilities/const_res.dart';
import 'package:shortzz/utilities/firebase_const.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  Loggers.info('NOTIFICATION TAP ON BACKGROUND');
  if (notificationResponse.payload != null) {
    NotificationManager.instance.handleNotification(notificationResponse.payload!);
  }
}

class NotificationManager {
  NotificationManager._() {
    init();
  }

  static final instance = NotificationManager._();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  RxString notificationPayload = ''.obs;
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'shortzz', // id
      'Shortzz', // title
      playSound: true,
      enableLights: true,
      enableVibration: true,
      showBadge: false,
      importance: Importance.max);

  String? notificationId;

  void init() async {
    // --- Firebase Setup ---
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<DarwinFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, sound: true);
      await firebaseMessaging.requestPermission(alert: true, badge: false, sound: true);
    }

    subscribeToTopic();

    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings(
        defaultPresentAlert: true, defaultPresentSound: true, defaultPresentBadge: false);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      Loggers.info('onDidReceiveNotificationResponse ${response.payload}');
      String? payload = response.payload;
      if (payload != null) {
        notificationPayload.value = payload;
        handleNotification(payload);
      }
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (notificationId == message.messageId) return;
      notificationId = message.messageId;

      String data = message.data['notification_data'] ?? '';

      if (message.data['type'] == NotificationType.chat.type) {
        ChatThread conversationUser = ChatThread.fromJson(jsonDecode(data));
        if (conversationUser.conversationId == ChatScreenController.chatId) {
          return;
        }
      } else {
        SessionManager.instance.setNotifyCount(1);
      }
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Loggers.info('User tapped the notification: ${message.data}');
      if (message.data.isNotEmpty) {
        handleNotification(jsonEncode(message.toMap()));
      }
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // --- OneSignal Setup ---
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("3acddfc-e7c6-4504-b8a4-d73280111ef4");
    OneSignal.Notifications.requestPermission(true);

    // OneSignal Click Listener
    OneSignal.Notifications.addClickListener((event) {
      Loggers.info('OneSignal Notification Clicked: ${event.notification.jsonRepresentation()}');
      // Map OneSignal data to our handleNotification format if possible
      // Or handle it directly
      final data = event.notification.additionalData;
      if (data != null && data.isNotEmpty) {
        handleNotification(jsonEncode({'data': data}));
      }
    });

    // OneSignal Foreground Listener
    OneSignal.Notifications.addForegroundLifecycleListener((event) {
      Loggers.info('OneSignal Foreground Notification: ${event.notification.jsonRepresentation()}');
      // You can call event.preventDefault() to not show the notification
    });
  }

  void unsubscribeToTopic({String? topic}) async {
    Loggers.success(
        '🔔 Topic UnSubscribe : ${topic ?? notificationTopic}_${Platform.isAndroid ? 'android' : 'ios'}');
    await firebaseMessaging.unsubscribeFromTopic(
        '${topic ?? notificationTopic}_${Platform.isAndroid ? 'android' : 'ios'}');
    if (kDebugMode) {
      await firebaseMessaging.unsubscribeFromTopic(
          'test_${topic ?? notificationTopic}_${Platform.isAndroid ? 'android' : 'ios'}');
    }
  }

  Future<void> subscribeToTopic({String? topic}) async {
    Loggers.success(
        '🔔 Topic Subscribe : ${topic ?? notificationTopic}_${Platform.isAndroid ? 'android' : 'ios'}');
    await firebaseMessaging.subscribeToTopic(
        '${topic ?? notificationTopic}_${Platform.isAndroid ? 'android' : 'ios'}');

    if (kDebugMode) {
      await firebaseMessaging.subscribeToTopic(
          'test_${topic ?? notificationTopic}_${Platform.isAndroid ? 'android' : 'ios'}');
    }
  }

  void showNotification(RemoteMessage message) {
    Loggers.info('SHOW MESSAGE : ${message.toMap()}');
    int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    flutterLocalNotificationsPlugin.show(
        notificationId,
        (message.data['title']) ?? message.notification?.title,
        (message.data['body'] as String?) ?? message.notification?.body,
        NotificationDetails(
            iOS: const DarwinNotificationDetails(
                presentSound: true, presentAlert: true, presentBadge: false),
            android: AndroidNotificationDetails(channel.id, channel.name)),
        payload: jsonEncode(message.toMap()));
  }

  Future<void> handleNotification(String payload) async {
    try {
      final Map<String, dynamic> decoded = jsonDecode(payload);
      final Map<String, dynamic> data = decoded.containsKey('data') ? decoded['data'] : decoded;
      
      final dataType = data['type'];
      final dataString = data['notification_data'];
      
      Loggers.info('DATA TYPE : $dataType');
      Loggers.info('DATA STRING : $dataString');
      
      if (dataType == null || dataString == null || dataString.isEmpty) return;
      
      final controller = Get.put(DashboardScreenController());
      
      switch (dataType) {
        case 'chat':
          Future.delayed(const Duration(milliseconds: 500), () async {
            controller.selectedPageIndex.value = 4;
            await _handleChatNotification(dataString);
          });
          break;
        case 'post':
          await _handlePostNotification(dataString, controller);
          break;
        case 'user':
          controller.selectedPageIndex.value = 5;
          await _handleUserNotification(dataString);
          break;
        case 'live_stream':
          controller.selectedPageIndex.value = 2;
          await _handleLivestreamNotification(dataString);
          break;
        default:
          Loggers.warning('Unknown notification type: $dataType');
      }
    } catch (e) {
      Loggers.error('Error handling notification: $e');
    }
  }

  Future<void> _handleChatNotification(String data) async {
    try {
      final conversationUser = ChatThread.fromJson(jsonDecode(data));
      Loggers.info('Navigating to chat: ${conversationUser.toJson()}');
      await Get.to(() => ChatScreen(conversationUser: conversationUser));
    } catch (e) {
      Loggers.error('Failed to handle chat notification: $e');
    }
  }

  Future<void> _handlePostNotification(String data, DashboardScreenController controller) async {
    try {
      NotificationInfo notificationInfo = NotificationInfo.fromJson(jsonDecode(data));
      final int postId = notificationInfo.id ?? -1;
      final int? commentId = notificationInfo.commentId;
      final int? replyId = notificationInfo.replyCommentId;
      final result = await PostService.instance
          .fetchPostById(postId: postId, commentId: commentId, replyId: replyId);

      if (result.status == true && result.data != null) {
        final Post? post = result.data?.post;
        if (post == null) return;

        if (post.postType == PostType.reel) {
          controller.selectedPageIndex.value = 5;
          Get.to(() => ReelsScreen(
                reels: [post].obs,
                position: 0,
                postByIdData: result.data,
                pageType: ReelPageType.notification,
              ));
        } else if ([PostType.text, PostType.image, PostType.video].contains(post.postType)) {
          controller.selectedPageIndex.value = 1;
          await Get.to(() =>
              SinglePostScreen(post: post, postByIdData: result.data, isFromNotification: true));
        }
      }
    } catch (e) {
      Loggers.error('Failed to handle post notification: $e');
    }
  }

  Future<void> _handleUserNotification(String data) async {
    try {
      final map = jsonDecode(data);
      final int id = map['id'];
      final user = await UserService.instance.fetchUserDetails(userId: id);

      if (user != null) {
        Loggers.success('Navigating to user: ${user.id}');
        NavigationService.shared.openProfileScreen(user);
      }
    } catch (e) {
      Loggers.error('Failed to handle user notification: $e');
    }
  }

  Future<void> _handleLivestreamNotification(String data) async {
    // Implementation for livestream notification
  }

  Future<String?> getNotificationToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      Loggers.info('DeviceToken $token');
      return token;
    } catch (e) {
      Loggers.error('DeviceToken Exception $e');
      return null;
    }
  }

  void loginOneSignal(String userId) {
    Loggers.info('OneSignal Login: $userId');
    OneSignal.login(userId);
  }

  void logoutOneSignal() {
    Loggers.info('OneSignal Logout');
    OneSignal.logout();
  }
}
