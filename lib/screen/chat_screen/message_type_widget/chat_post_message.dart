import 'dart:convert';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/chat/message_data.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/chat_screen/chat_screen_controller.dart';
import 'package:shortzz/screen/chat_screen/widget/chat_center_message_view.dart';
import 'package:shortzz/screen/post_screen/widget/post_view_center.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/font_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ChatPostMessage extends StatelessWidget {
  final MessageData message;
  final ChatScreenController controller;

  const ChatPostMessage(
      {super.key, required this.message, required this.controller});

  @override
  Widget build(BuildContext context) {
    Post post = Post.fromJson(jsonDecode(message.postMessage ?? ''));
    PostType type = post.postType;
    switch (type) {
      case PostType.reel:
        return ChatPostReelVideoMessage(post: post, controller: controller);
      case PostType.image:
        return ChatPostImageMessage(post: post, controller: controller);
      case PostType.video:
        return ChatPostImageMessage(post: post, controller: controller);
      case PostType.text:
        return ChatPostTextMessage(post: post, controller: controller);
      case PostType.none:
        return const SizedBox();
    }
  }
}

class ChatPostReelVideoMessage extends StatelessWidget {
  final Post post;
  final ChatScreenController controller;

  const ChatPostReelVideoMessage(
      {super.key, required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    double width = Get.width / 1.8;
    double height = 280;
    return Container(
      constraints: BoxConstraints(maxWidth: width),
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 1)),
        color: textDarkGrey(context),
        shadows: messageBubbleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatPostProfile(user: post.user),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: InkWell(
              onTap: () => controller.onPostTap(post),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomImage(
                      size: Size(width, height),
                      image: post.thumbnail?.addBaseURL(),
                      cornerSmoothing: 1,
                      radius: 12,
                      isShowPlaceHolder: true),
                  Image.asset(AssetRes.icChatPlay,
                      width: 54, height: 54, color: whitePure(context))
                ],
              ),
            ),
          ),
          Visibility(
            visible: post.description != null,
            child: ChatPostText(
                description: post.descriptionWithUserName, topPadding: 5),
          )
        ],
      ),
    );
  }
}

class ChatPostImageMessage extends StatelessWidget {
  final Post post;
  final ChatScreenController controller;

  const ChatPostImageMessage(
      {super.key, required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    double width = Get.width / 1.4;
    bool isVideo = post.postType == PostType.video;
    return InkWell(
      onTap: () => controller.onPostTap(post),
      child: Container(
        constraints: BoxConstraints(maxWidth: width),
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
              borderRadius:
                  SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 1)),
          color: textDarkGrey(context),
          shadows: messageBubbleShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatPostProfile(user: post.user),
            if (!isVideo)
              PostImageView(
                  post: post,
                  height: width,
                  margin: EdgeInsets.zero,
                  radius: 0),
            if (isVideo)
              PostVideoView(
                  post: post,
                  margin: EdgeInsets.zero,
                  radius: 0,
                  isFromChat: true),
            Visibility(
              replacement: const Padding(
                  padding: EdgeInsets.all(10.0), child: SizedBox(height: 0)),
              visible: post.description != null,
              child: ChatPostText(description: post.descriptionWithUserName),
            )
          ],
        ),
      ),
    );
  }
}

class ChatPostTextMessage extends StatelessWidget {
  final Post post;

  final ChatScreenController controller;

  const ChatPostTextMessage(
      {super.key, required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    double width = Get.width / 1.4;
    return InkWell(
      onTap: () => controller.onPostTap(post),
      child: Container(
        constraints: BoxConstraints(maxWidth: width),
        decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 1)),
            shadows: messageBubbleShadow,
            color: textDarkGrey(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChatPostProfile(user: post.user),
            ChatPostText(
                description: post.descriptionWithUserName, topPadding: 0),
          ],
        ),
      ),
    );
  }
}

class ChatPostProfile extends StatelessWidget {
  final User? user;

  const ChatPostProfile({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CustomImage(
            size: const Size(34, 34),
            image: user?.profilePhoto?.addBaseURL(),
            strokeWidth: 1.5,
            fullName: user?.fullname,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: FullNameWithBlueTick(
                username: user?.username ?? '',
                fontColor: whitePure(context),
                iconSize: 18,
                isVerify: user?.isVerify),
          )
        ],
      ),
    );
  }
}

class ChatPostText extends StatelessWidget {
  final String description;
  final double topPadding;

  const ChatPostText(
      {super.key, required this.description, this.topPadding = 10});

  @override
  Widget build(BuildContext context) {
    TextStyle collapsedStyle = TextStyleCustom.outFitLight300(
        fontSize: 15, color: whitePure(context), opacity: .8);

    return Padding(
      padding:
          EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: topPadding),
      child: ReadMoreText(
        description,
        trimMode: TrimMode.Line,
        trimLines: AppRes.trimLine,
        trimCollapsedText: LKey.more.tr,
        trimExpandedText: ' ${LKey.less.tr}',
        lessStyle: collapsedStyle,
        moreStyle: collapsedStyle,
        style: collapsedStyle,
        annotations: [
          Annotation(
              regExp: AppRes.hashTagRegex,
              spanBuilder: ({required String text, TextStyle? textStyle}) =>
                  TextSpan(
                    text: text,
                    style: textStyle?.copyWith(
                      color: themeAccentSolid(context),
                      fontFamily: FontRes.outFitMedium500,
                      fontSize: 15,
                    ),
                  )),
          Annotation(
            regExp: AppRes.userNameRegex,
            spanBuilder: ({required String text, TextStyle? textStyle}) {
              return TextSpan(
                text: text,
                style: textStyle?.copyWith(
                  color: blueFollow(context),
                  fontFamily: FontRes.outFitMedium500,
                  fontSize: 15,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
