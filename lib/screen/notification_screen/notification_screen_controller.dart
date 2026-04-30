import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/service/api/notification_service.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/service/navigation/navigate_with_controller.dart';
import 'package:shortzz/model/misc/activity_notification_model.dart';
import 'package:shortzz/model/misc/admin_notification_model.dart';
import 'package:shortzz/model/post_story/post_by_id.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/notification_screen/widget/activity_notification_page.dart';
import 'package:shortzz/screen/post_screen/single_post_screen.dart';
import 'package:shortzz/screen/reels_screen/reels_screen.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';

class NotificationScreenController extends BaseController {
  RxInt selectedTabIndex = RxInt(0);

  RxList<AdminNotificationData> adminNotifications =
      <AdminNotificationData>[].obs;
  RxList<ActivityNotification> activityNotifications =
      <ActivityNotification>[].obs;

  RxBool isActivityNotification = RxBool(false);
  RxBool isAdminNotification = RxBool(false);

  PageController pageController = PageController();

  @override
  void onInit() {
    iniData();
    super.onInit();
  }

  onTabChange(int index) {
    selectedTabIndex.value = index;
  }

  void iniData() {
    fetchActivityNotifications();
    fetchAdminNotification();
  }

  Future<void> fetchAdminNotification() async {
    if (isAdminNotification.value) return;
    isAdminNotification.value = true;
    List<AdminNotificationData> items = await NotificationService.instance
        .fetchAdminNotifications(lastItemId: adminNotifications.lastOrNull?.id);
    isAdminNotification.value = false;
    if (items.isNotEmpty) {
      adminNotifications.addAll(items);
    }
  }

  Future<void> fetchActivityNotifications() async {
    if (isActivityNotification.value) return;
    isActivityNotification.value = true;
    List<ActivityNotification> items = await NotificationService.instance
        .fetchActivityNotifications(
            lastItemId: activityNotifications.lastOrNull?.id);
    isActivityNotification.value = false;
    if (items.isNotEmpty) {
      activityNotifications.addAll(items);
    }
  }


  void onPostTap(ActivityNotification? data) async {
    Post? post = data?.data?.post;
    int? commentId = data?.data?.comment?.id;
    int? replyCommentId = data?.data?.reply?.id;

    if (post?.id == null) return;

    showLoader();
    final PostByIdModel result = await PostService.instance.fetchPostById(
        postId: post!.id!, commentId: commentId, replyId: replyCommentId);
    stopLoader();

    if (result.status != true || result.data == null) {
      showSnackBar(result.message);
      return;
    }
    final Post? fetchedPost = result.data?.post;
    if (fetchedPost == null) return;
    final postType = post.postType;

    if (postType == PostType.reel) {
      Get.to(() => ReelsScreen(
            reels: [fetchedPost].obs,
        position: 0,
        postByIdData: result.data,
            pageType: ReelPageType.notification,
          ));
    } else if ([PostType.image, PostType.video, PostType.text]
        .contains(postType)) {
      Get.to(() => SinglePostScreen(
          post: fetchedPost,
          postByIdData: result.data,
          isFromNotification: true));
    }
  }

  void onDescriptionTap(ActivityNotification data) {
    if ([
      ActivityNotifyType.notifyLikePost,
      ActivityNotifyType.notifyCommentPost,
      ActivityNotifyType.notifyMentionPost,
      ActivityNotifyType.notifyMentionComment,
      ActivityNotifyType.notifyReplyComment,
      ActivityNotifyType.notifyMentionReply,
    ].contains(data.type)) {
      onPostTap(data);
    } else if (ActivityNotifyType.notifyFollowUser == data.type) {
      onUserTap(data.fromUser);
    }
  }

  void onUserTap(User? user) async {
    NavigationService.shared.openProfileScreen(user);
  }
}
