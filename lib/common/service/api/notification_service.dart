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

    Map<String, dynamic> messageData = {
      "apns": {
        "headers": {"apns-priority": "10"},
        "payload": {
          "aps": {
            "sound": "default",
            "content-available": 1,
          }
        }
      },
      "data": {
        "title": title,
        "body": body,
        'type': type.type,
        if (data != null) "notification_data": jsonEncode(data)
      }
    };
    if (!isIOS) {
      messageData["notification"] = {"body": body, "title": title};
    }
    if (token != null) {
      messageData["token"] = token;
    }
    if (topic != null) {
      messageData["topic"] = topic;
    }

    Map<String, dynamic> inputData = {"message": messageData};

    var prettyString = const JsonEncoder.withIndent('  ').convert(inputData);
    Loggers.info(prettyString);
    try {
      http.Response response = await http.post(
          Uri.parse(WebService.notification.pushNotificationToSingleUser),
          headers: {
            Params.apikey: apiKey,
            Params.authToken:
                authorizationToken ?? SessionManager.instance.getAuthToken()
          },
          body: json.encode(inputData));
      Loggers.success('Notification response : ${response.body}');
    } catch (e) {
      Loggers.error(e);
    }
  }
}
