import 'dart:async';

import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/manager/firebase_notification_manager.dart';
import 'package:shortzz/common/manager/haptic_manager.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/manager/share_manager.dart';
import 'package:shortzz/common/service/api/moderator_service.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/widget/confirmation_dialog.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/status_model.dart';
import 'package:shortzz/model/post_story/post_by_id.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/comment_sheet/comment_sheet.dart';
import 'package:shortzz/screen/comment_sheet/comment_sheet_controller.dart';
import 'package:shortzz/screen/gift_sheet/send_gift_sheet_controller.dart';
import 'package:shortzz/screen/profile_screen/profile_screen_controller.dart';
import 'package:shortzz/screen/report_sheet/report_sheet.dart';

class PostScreenController extends BaseController {
  Timer? _debounce;

  bool _isLikeLoading = false;
  bool _isSavedLoading = false;

  User? get myUser => SessionManager.instance.getUser();
  Function triggerLikeAnim = () {}; // 🎯 Persisted here

  Rx<Post> postData;
  bool isFromSinglePostScreen;

  PostScreenController(this.postData, this.isFromSinglePostScreen);

  void updatePost(Post post) {
    postData.update((val) {
      val = post;
    });
  }

  void onLike(Post? post) async {
    Loggers.success(post?.user?.appLanguage);
    if (_isLikeLoading || post == null) return;
    _isLikeLoading = true;

    postData.update((val) {
      val?.likeToggle(!(post.isLiked ?? false));
    });

    try {
      await (post.isLiked ?? false ? _likePostApi(post) : _disLikePostApi(post));
    } finally {
      _isLikeLoading = false;
    }
  }

  Future<void> _likePostApi(Post? post) async {
    StatusModel model = await PostService.instance.likePost(postId: post?.id ?? -1);

    if (model.status == true) {
      if (post?.user?.notifyPostLike == 1 && myUser?.id != post?.userId) {
        print(post?.user?.toJson());
        FirebaseNotificationManager.instance.sendLocalisationNotification(LKey.activityLikedPost,
            type: NotificationType.post,
            body: NotificationInfo(id: post?.id),
            deviceType: post?.user?.device ?? 0,
            deviceToken: post?.user?.deviceToken ?? '',
            languageCode: post?.user?.appLanguage);
      }
    }
  }

  Future<void> _disLikePostApi(Post? post) async {
    await PostService.instance.disLikePost(postId: post?.id?.convertInt ?? -1);
  }

  void onComment({PostByIdData? postByIdData, bool isFromNotification = false}) async {
    if (isFromSinglePostScreen) {
      if (Get.isRegistered<CommentSheetController>()) {
        final controller = Get.find<CommentSheetController>();
        controller.commentHelper.detectableTextFocusNode.requestFocus();
      }
    } else {
      Get.bottomSheet(
          CommentSheet(
              post: postData.value,
              isFromNotification: isFromNotification,
              comment: postByIdData?.comment,
              replyComment: postByIdData?.reply),
          isScrollControlled: true);
    }
  }

  void onSaved(Post? post) async {
    if (_isSavedLoading || post == null) return;
    _isSavedLoading = true;
    HapticManager.shared.light();
    postData.update((val) {
      val?.saveToggle(post.isSaved == true ? false : true);
    });
    try {
      DebounceAction.shared.call(() async {
        await ((post.isSaved ?? false) ? _savePostApi(post) : _unSavePostApi(post));
      });
    } finally {
      _isSavedLoading = false;
    }
  }

  Future<void> _savePostApi(Post? post) async {
    await PostService.instance.savePost(postId: post?.id?.convertInt ?? -1);
  }

  Future<void> _unSavePostApi(Post? post) async {
    await PostService.instance.unSavePost(postId: post?.id?.convertInt ?? -1);
  }

  void handlePinUnpinPost(int isPinned) {
    if (Get.isRegistered<ProfileScreenController>(tag: ProfileScreenController.tag)) {
      final controller = Get.find<ProfileScreenController>(tag: ProfileScreenController.tag);

      if (isPinned == 0) {
        controller.updatePinPost(postData.value);
      } else {
        controller.updateUnPinPost(postData.value);
      }
    }
  }

  Future<void> handleShare() async {
    Post _post = postData.value;
    if (_post.id == null) {
      return Loggers.error('Invalid Post ID : ${_post.id}');
    }

    ShareManager.shared.showCustomShareSheet(
        post: _post,
        keys: ShareKeys.post,
        onShareSuccess: () {
          postData.update((val) => val?.increaseShares(1));
        });
  }

  void handleDelete(Post post, {required bool isModerator}) async {
    Get.bottomSheet(
      ConfirmationSheet(
          title: LKey.deletePostTitle.tr,
          onTap: () => _deletePost(post, isModerator: isModerator),
          description: LKey.deletePostMessage.tr),
    );
  }

  void _deletePost(Post post, {required bool isModerator}) async {
    showLoader();
    StatusModel model;
    if (isModerator) {
      model = await ModeratorService.instance.moderatorDeletePost(postId: post.id);
    } else {
      model = await PostService.instance.deletePost(postId: post.id);
    }
    stopLoader();
    if (model.status == true) {
      if (Get.isRegistered<ProfileScreenController>(tag: ProfileScreenController.tag)) {
        final controller = Get.find<ProfileScreenController>(tag: ProfileScreenController.tag);
        controller.posts.removeWhere((element) => element.id == post.id);
        postData.value = Post();
        Get.delete<PostScreenController>(tag: '${post.id}');
      }
    }
  }

  void handleReport(Post? post) {
    if (post == null) return;
    Get.bottomSheet(ReportSheet(id: post.id, reportType: ReportType.post), isScrollControlled: true);
  }

  void notifyCommentSheet(PostByIdData? data) {
    if (data != null && (data.comment != null || data.reply != null)) {
      DebounceAction.shared.call(() {
        onComment(postByIdData: data, isFromNotification: true);
      }, milliseconds: 1000);
    }
  }

  void onGiftTap(Post? post) {
    GiftManager.openGiftSheet(
      userId: post?.userId ?? -1,
      onCompletion: (giftManager) {
        GiftManager.showAnimationDialog(giftManager.gift);
        GiftManager.sendNotification(post);
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    _debounce?.cancel();
  }
}
