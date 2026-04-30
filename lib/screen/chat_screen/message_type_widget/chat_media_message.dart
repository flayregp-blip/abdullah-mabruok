import 'package:dismissible_page/dismissible_page.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/model/chat/message_data.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/chat_screen/chat_screen_controller.dart';
import 'package:shortzz/screen/chat_screen/widget/chat_center_message_view.dart';
import 'package:shortzz/screen/image_view_screen/image_view_screen.dart';
import 'package:shortzz/screen/video_player_screen/video_player_screen.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ChatMediaMessage extends StatelessWidget {
  final bool isMe;
  final MessageData message;
  final ChatScreenController controller;

  const ChatMediaMessage({super.key, required this.isMe, required this.message, required this.controller});

  @override
  Widget build(BuildContext context) {
    double width = Get.width / 1.6;
    const double height = 290;
    bool isVideo = message.messageType == MessageType.video;
    return Container(
      constraints: BoxConstraints(maxWidth: width),
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 1)),
        color: isMe ? null : bgLightGrey(context),
        gradient: isMe ? StyleRes.themeGradient : null,
        shadows: messageBubbleShadow,
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (isVideo) {
                Get.to(() => VideoPlayerScreen(
                    post: Post(
                        thumbnail: message.imageMessage,
                        video: message.videoMessage,
                        description: message.textMessage,
                        user: User(
                          profilePhoto: message.chatUser?.profile,
                          id: message.chatUser?.userId,
                          username: message.chatUser?.username,
                          fullname: message.chatUser?.fullname,
                          isVerify: message.chatUser?.isVerify,
                        ))));
              } else {
                context.pushTransparentRoute(ImageViewScreen(images: [
                  Images(image: message.imageMessage ?? ''),
                ], tag: 'chat'));
              }
            },
            child: SizedBox(
              width: width,
              // height: height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Hero(
                    tag: 'chat_${message.imageMessage}',
                    child: CustomImage(
                      size: Size(width, height),
                      radius: 13,
                      cornerSmoothing: 1,
                      image: message.imageMessage?.addBaseURL(),
                      isShowPlaceHolder: true,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  if (isVideo)
                    Container(
                      height: 45,
                      width: 45,
                      decoration:
                          BoxDecoration(color: blackPure(context).withValues(alpha: .5), shape: BoxShape.circle),
                      alignment: const Alignment(.1, 0),
                      child: Image.asset(AssetRes.icPlay, width: 30, height: 30),
                    )
                ],
              ),
            ),
          ),
          if ((message.textMessage ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 6, top: 5, bottom: 5),
              child: Text(
                message.textMessage ?? '',
                style: TextStyleCustom.outFitRegular400(
                    color: isMe ? whitePure(context) : textDarkGrey(context), fontSize: 16),
              ),
            )
        ],
      ),
    );
  }
}
