import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/manager/firebase_notification_manager.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/status_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';

class FollowController extends BaseController {
  Rx<User?> user;

  FollowController(this.user);

  updateUser(User? user) {
    this.user.value = user;
  }

  Future<User?> followUnFollowUser() async {
    int userId = user.value?.id ?? -1;
    bool isFollowing = user.value?.isFollowing ?? false;
    if (userId == -1) {
      Loggers.error('Invalid user id : $userId');
      return null;
    }

    try {
      StatusModel response;
      if (isFollowing) {
        response = await _unFollowUser(userId: userId);
      } else {
        response = await _followUser(userId: userId);
      }

      if (response.status == true) {
        user.update((val) {
          final isNowFollowing = !(val?.isFollowing ?? false);
          val?.isFollowing = isNowFollowing;
          val?.updateFollowerCount(isNowFollowing);
        });
        // Loggers.success(response.message);
        Loggers.success(user.value?.isFollowing);
        User? _user = user.value;
        if (_user != null &&
            user.value?.isFollowing == true &&
            _user.notifyFollow == 1 &&
            _user.id != SessionManager.instance.getUserID()) {
          FirebaseNotificationManager.instance.sendLocalisationNotification(
              LKey.notifyStartedFollowing,
              type: NotificationType.user,
              languageCode: _user.appLanguage,
              deviceToken: _user.deviceToken,
              deviceType: _user.device,
              body: NotificationInfo(id: SessionManager.instance.getUserID()));
        }
        return user.value;
      } else {
        Loggers.error('Failed to update follow status for User ID: $userId');
        return null;
      }
    } catch (e) {
      Loggers.error('Error in followUnFollowUser : $e');
      return null;
    }
  }

  Future<StatusModel> _followUser({required int userId}) async {
    StatusModel result = await UserService.instance.followUser(userId: userId);
    if (result.status == true) {
      FirebaseNotificationManager.instance.subscribeToTopic(topic: '$userId');
    }
    return result;
  }

  Future<StatusModel> _unFollowUser({required int userId}) async {
    StatusModel result =
        await UserService.instance.unFollowUser(userId: userId);
    if (result.status == true) {
      FirebaseNotificationManager.instance.unsubscribeToTopic(topic: '$userId');
    }
    return result;
  }
}
