import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/post_by_id.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/screen/comment_sheet/comment_sheet.dart';
import 'package:shortzz/screen/comment_sheet/comment_sheet_controller.dart';
import 'package:shortzz/screen/comment_sheet/helper/comment_helper.dart';
import 'package:shortzz/screen/comment_sheet/widget/comment_bottom_text_field_view.dart';
import 'package:shortzz/screen/post_screen/post_card.dart';
import 'package:shortzz/screen/post_screen/post_screen_controller.dart';

class SinglePostScreen extends StatefulWidget {
  final Post post;
  final PostByIdData? postByIdData;
  final bool isFromNotification;

  const SinglePostScreen({super.key, required this.post, this.postByIdData, this.isFromNotification = false});

  @override
  State<SinglePostScreen> createState() => _SinglePostScreenState();
}

class _SinglePostScreenState extends State<SinglePostScreen> {
  CommentHelper helper = CommentHelper();

  @override
  void dispose() {
    if (Get.isRegistered<PostScreenController>(tag: '${widget.post.id}')) {
      final controller = Get.find<PostScreenController>(tag: '${widget.post.id}');
      controller.isFromSinglePostScreen = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CommentSheetController(
        widget.post.obs, widget.postByIdData?.comment, widget.postByIdData?.reply, widget.isFromNotification, helper));
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: LKey.post.tr),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PostCard(
                      post: widget.post,
                      shouldShowPinOption: false,
                      likeKey: GlobalKey(),
                      postByIdData: widget.postByIdData,
                      isFromSinglePost: true),
                  CommentSheet(post: widget.post, isFromBottomSheet: false)
                ],
              ),
            ),
          ),
          if (widget.post.canComment == 1) CommentBottomTextFieldView(helper: helper, isFromBottomSheet: false),
        ],
      ),
    );
  }
}
