import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/misc/activity_notification_model.dart';
import 'package:shortzz/screen/comment_sheet/helper/comment_helper.dart';
import 'package:shortzz/screen/notification_screen/notification_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ActivityNotificationPage extends StatelessWidget {
  final ActivityNotification data;
  final NotificationScreenController controller;

  const ActivityNotificationPage(
      {super.key, required this.data, required this.controller});

  @override
  Widget build(BuildContext context) {
    final postWidget = _buildPostOrGiftImage(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
      child: Row(
        spacing: 10,
        children: [
          CustomImage(
            onTap: () {
              controller.onUserTap(data.fromUser);
            },
            size: const Size(38, 38),
            fit: BoxFit.cover,
            image: data.fromUser?.profilePhoto?.addBaseURL(),
            fullName: data.fromUser?.fullname,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FullNameWithBlueTick(
                    username: data.fromUser?.username,
                    fontSize: 12,
                    isVerify: data.fromUser?.isVerify,
                    onTap: () => controller.onDescriptionTap(data)),
                if (data.type != ActivityNotifyType.none)
                  InkWell(
                      onTap: () => controller.onDescriptionTap(data),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          _getNotificationText(),
                          style: TextStyleCustom.outFitRegular400(
                            fontSize: 15,
                            color: textLightGrey(context),
                          ),
                        ),
                      )),
              ],
            ),
          ),
          if (postWidget != null) postWidget,
        ],
      ),
    );
  }

  /// Map notification type to text
  String _getNotificationText() {
    final commentDesc = data.data?.comment?.commentDescription ?? '';

    final replyCommentDesc =
        (data.data?.reply ?? data.data?.comment)?.commentDescription ?? '';

    switch (data.type) {
      case ActivityNotifyType.notifyLikePost:
        return LKey.activityLikedPost.tr;
      case ActivityNotifyType.notifyCommentPost:
        if (data.data?.comment?.type == CommentType.image) {
          return LKey.activityGIFComment.tr;
        }
        return LKey.activityCommentedPost
            .trParams({'comment_description': commentDesc});
      case ActivityNotifyType.notifyMentionPost:
        return LKey.notifyMentionedInPost.tr;
      case ActivityNotifyType.notifyMentionComment:
      case ActivityNotifyType.notifyReplyComment:
        return LKey.activityReplyingToComment.trParams({
          'username': data.fromUser?.username ?? '',
          'comment_description': replyCommentDesc,
        });
      case ActivityNotifyType.notifyMentionReply:
        return LKey.notifyReplyMentionedInComment
            .trParams({'comment_description': commentDesc});
      case ActivityNotifyType.notifyFollowUser:
        return LKey.notifyStartedFollowing.tr;
      case ActivityNotifyType.notifyGiftUser:
        return LKey.activitySentGift.tr;
      default:
        return '';
    }
  }

  /// Builds image widget based on type
  Widget? _buildPostOrGiftImage(BuildContext context) {
    final type = data.type;
    final post = data.data?.post;

    if (type == ActivityNotifyType.notifyGiftUser) {
      return NotificationGiftIcon(gift: data.data?.gift);
    }

    if ([
          ActivityNotifyType.notifyLikePost,
          ActivityNotifyType.notifyCommentPost,
          ActivityNotifyType.notifyMentionPost,
          ActivityNotifyType.notifyMentionComment,
          ActivityNotifyType.notifyReplyComment,
          ActivityNotifyType.notifyMentionReply,
        ].contains(type) &&
        post?.postType != PostType.text) {
      return CustomImage(
          onTap: () {
            controller.onPostTap(data);
          },
          image: (post?.postType == PostType.image
                  ? post?.images?.first.image
                  : post?.thumbnail)
              ?.addBaseURL(),
          size: const Size(35, 35),
          radius: 5,
          cornerSmoothing: 1,
          isShowPlaceHolder: true,
          fit: BoxFit.cover);
    }

    return null;
  }
}

class NotificationGiftIcon extends StatelessWidget {
  final Gift? gift;

  const NotificationGiftIcon({super.key, this.gift});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: textDarkGrey(context),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          spacing: 5,
          children: [
            CustomImage(
              size: const Size(25, 25),
              image: gift?.image?.addBaseURL(),
              isShowPlaceHolder: true,
            ),
            Image.asset(AssetRes.icCoin, height: 18, width: 18),
            Text(
              (gift?.coinPrice ?? 0).numberFormat,
              // Consider using `gift?.amount.toString()` if dynamic
              style: TextStyleCustom.outFitRegular400(
                color: whitePure(context),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ActivityNotifyType {
  none(0),
  notifyLikePost(1),
  notifyCommentPost(2),
  notifyMentionPost(3),
  notifyMentionComment(4),
  notifyFollowUser(5),
  notifyGiftUser(6),
  notifyReplyComment(7),
  notifyMentionReply(8);

  final int type;

  const ActivityNotifyType(this.type);

  static ActivityNotifyType fromString(int value) {
    return ActivityNotifyType.values.firstWhere((e) => e.type == value,
        orElse: () =>
            throw ArgumentError('Invalid activity notify type : $value'));
  }
}
