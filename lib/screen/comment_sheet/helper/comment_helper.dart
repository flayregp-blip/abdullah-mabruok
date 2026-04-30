import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/manager/firebase_notification_manager.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/service/api/search_service.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/service/url_extractor/metadata_extract_base.dart';
import 'package:shortzz/common/service/url_extractor/parsers/base_parser.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/comment/fetch_comment_model.dart';
import 'package:shortzz/model/post_story/hashtag_model.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/create_feed_screen/create_feed_screen_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';

class CommentHelper {
  RxBool isLoading = false.obs;
  RxBool isHashTagView = false.obs;
  RxBool isMentionUserView = false.obs;
  RxList<User> searchUsers = <User>[].obs;
  List<User> allMentionUsers = <User>[];
  List<User> finalUsers = <User>[];
  RxList<Hashtag> hashTags = <Hashtag>[].obs;
  RxBool isReplyUser = false.obs;
  RxBool isTextComment = false.obs;
  Rx<Comment?> replyComment = Rx(null);
  RxBool isDetectableTextEmpty = true.obs;
  Rx<UrlMetadata?> metaData = Rx(null);
  Set<String> closedUrls = {};
  DetectableTextEditingController detectableTextController =
      DetectableTextEditingController(
          detectedStyle: TextStyleCustom.outFitMedium500(
              fontSize: 16, color: ColorRes.themeGradient2),
          regExp: AppRes.combinedRegex);

  User? get myUser => SessionManager.instance.getUser();

  FocusNode detectableTextFocusNode = FocusNode();

  /// Handles changes in the detectable text field.
  void onChanged(String value) {
    if (value.isNotEmpty) {
      isTextComment.value = true;
      isDetectableTextEmpty.value = false;
    } else {
      isDetectableTextEmpty.value = true;
      if (replyComment.value == null) {
        isTextComment.value = false;
      }
    }

    DebounceAction.shared.call(() {
      fetchUrlPreview();
    }, milliseconds: 2000);

    String detectableString = detectableTextController.typingDetection ?? '';

    if (detectableString.contains('@')) {
      searchMentionUsers(detectableString);
    } else if (detectableString.contains('#')) {
      searchHashTag(detectableString);
    } else {
      _clearDetectionViews();
    }
  }

  void searchMentionUsers(String value) {
    isMentionUserView.value = true;
    isLoading.value = true;
    DebounceAction.shared.call(
      () async {
        List<User> items = await UserService.instance.searchUsers(
            keyWord: value.split('@')[1],
            limit: AppRes.paginationLimitDetectWord);
        searchUsers
          ..clear()
          ..addAll(items);

        for (var item in items) {
          bool isExist =
              allMentionUsers.any((element) => element.id == item.id);
          if (!isExist) {
            allMentionUsers.add(item);
          }
        }

        isLoading.value = false;
      },
    );
  }

  void searchHashTag(String value) async {
    isHashTagView.value = true;
    isLoading.value = true;
    DebounceAction.shared.call(() async {
      List<Hashtag> items = await SearchService.instance
          .searchHashtags(keyword: value.split('#')[1]);
      hashTags.clear();
      hashTags.addAll(items);
      isLoading.value = false;
    });
  }

  /// Clears both detection views.
  void _clearDetectionViews() {
    isMentionUserView.value = false;
    isHashTagView.value = false;
    isLoading.value = false;
  }

  /// Appends the selected mention or hashtag to the detectable text.
  void appendDetection(dynamic item, DetectType detectType,
      {required int type}) {
    final symbol = detectType == DetectType.atSign ? '@' : '#';
    final text = detectType == DetectType.atSign ? item.username : item.hashtag;
    isDetectableTextEmpty.value = false;
    detectableTextFocusNode.requestFocus();
    if (type == 0) {
      // close sheet
      Get.back();
      detectableTextController.text += '$symbol$text ';
    } else {
      detectType == DetectType.atSign
          ? isMentionUserView.value = false
          : isHashTagView.value = false;

      String? detection = detectableTextController.typingDetection;

      if (detection != null) {
        int cursorPosition = detectableTextController.selection.baseOffset;
        if (cursorPosition != -1) {
          String textBeforeCursor =
              detectableTextController.text.substring(0, cursorPosition);
          String textAfterCursor =
              detectableTextController.text.substring(cursorPosition);

          if (textBeforeCursor.endsWith(detection)) {
            detectableTextController.text =
                '${textBeforeCursor.substring(0, textBeforeCursor.length - detection.length)} $symbol$text $textAfterCursor';

            detectableTextController.selection = TextSelection.fromPosition(
              TextPosition(
                  offset: textBeforeCursor.length -
                      detection.length +
                      ' $symbol$text '.length),
            );
          }
        }
      }
    }

    if (detectType == DetectType.atSign &&
        allMentionUsers.every((element) => element.id != item.id)) {
      allMentionUsers.add(item);
    }
  }

