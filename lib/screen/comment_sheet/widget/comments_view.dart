import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/highlight_wrapper.dart';
import 'package:shortzz/common/widget/load_more_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/comment/fetch_comment_model.dart';
import 'package:shortzz/screen/comment_sheet/comment_sheet_controller.dart';
import 'package:shortzz/screen/comment_sheet/widget/comment_card.dart';
import 'package:shortzz/screen/comment_sheet/widget/reply_comments.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CommentsView extends StatelessWidget {
  final CommentSheetController controller;

  const CommentsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.commentHelper.detectableTextFocusNode.unfocus();
        },
        child: LoadMoreWidget(
          loadMore: controller.fetchComments,
          child: ListView.builder(
            itemCount: controller.getCommentsList.length,
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 5),
            itemBuilder: (context, index) {
              Comment comment = controller.getCommentsList[index];
              bool isNotify = false;
              if (controller.isFromNotification == true &&
                  controller.replyComment == null &&
                  controller.commentBlinkId == null) {
                isNotify = (controller.comment?.id == comment.id);
                if (isNotify) {
                  controller.commentBlinkId = controller.comment?.id;
                }
              }
              return HighlightWrapper(
                highlight: isNotify,
                highlightColor:
                    themeAccentSolid(context).withValues(alpha: 0.3),
                child: CommentItems(controller: controller, comment: comment),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CommentItems extends StatelessWidget {
  final Comment comment;
  final CommentSheetController controller;

  const CommentItems(
      {super.key, required this.comment, required this.controller});

  @override
  Widget build(BuildContext context) {
    int commentId = comment.id?.toInt() ?? -1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentCard(
            controller: controller,
            comment: comment,
            isLikeButtonVisible: true,
            isReplyVisible: true),
        ReplyCommentSectionWidget(
          commentId: commentId,
          comment: comment,
          controller: controller,
        ),
      ],
    );
  }
}

class ReplyCommentSectionWidget extends StatelessWidget {
  final int commentId;
  final Comment comment;
  final CommentSheetController
      controller; // Replace with actual controller type

  const ReplyCommentSectionWidget(
      {super.key,
      required this.commentId,
      required this.comment,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Comment> replyComments =
          controller.getReplyCommentsList[commentId] ?? [];
      if ((comment.repliesCount ?? 0) <= 0) {
        return const SizedBox();
      }
      var count = (comment.repliesCount ?? 0) - replyComments.length;
      return Row(
        children: [
          const SizedBox(width: 45),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReplyCommentsView(
                    replyComments: replyComments, controller: controller),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: controller.isFetchReplyComment.value &&
                          comment.id == controller.replyCommentId.value
                      ? const CupertinoActivityIndicator(radius: 10)
                      : InkWell(
                          onTap: () {
                            if (count <= 0) {
                              controller.hideReplyComment(comment);
                            } else {
                              controller.fetchReplyComment(comment);
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                  height: 1,
                                  width: 30,
                                  color: textLightGrey(context)),
                              const SizedBox(width: 5),
                              Text(
                                (count) <= 0
                                    ? '${LKey.hide.tr} ${LKey.replies.tr}'
                                    : '${LKey.view.tr} $count ${LKey.replies.tr}',
                                style: TextStyleCustom.outFitRegular400(
                                  fontSize: 13,
                                  color: textLightGrey(context),
                                ),
                              )
                              // Text(
                              //   (comment.repliesCount ?? 0) <= 0
                              //       ? '${LKey.hide.tr} ${LKey.replies.tr}'
                              //       : '${LKey.view.tr} ${comment.repliesCount ?? 0} ${LKey.replies.tr}',
                              //   style: TextStyleCustom.outFitRegular400(
                              //     fontSize: 13,
                              //     color: textLightGrey(context),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
