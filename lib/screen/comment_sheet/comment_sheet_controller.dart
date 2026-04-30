import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/manager/firebase_notification_manager.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/widget/confirmation_dialog.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/general/status_model.dart';
import 'package:shortzz/model/post_story/comment/fetch_comment_model.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/comment_sheet/helper/comment_helper.dart';
import 'package:shortzz/screen/gif_sheet/gif_sheet.dart';
import 'package:shortzz/screen/post_screen/post_screen_controller.dart';
import 'package:shortzz/screen/reels_screen/reel/reel_page_controller.dart';
import 'package:shortzz/utilities/app_res.dart';

class CommentSheetController extends BaseController {
  Rx<Post?> post;

  Rx<User?> myUser = Rx(null);
  Rx<Setting?> settingData = Rx<Setting?>(null);

  bool isLikeDislikeComment = false;
  RxBool isFetchReplyComment = false.obs;
  RxInt replyCommentId = 0.obs;
  RxList<Comment> commentsList = <Comment>[].obs;

  Comment? comment;
  int? commentBlinkId;

  RxList<Comment> get getCommentsList {
    final tempList = <Comment>[
      if (comment != null) comment!,
      ...commentsList.where((c) => c.id != comment?.id),
    ];
    return tempList.obs;
  }

  Comment? replyComment;

  ScrollController scrollController = ScrollController();
  bool isFromNotification;
  GlobalKey commentKey = GlobalKey();
  CommentHelper commentHelper;

  RxMap<int, RxList<Comment>> getReplyCommentsList = <int, RxList<Comment>>{}.obs;

