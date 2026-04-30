import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/context_menu_widget.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/navigation/navigate_with_controller.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/comment/fetch_comment_model.dart';
import 'package:shortzz/screen/comment_sheet/comment_sheet_controller.dart';
import 'package:shortzz/screen/comment_sheet/helper/comment_helper.dart';
import 'package:shortzz/screen/post_screen/widget/post_view_center.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CommentCard extends StatelessWidget {
  final Comment? comment;
  final CommentSheetController controller;
  final bool isLikeButtonVisible;
  final bool isReplyVisible;

  const CommentCard(
      {super.key,
      required this.comment,
      required this.controller,
      required this.isLikeButtonVisible,
      required this.isReplyVisible});

  @override
  Widget build(BuildContext context) {
    bool isLike = comment?.isLiked == true;
    if (comment == null) {
      return const SizedBox();
    }
    return ContextMenuWidget(
      child: Container(
        color: whitePure(context),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImage(
              size: const Size(30, 30),
              strokeWidth: 1.5,
              image: comment?.user?.profilePhoto?.addBaseURL(),
              fullName: comment?.user?.fullname,
              onTap: () {
                NavigationService.shared.openProfileScreen(comment?.user);
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FullNameWithBlueTick(
                      onTap: () {
                        NavigationService.shared
                            .openProfileScreen(comment?.user);
                      },
                      username: comment?.user?.username ?? '',
                      isVerify: comment?.user?.isVerify,
                      child: Text(
                          '${comment?.createdAt?.timeAgo ?? ''}${comment?.isPinned == 1 ? AppRes.postPinIcon : ''}',
                          style: TextStyleCustom.outFitLight300(
                              color: textLightGrey(context)))),
                  const SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            switch (comment?.type) {
                              CommentType.text => PostTextView(
                                  description: comment?.commentDescription,
                                  mentionUsers: comment?.mentionedUsers ?? []),
                              CommentType.image => CustomImage(
                                  size: const Size(118, 118),
                                  image: comment?.comment,
                                  isShowPlaceHolder: true,
                                  radius: 0,
                                  fit: BoxFit.contain),
                              null => const SizedBox(),
                            },
                            if (isReplyVisible)
                              InkWell(
                                onTap: () {
                                  if (comment != null) {
                                    controller.commentHelper.onReply(comment);
                                  }
                                },
                                child: Text(
                                  LKey.reply.tr,
                                  style: TextStyleCustom.outFitRegular400(
                                      color: textLightGrey(context)),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (isLikeButtonVisible)
                        InkWell(
                          onTap: () {
                            if (isLike) {
                              controller.unlikeComment(comment);
                            } else {
                              controller.likeComment(comment);
                            }
                          },
                          child: Container(
                            // color: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Image.asset(
                                  isLike
                                      ? AssetRes.icFillHeart
                                      : AssetRes.icHeart,
                                  color: isLike
                                      ? ColorRes.likeRed
                                      : textDarkGrey(context),
                                  width: 19,
                                  height: 19,
                                ),
                                Opacity(
                                  opacity: (comment?.likes ?? 0) >= 1 ? 1 : 0,
                                  child: Text(
                                    (comment?.likes ?? 0).toInt().numberFormat,
                                    style: TextStyleCustom.outFitRegular400(
                                        fontSize: 13,
                                        color: textLightGrey(context)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      menuProvider: (menu) {
        bool isMyPost = controller.post.value?.userId ==
            SessionManager.instance.getUserID();
        bool isMyComment =
            comment?.userId == SessionManager.instance.getUserID();
        if (isMyPost) {
          return Menu(
            children: [
              if (comment?.reply == null)
                MenuAction(
                    title: comment?.isPinned == 1 ? LKey.unpin.tr : LKey.pin.tr,
                    callback: () {
                      if (comment?.isPinned == 1) {
                        controller.onUnPinComment(comment!);
                      } else {
                        controller.onPinnedComment(comment!);
                      }
                    }),
              MenuAction(
                title: LKey.delete.tr,
                callback: () => controller.onDeleteComment(comment!),
              ),
            ],
          );
        }
        if (!isMyPost && isMyComment) {
          return Menu(
            children: [
              MenuAction(
                title: LKey.delete.tr,
                callback: () => controller.onDeleteComment(comment!),
              )
            ],
          );
        }
        return null;
      },
    );
  }
}
