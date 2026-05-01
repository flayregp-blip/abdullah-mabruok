import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shortzz/common/manager/firebase_notification_manager.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/api_service.dart';
import 'package:shortzz/common/service/utils/params.dart';
import 'package:shortzz/common/service/utils/web_service.dart';
import 'package:shortzz/model/misc/activity_notification_model.dart';
import 'package:shortzz/model/misc/admin_notification_model.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/const_res.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  Future<List<AdminNotificationData>> fetchAdminNotifications(
      {int? lastItemId}) async {
    AdminNotificationModel response = await ApiService.instance.call(
        url: WebService.notification.fetchAdminNotifications,
        fromJson: AdminNotificationModel.fromJson,
        param: {
          Params.limit: AppRes.paginationLimit,
          Params.lastItemId: lastItemId
        });
    if (response.status == true) {
      return response.data ?? [];
    }
    return [];
  }

  Future<List<ActivityNotification>> fetchActivityNotifications(
      {int? lastItemId}) async {
    ActivityNotificationModel response = await ApiService.instance.call(
        url: WebService.notification.fetchActivityNotifications,
        fromJson: ActivityNotificationModel.fromJson,
        param: {
          Params.limit: AppRes.paginationLimit,
          Params.lastItemId: lastItemId,
        });
    if (response.status == true) {
      return response.data ?? [];
    } else {
      return [];
    }
  }

  Future pushNotification(
      {required NotificationType type,
      required String title,
      required String body,
      Map<String, dynamic>? data,
      String? token,
      String? topic,
      num? deviceType,
      String? authorizationToken}) async {
    bool isIOS = deviceType == 1;

    // FIX: Build proper FCM v1 payload
    Map<String, dynamic> messageData = {
      "apns": {
        "headers": {
          "apns-priority": "10",
          "apns-push-type": "alert",
        },
        "payload": {
          "aps": {
            "sound": "default",
            "content-available": 1,
            "alert": {
              "title": title,
              "body": body,
            },
            "badge": 1,
          }
        }
      },
      "android": {
        "priority": "high",
        "notification": {
          "sound": "default",
          "notification_priority": "PRIORITY_MAX",
          "visibility": "PUBLIC",
          "channel_id": "shortzz_high_importance",
        }
      },
      "data": {
        "title": title,
        "body": body,
        'type': type.type,
        if (data != null) "notification_data": jsonEncode(data)
      }
    };

    // FIX: Always include notification for Android (required for background delivery)
    if (!isIOS) {
      messageData["notification"] = {"body": body, "title": title};
    }

    if (token != null && token.isNotEmpty) {
      messageData["token"] = token;
    }
    if (topic != null && topic.isNotEmpty) {
      messageData["topic"] = topic;
    }

    Map<String, dynamic> inputData = {"message": messageData};

    var prettyString = const JsonEncoder.withIndent('  ').convert(inputData);
    Loggers.info('📤 Sending notification:\n$prettyString');

    try {
      http.Response response = await http
          .post(
            Uri.parse(WebService.notification.pushNotificationToSingleUser),
            headers: {
              Params.apikey: apiKey,
              Params.authToken:
                  authorizationToken ?? SessionManager.instance.getAuthToken(),
              'Content-Type': 'application/json',
            },
            body: json.encode(inputData),
          )
          .timeout(const Duration(seconds: 15)); // FIX: Add timeout

      Loggers.success('✅ Notification response [${response.statusCode}]: ${response.body}');

      // FIX: Log error details if notification failed
      if (response.statusCode != 200) {
        Loggers.error('❌ Notification failed with status ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      Loggers.error('❌ Notification send error: $e');
    }
  }
}
