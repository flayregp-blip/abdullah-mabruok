import 'package:flutter/material.dart';
import 'package:shortzz/common/widget/highlight_wrapper.dart';
import 'package:shortzz/model/post_story/comment/fetch_comment_model.dart';
import 'package:shortzz/screen/comment_sheet/comment_sheet_controller.dart';
import 'package:shortzz/screen/comment_sheet/widget/comment_card.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ReplyCommentsView extends StatelessWidget {
  final List<Comment> replyComments;
  final CommentSheetController controller;

  const ReplyCommentsView(
      {super.key, required this.replyComments, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: replyComments.length,
      primary: false,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        Comment _comment = replyComments[index];
        bool isNotify = false;
        if (controller.isFromNotification == true &&
            controller.commentBlinkId == null) {
          isNotify = (controller.replyComment?.id == _comment.id);
          if (isNotify) {
            controller.commentBlinkId = controller.replyComment?.id;
          }
        }
        return HighlightWrapper(
          highlightColor: themeAccentSolid(context).withValues(alpha: 0.3),
          highlight: isNotify,
          child: CommentCard(
            comment: _comment,
            controller: controller,
            isLikeButtonVisible: false,
            isReplyVisible: false,
          ),
        );
      },
    );
  }
}