  CommentSheetController(
      this.post, this.comment, this.replyComment, this.isFromNotification, this.commentHelper) {
    if (replyComment != null) {
      final map = Map<int, RxList<Comment>>.from({});

      if (replyComment != null) {
        final id = replyComment?.commentId ?? -1;

        if (id != -1) {
          map.putIfAbsent(id, () => <Comment>[].obs);

          final exists = map[id]?.any((c) => c.id == replyComment?.id);
          if (exists == false) {
            map[id]?.insert(0, replyComment!); // Insert at top or bottom based on UI logic
          }
        }
      }
      getReplyCommentsList.value = map;
    }
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  @override
  void onReady() {
    super.onReady();
    post.listen((p0) {
      if (p0 == null) return;
      switch (p0.postType) {
        case PostType.reel:
          if (Get.isRegistered<ReelController>(tag: '${p0.id}')) {
            final controller = Get.find<ReelController>(tag: '${p0.id}');
            controller.reelData.update((val) => val?.comments = p0.comments);
          }
          break;
        case PostType.image:
        case PostType.video:
        case PostType.text:
          if (Get.isRegistered<PostScreenController>(tag: '${p0.id}')) {
            final controller = Get.find<PostScreenController>(tag: '${p0.id}');
            controller.postData.update((val) => val?.comments = p0.comments);
          }
          break;
        case PostType.none:
          break;
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    post.close();
  }

  initData() {
    myUser.value = SessionManager.instance.getUser();
    settingData.value = SessionManager.instance.getSettings();
    DebounceAction.shared.call(() {
      fetchComments();
    }, milliseconds: 100);
  }

  Future<void> fetchComments({bool isEmpty = false}) async {
    final postId = post.value?.id?.toInt() ?? -1;
    if (postId == -1) {
      return Loggers.error('Invalid Post Id: $postId');
    }
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final items = await PostService.instance.fetchPostComments(
        postId: postId,
        lastItemId: isEmpty ? null : commentsList.lastOrNull?.id?.toInt(),
      );

      if (items == null) return;

      if (isEmpty) {
        commentsList.clear();
      }

      // Add pinned comments only once
      if (commentsList.isEmpty) {
        final pinned = items.pinnedComments ?? [];
        for (final pin in pinned) {
          if (!commentsList.any((c) => c.id == pin.id)) {
            commentsList.add(pin);
          }
        }
      }

      // Add regular comments (avoid duplicates)
      final fetchedComments = items.comments ?? [];
      for (final newComment in fetchedComments) {
        if (!commentsList.any((existing) => existing.id == newComment.id)) {
          commentsList.add(newComment);
        }
      }
      post.update((val) => val?.comments = commentsList.length);
    } catch (e) {
      Loggers.error('Error fetching comments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReplyComment(Comment comment) async {
    final commentId = comment.id?.toInt() ?? -1;

    if (commentId == -1) {
      Loggers.warning('Invalid commentId. Skipping fetch.');
      return;
    }

    if (isFetchReplyComment.value) return;

    isFetchReplyComment.value = true;
    replyCommentId.value = commentId;
    int? lastItemId = replyComment != null
        ? null
        : getReplyCommentsList.isEmpty
            ? null
            : getReplyCommentsList[commentId]?.lastOrNull?.id;

    try {
      final items = await PostService.instance
          .fetchPostCommentReplies(commentId: commentId, lastItemId: lastItemId);

      // Ensure the list exists
      getReplyCommentsList.putIfAbsent(commentId, () => <Comment>[].obs);

      // Add only new comments
      for (final item in items) {
        final exists = getReplyCommentsList[commentId]!.any((c) => c.id == item.id);
        if (!exists) {
          getReplyCommentsList[commentId]!.add(item);
        }
      }

      Loggers.success('Total comment threads: ${getReplyCommentsList.length}');
    } catch (e) {
      Loggers.error('Error fetching replies for commentId $commentId: $e');
    } finally {
      isFetchReplyComment.value = false;
      replyCommentId.value = 0;
    }
  }

  void hideReplyComment(Comment comment) {
    int commentId = comment.id?.toInt() ?? -1;
    if (commentId == -1) {
      Loggers.warning('Invalid comment Id : $commentId');
      return;
    }

    Comment? _comment = commentsList.firstWhereOrNull((element) => element.id == commentId);
    if (_comment != null) {
      getReplyCommentsList[commentId]?.clear();
    }
  }

  Future<void> _handleCommentLikeDislike(Comment? comment, bool like,
      {Function(Comment? comment)? onCompletion}) async {
    if (comment == null) return;

    int commentId = comment.id?.toInt() ?? -1;
    if (commentId == -1) {
      Loggers.warning('Invalid Comment Id: $commentId');
      return;
    }

    if (isLikeDislikeComment) {
      return; // Prevent concurrent like/dislike actions.
    }
    isLikeDislikeComment = true;
    HapticFeedback.lightImpact();
    comment.updateLike(like);
    commentsList[commentsList.indexWhere((element) => element.id == commentId)] = comment;

    StatusModel response;
    if (like) {
      response = await PostService.instance.likeComment(commentId: commentId);
      onCompletion?.call(comment);
    } else {
      response = await PostService.instance.disLikeComment(commentId: commentId);
    }

    if (response.status == false) {
      comment.updateLike(!like); // Revert the like/dislike change if the API call fails.
      commentsList[commentsList.indexWhere((element) => element.id == commentId)] = comment;
    }

    isLikeDislikeComment = false;
  }

  void likeComment(Comment? comment) async {
    await _handleCommentLikeDislike(comment, true, onCompletion: (comment) {
      print(comment?.user?.notifyPostComment);
      print(myUser.value?.id != comment?.userId);
      if (myUser.value?.id != comment?.userId && comment?.user?.notifyPostComment == 1) {
        FirebaseNotificationManager.instance.sendLocalisationNotification(LKey.commentHasBeenLiked,
            type: NotificationType.post,
            deviceToken: comment?.user?.deviceToken,
            languageCode: comment?.user?.appLanguage,
            body: NotificationInfo(id: comment?.postId, commentId: comment?.id),
            deviceType: comment?.user?.device);
      }
    });
  }

  void unlikeComment(Comment? comment) async {
    await _handleCommentLikeDislike(comment, false);
  }

  Future<void> onPinnedComment(Comment comment) async {
    int commentId = comment.id?.toInt() ?? -1;
    if (commentId == -1) {
      Loggers.warning('Invalid Comment Id');
      return;
    }

    List<Comment> existingPinComment = [];

    for (var element in commentsList) {
      if (element.isPinned == 1) {
        existingPinComment.add(element);
      }
    }

    if ((settingData.value?.maxCommentPins ?? AppRes.maxPinComment) > existingPinComment.length) {
      await pinComment(comment);
    } else {
      showSnackBar(LKey.pinLimitExceededForComment.trParams({
        'pin_comment_count': (settingData.value?.maxCommentPins ?? AppRes.maxPinComment).toString()
      }));
    }
  }

  Future<void> onUnPinComment(Comment comment) async {
    StatusModel response =
        await PostService.instance.unPinComment(commentId: comment.id?.toInt() ?? -1);
    if (response.status == true) {
      fetchComments(isEmpty: true);
    }
  }

  Future<void> pinComment(Comment comment) async {
    StatusModel response =
        await PostService.instance.pinComment(commentId: comment.id?.toInt() ?? -1);
    if (response.status == true) {
      commentsList.removeWhere((element) => element.id == comment.id);
      comment.isPinned = 1;
      commentsList.insert(0, comment);
    }
  }

  void onDeleteComment(Comment comment) {
    bool isReplyComment = comment.reply != null;
    Get.bottomSheet(
        ConfirmationSheet(
          title: !isReplyComment ? LKey.deleteCommentTitle.tr : LKey.deleteReplyCommentTitle.tr,
          description: LKey.deleteCommentMessage.tr,
          onTap: () => !isReplyComment ? _deleteComment(comment) : _deleteReplyComment(comment),
        ),
        isScrollControlled: true);
  }

  Future<void> _deleteComment(Comment comment) async {
    int commentId = comment.id?.toInt() ?? -1;
    if (commentId == -1) {
      return Loggers.error('Invalid Comment Id : $commentId');
    }
    showLoader();
    StatusModel model = await PostService.instance.deleteComment(commentId: commentId);
    stopLoader();
    if (model.status == true) {
      commentsList.removeWhere((element) => element.id == commentId);
      post.update((val) => val?.updateCommentCount(-1));
    }
  }

  Future<void> _deleteReplyComment(Comment comment) async {
    int replyId = comment.id?.toInt() ?? -1;
    int commentId = comment.commentId?.toInt() ?? -1;
    if (replyId == -1) {
      return Loggers.error('Invalid Reply Comment Id : $replyId');
    }
    showLoader();
    StatusModel model = await PostService.instance.deleteCommentReply(replyId: replyId);
    stopLoader();
    if (model.status == true) {
      (getReplyCommentsList[commentId] ?? []).remove(comment);
      updateCommentList(commentId, -1);
    }
  }

  Future<void> onSendComment() async {
    bool isRegister = Get.isRegistered<ReelController>(tag: "${post.value?.id}");
    if (commentHelper.isTextComment.value) {
      await commentHelper.onCommentPost(
          reel: post.value!,
          commentType: CommentType.text,
          onUpdateComment: (comment, isReplyComment) {
            if (isReplyComment) {
              RxList<Comment> items = getReplyCommentsList.putIfAbsent(
                  comment.commentId?.toInt() ?? -1, () => <Comment>[].obs);
              items.insert(0, comment);
              updateCommentList(comment.commentId ?? -1, 1);
              getReplyCommentsList.refresh();
            } else {
              int existingPinnedComment = commentsList.where((p0) => p0.isPinned == 1).length;
              commentsList.insert(existingPinnedComment, comment);
              post.update((val) => val?.updateCommentCount(1));
              if (isRegister) {
                Get.find<ReelController>(tag: "${post.value?.id}").reelData.update((val) {
                  val?.updateCommentCount(0);
                });
              }
            }
          });
    } else {
      commentHelper.detectableTextFocusNode.unfocus();
      String? value = await Get.bottomSheet<String?>(const GifSheet(), isScrollControlled: true);
      if (value != null) {
        await commentHelper.handleAddComment(value, CommentType.image, post.value!).then((value) {
          if (value != null) {
            int existingPinnedComment = commentsList.where((p0) => p0.isPinned == 1).length;
            commentsList.insert(existingPinnedComment, value);
            post.update((val) => val?.updateCommentCount(1));
            if (isRegister) {
              Get.find<ReelController>(tag: "${post.value?.id}").reelData.update((val) {
                val?.updateCommentCount(0);
              });
            }
            Post? _post = post.value;
            if (_post?.user?.notifyPostComment == 1 && _post?.user?.id != myUser.value?.id) {
              FirebaseNotificationManager.instance.sendLocalisationNotification(
                  LKey.activityGIFComment,
                  type: NotificationType.post,
                  languageCode: _post?.user?.appLanguage,
                  deviceToken: _post?.user?.deviceToken,
                  deviceType: _post?.user?.device,
                  body: NotificationInfo(id: _post?.id, commentId: value.id));
            }
          }
        });
      }
    }
  }

  void updateCommentList(int id, int count) {
    if (id != -1) {
      Comment? _comment = commentsList.firstWhereOrNull((element) => element.id == id);
      if (_comment != null) {
        _comment.repliesCount = (_comment.repliesCount ?? 0) + count;
        commentsList[commentsList.indexWhere((element) => element.id == id)] = _comment;
      }
    }
  }
}
