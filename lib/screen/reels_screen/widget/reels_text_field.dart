import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/screen/comment_sheet/helper/comment_helper.dart';
import 'package:shortzz/screen/reels_screen/reels_screen_controller.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ReelsTextField extends StatelessWidget {
  final ReelsScreenController controller;

  const ReelsTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.reelPageType == ReelPageType.home) {
      return const SizedBox();
    }
    return Obx(
      () {
        CommentHelper helper = controller.commentHelper;
        Post reel = controller.reels[controller.position.value];

        return AnimatedOpacity(
          opacity: reel.canComment == 1 ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: textDarkGrey(context))),
              child: DetectableTextField(
                  enabled: reel.canComment == 1,
                  controller: helper.detectableTextController,
                  focusNode: helper.detectableTextFocusNode,
                  style: TextStyleCustom.outFitRegular400(
                      color: bgLightGrey(context), fontSize: 16),
                  onChanged: helper.onChanged,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      suffixIconConstraints: const BoxConstraints(),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: InkWell(
                          onTap: () => helper.onCommentPost(
                              reel: reel,
                              commentType: CommentType.text,
                              onUpdateComment: controller.onUpdateComment),
                          child: Text(LKey.post.tr,
                              style: TextStyleCustom.unboundedMedium500(
                                  fontSize: 15, color: textLightGrey(context))),
                        ),
                      ),
                      hintText: '${LKey.writeHere.tr}..',
                      hintStyle: TextStyle(color: textLightGrey(context))),
                  cursorColor: bgLightGrey(context)),
            ),
          ),
        );
      },
    );
  }
}
