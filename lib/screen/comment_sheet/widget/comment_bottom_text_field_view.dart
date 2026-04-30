import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/comment_sheet/comment_sheet_controller.dart';
import 'package:shortzz/screen/comment_sheet/helper/comment_helper.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CommentBottomTextFieldView extends StatelessWidget {
  final CommentHelper helper;
  final bool isFromBottomSheet;

  const CommentBottomTextFieldView(
      {super.key, required this.helper, required this.isFromBottomSheet});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommentSheetController>();
    return Container(
      color: whitePure(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomDivider(),
          SafeArea(
            top: false,
            maintainBottomViewPadding: true,
            minimum: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: Row(
                spacing: 10,
                children: [
                  Obx(() {
                    User? user = controller.myUser.value;
                    return CustomImage(
                        size: const Size(46, 46),
                        image: user?.profilePhoto?.addBaseURL(),
                        fullName: user?.fullname);
                  }),
                  Expanded(
                    child: Obx(
                      () {
                        return Container(
                          decoration: ShapeDecoration(
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius:
                                      helper.isReplyUser.value ? 20 : 30),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (helper.isReplyUser.value)
                                ReplyingToUserText(helper: helper),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: !helper.isReplyUser.value
                                        ? BorderRadius.circular(30)
                                        : const BorderRadius.vertical(
                                            bottom: Radius.circular(19)),
                                    border: Border(
                                      top: !helper.isReplyUser.value
                                          ? BorderSide(color: bgGrey(context))
                                          : BorderSide.none,
                                      bottom:
                                          BorderSide(color: bgGrey(context)),
                                      left: BorderSide(color: bgGrey(context)),
                                      right: BorderSide(color: bgGrey(context)),
                                    )),
                                child: DetectableTextField(
                                  onTap: () async {
                                    if (!isFromBottomSheet) {
                                      await Future.delayed(
                                          const Duration(milliseconds: 350));
                                      Scrollable.ensureVisible(
                                          controller.commentKey.currentContext!,
                                          duration: const Duration(
                                              milliseconds: 500));
                                    }
                                  },
                                  controller: helper.detectableTextController,
                                  focusNode: helper.detectableTextFocusNode,
                                  style: TextStyleCustom.outFitRegular400(
                                      color: textDarkGrey(context),
                                      fontSize: 16),
                                  onChanged: helper.onChanged,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    suffixIconConstraints:
                                        const BoxConstraints(),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Obx(() {
                                        bool isTextComment =
                                            helper.isTextComment.value;
                                        return InkWell(
                                          onTap: controller.onSendComment,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 250),
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            width: isTextComment ? 55 : 40,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Text(
                                                    isTextComment
                                                        ? LKey.post.tr
                                                        : LKey.gif.tr,
                                                    style: TextStyleCustom
                                                        .unboundedMedium500(
                                                      fontSize: 15,
                                                      color: themeAccentSolid(
                                                          context),
                                                    ),
                                                    textAlign: isTextComment
                                                        ? TextAlign.start
                                                        : TextAlign.end),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    hintText: '${LKey.writeHere.tr}..',
                                    hintStyle: TextStyle(
                                        color: textLightGrey(context)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ReplyingToUserText extends StatelessWidget {
  const ReplyingToUserText({required this.helper, super.key});

  final CommentHelper helper;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: bgMediumGrey(context),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(19)),
              border: Border.all(color: bgGrey(context))),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                    '${LKey.replyingTo.tr} @${helper.replyComment.value?.user?.username}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: textLightGrey(context))),
              ),
              InkWell(
                  onTap: helper.onCloseReply,
                  child: Icon(Icons.close_rounded,
                      color: textLightGrey(context), size: 20)),
            ],
          ),
        ),
      ],
    );
  }
}