  Future<void> onCommentPost({
    required Post reel,
    required CommentType commentType,
    required Function(Comment comment, bool isReplyComment) onUpdateComment,
  }) async {
    String description = detectableTextController.text.trim();

    if (description.isEmpty) {
      return Loggers.error('Comment field is empty');
    }

    detectableTextController.clear();
    detectableTextFocusNode.unfocus();
    isTextComment.value = false;

    List<int> mentionUserIds = _extractMentionUserIds(description);
    List<User> mentionUsers = _extractMentionUsersWithIds(mentionUserIds);
    finalUsers = List<User>.from(mentionUsers);
    description = _replaceMentionsWithUserIds(description, allMentionUsers);
    allMentionUsers.clear();
    Comment? replyComment = this.replyComment.value == null
        ? null
        : Comment.fromJson(this.replyComment.value?.toJson());

    bool isReply = replyComment != null;

    print(isReply);

    Comment? comment = isReply
        ? await _handleReplyComment(description,
            mentionUserIds: mentionUserIds.join(','))
        : await handleAddComment(description, commentType, reel,
            mentionUserIds: mentionUserIds.join(','));
    comment?.mentionedUsers = mentionUsers;
    if (comment == null) return;
    // Loggers.success('REPLY COMMENT : ${comment.toJson()}');
    onUpdateComment.call(comment, isReply);
    _sendCommentNotification(reel, comment, isReply, replyComment);
    _notifyMentionedUsers(reel, comment, isReply);
  }

  List<int> _extractMentionUserIds(String description) {
    Set<String> mentions =
        TextPatternDetector.extractDetections(description, AppRes.detectableReg)
            .where((e) => e.contains('@'))
            .map((e) => e.replaceAll('@', ''))
            .toSet();

    List<int> ids = [];

    for (final username in mentions) {
      final user =
          allMentionUsers.firstWhereOrNull((u) => u.username == username);
      if (user != null && !ids.contains(user.id)) {
        ids.add(user.id ?? -1);
      }
    }
    return ids;
  }

  List<User> _extractMentionUsersWithIds(List<int> mentionIds) {
    List<User> users = [];
    for (final userId in mentionIds) {
      final user = allMentionUsers.firstWhereOrNull((u) => u.id == userId);
      if (user != null) {
        users.add(user);
      }
    }

    return users;
  }

  String _replaceMentionsWithUserIds(
      String description, List<User> mentionUsers) {
    final regex = RegExp(r'@([\w.-]+)');

    return description.replaceAllMapped(regex, (match) {
      String? username =
          match.group(1); // Now correctly captures the username without '@'

      User? user = mentionUsers.firstWhereOrNull((u) => u.username == username);

      if (user != null) {
        return '@${user.id}';
      } else {
        return match.group(0)!; // fallback to original @username
      }
    });
  }

