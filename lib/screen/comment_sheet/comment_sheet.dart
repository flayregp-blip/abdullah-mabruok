import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/comment/fetch_comment_model.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/screen/comment_sheet/comment_sheet_controller.dart';
import 'package:shortzz/screen/comment_sheet/helper/comment_helper.dart';
import 'package:shortzz/screen/comment_sheet/widget/comment_bottom_text_field_view.dart';
import 'package:shortzz/screen/comment_sheet/widget/comments_view.dart';
import 'package:shortzz/screen/comment_sheet/widget/hashtag_and_mention_view.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CommentSheet extends StatelessWidget {
  final Post? post;
  final Comment? comment;
  final Comment? replyComment;
  final bool isFromNotification;
  final bool isFromBottomSheet;

  const CommentSheet(
      {super.key,
      this.post,
      this.comment,
      this.replyComment,
      this.isFromNotification = false,
      this.isFromBottomSheet = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentSheetController(
        post.obs, comment, replyComment, isFromNotification, CommentHelper()));
    return Container(
      margin: isFromBottomSheet
          ? EdgeInsets.only(top: AppBar().preferredSize.height * 2.5)
          : null,
      decoration: ShapeDecoration(
          shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.vertical(
                  top: SmoothRadius(cornerRadius: 40, cornerSmoothing: 1))),
          color: scaffoldBackgroundColor(context)),
      child: Column(
        children: [
          if (isFromBottomSheet)
            Obx(() => BottomSheetTopView(
                title:
                    '${(controller.post.value?.comments ?? 0).toInt().numberFormat} ${LKey.comments.tr}',
                sideBtnVisibility: false)),
          Obx(() {
            Widget content = Stack(
              key: isFromBottomSheet ? null : controller.commentKey,
              children: [
                controller.getCommentsList.isEmpty && controller.isLoading.value
                    ? const LoaderWidget()
                    : controller.getCommentsList.isEmpty &&
                            !controller.isLoading.value
                        ? (!isFromBottomSheet
                            ? const SizedBox()
                            : NoDataView(
                                title: LKey.postCommentEmptyTitle.tr,
                                description:
                                    LKey.postCommentEmptyDescription.tr))
                        : CommentsView(controller: controller),
                HashTagAndMentionUserView(helper: controller.commentHelper),
              ],
            );
            return !isFromBottomSheet ? content : Expanded(child: content);
          }),
          if (isFromBottomSheet)
            CommentBottomTextFieldView(
                helper: controller.commentHelper,
                isFromBottomSheet: isFromBottomSheet),
        ],
      ),
    );
  }
}