  void _sendCommentNotification(
      Post reel, Comment comment, bool isReply, Comment? replyComment) {
    if (isReply) {
      final reply = replyComment;
      if (reply != null &&
          reply.userId != myUser?.id &&
          reply.user?.notifyPostComment == 1) {
        FirebaseNotificationManager.instance.sendLocalisationNotification(
          LKey.activityReplyingToComment,
          keyParams: {
            'username': myUser?.username ?? '',
            'comment_description': comment.commentDescription,
          },
          deviceToken: reply.user?.deviceToken ?? '',
          deviceType: reply.user?.device ?? 0,
          languageCode: reply.user?.appLanguage,
          body: NotificationInfo(
              id: reel.id,
              commentId: comment.commentId,
              replyCommentId: comment.id),
          type: NotificationType.post,
        );
      }
    }

    if (reel.userId != myUser?.id && reel.user?.notifyPostComment == 1) {
      if (isReply && replyComment?.userId == reel.userId) return;
      FirebaseNotificationManager.instance.sendLocalisationNotification(
        LKey.activityCommentedPost,
        keyParams: {'comment_description': comment.commentDescription},
        deviceToken: reel.user?.deviceToken ?? '',
        deviceType: reel.user?.device ?? 0,
        languageCode: reel.user?.appLanguage,
        body: NotificationInfo(
            id: reel.id,
            commentId: isReply ? comment.commentId : comment.id,
            replyCommentId: isReply ? comment.id : null),
        type: NotificationType.post,
      );
    }
  }

  Future<void> _notifyMentionedUsers(
      Post reel, Comment comment, bool isReply) async {
    const int batchSize = 5;
    List<Future> batch = [];

    int? commentId = isReply ? comment.commentId : comment.id;
    int? replyCommentId = isReply ? comment.id : null;

    if (commentId == null || (isReply && replyCommentId == null)) {
      return Loggers.error('Comment Id not found');
    }

    for (final user in finalUsers) {
      if (user.notifyMention == 1 && user.id != myUser?.id) {
        batch.add(FirebaseNotificationManager.instance
            .sendLocalisationNotification(LKey.notifyMentionedInComment,
                deviceToken: user.deviceToken ?? '',
                deviceType: user.device ?? 0,
                languageCode: user.appLanguage,
                body: NotificationInfo(
                    id: reel.id,
                    commentId: commentId,
                    replyCommentId: replyCommentId),
                type: NotificationType.post));

        if (batch.length >= batchSize) {
          await Future.wait(batch);
          batch.clear();
        }
      }
    }

    if (batch.isNotEmpty) {
      await Future.wait(batch);
    }

    finalUsers.clear();
  }

  Future<Comment?> handleAddComment(
      String description, CommentType type, Post post,
      {String? mentionUserIds}) async {
    int postId = post.id?.toInt() ?? -1;

    if (postId == -1) {
      Loggers.error('Invalid Post Id : $postId');
      return null;
    }

    Comment? comment = await PostService.instance.addComment(
        postId: postId,
        comment: description,
        mentionUserIds: mentionUserIds,
        type: type.value);
    return comment;
  }

  Future<Comment?> _handleReplyComment(String description,
      {String? mentionUserIds}) async {
    int commentId = replyComment.value?.id?.toInt() ?? -1;

    if (commentId == -1) {
      Loggers.error('Invalid Comment Id : $commentId');
      return null;
    }

    onCloseReply();

    Comment? comment = await PostService.instance.replyToComment(
        commentId: commentId,
        reply: description,
        mentionUserIds: mentionUserIds);

    return comment;
  }

  void onReply(Comment? comment) {
    isReplyUser.value = true;
    isTextComment.value = true;
    if (replyComment.value == null) {
      replyComment = Rx(comment);
    } else {
      replyComment.value = comment;
    }
    detectableTextFocusNode.requestFocus();
  }

  void onCloseReply() {
    isReplyUser.value = false;
    replyComment = null.obs;
    if (detectableTextController.text.isEmpty) {
      isTextComment.value = false;
    }
  }

  Future<void> fetchUrlPreview() async {
    List<String> urls = TextPatternDetector.extractDetections(
        detectableTextController.text.trim(), atSignUrlRegExp);

    for (var url in urls) {
      var urlString = url.toLowerCase().trim();

      if (urlString.isEmpty || closedUrls.contains(urlString)) continue;

      if (!urlString.startsWith('http')) {
        urlString = 'https://$urlString';
      }

      final value = await extract(urlString);
      if (value != null && value.url != null) {
        if (metaData.value?.url == value.url) {
          return;
        }
        metaData.value = value;
        return;
      }
    }

    // If no valid URL found
    metaData.value = null;
  }

  void onClosePreview() {
    metaData.value = null;
  }
}

enum CommentType {
  text,
  image;

  int get value => switch (this) {
        CommentType.text => 0,
        CommentType.image => 1,
      };
}
