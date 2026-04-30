import 'dart:convert';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/chat/message_data.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/post_story/story/story_model.dart';
import 'package:shortzz/screen/chat_screen/chat_screen_controller.dart';
import 'package:shortzz/screen/chat_screen/message_type_widget/chat_text_message.dart';
import 'package:shortzz/screen/chat_screen/widget/chat_center_message_view.dart';
import 'package:shortzz/screen/notification_screen/widget/activity_notification_page.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ChatStoryReplyMessage extends StatelessWidget {
  final ChatScreenController controller;
  final MessageData message;
  final bool isMe;

  const ChatStoryReplyMessage(
      {super.key,
      required this.controller,
      required this.message,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    double width = Get.width / 2.3;
    Story story =
        Story.fromJsonWithUser(jsonDecode(message.storyReplyMessage ?? ''));
    bool isEmojiText = isSingleEmoji(message.textMessage ?? '');
    bool isStoryUnAvailable = story.id == null;
    print(story.toJson());
    return SizedBox(
      width: width,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200, maxWidth: width),
                  child: Row(
                    mainAxisAlignment:
                        !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
                    spacing: 5,
                    children: [
                      if (!isMe)
                        LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            width: 3,
                            height: isStoryUnAvailable
                                ? 30
                                : constraints.maxHeight - 15,
                            decoration: ShapeDecoration(
                                shape: SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius(
                                        cornerRadius: 30, cornerSmoothing: 1)),
                                color: disableGrey(context)),
                          );
                        }),
                      isStoryUnAvailable
                          ? Text(LKey.storyUnavailable.tr,
                              style: TextStyleCustom.outFitRegular400(
                                  fontSize: 16, color: textLightGrey(context)))
                          : InkWell(
                              onTap: () {
                                controller.onStoryTap(message, story);
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: width - 40, maxHeight: 200),
                                decoration: ShapeDecoration(
                                    shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius(
                                            cornerRadius: 15,
                                            cornerSmoothing: 1)),
                                    color: textDarkGrey(context),
                                    shadows: messageBubbleShadow),
                                child: Padding(
                                    padding: const EdgeInsets.all(3.5),
                                    child: CustomImage(
                                        size: Size(width, 200),
                                        image: (story.type == 0
                                                ? story.content
                                                : story.thumbnail)
                                            ?.addBaseURL(),
                                        cornerSmoothing: 1,
                                        radius: 12,
                                        isShowPlaceHolder: true)),
                              ),
                            ),
                      if (isMe)
                        LayoutBuilder(builder: (context, constraints) {
                          return Container(
                            width: 3,
                            height: isStoryUnAvailable
                                ? 30
                                : constraints.maxHeight - 10,
                            decoration: ShapeDecoration(
                              shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: 30, cornerSmoothing: 1)),
                              color: disableGrey(context),
                            ),
                          );
                        })
                    ],
                  ),
                ),
                if (!isEmojiText) const SizedBox(height: 2),
                if (!isEmojiText)
                  (message.textMessage ?? '').isEmpty
                      ? NotificationGiftIcon(
                          gift: (message.imageMessage ?? '').isEmpty
                              ? null
                              : Gift.fromJson(
                                  jsonDecode(message.imageMessage ?? '')),
                        )
                      : ChatTextMessage(isMe: true, message: message),
                if (isEmojiText && isStoryUnAvailable)
                  Text(
                    message.textMessage ?? '',
                    style: const TextStyle(fontSize: 50, color: Colors.black),
                  )
              ],
            ),
          ),
          if (isEmojiText && !isStoryUnAvailable)
            Positioned(
              bottom: 0,
              left: !isMe ? null : 10,
              right: !isMe ? 10 : null,
              child: Text(message.textMessage ?? '',
                  style: const TextStyle(fontSize: 50, color: Colors.black)),
            )
        ],
      ),
    );
  }
}

bool isSingleEmoji(String input) {
  // Check if the string has exactly one character
  if (input.runes.length != 1) {
    return false;
  }

  // Regular expression to match emojis
  final emojiRegex = RegExp(
      r'[\u{1F600}-\u{1F64F}' // Emoticons
      r'\u{1F300}-\u{1F5FF}' // Symbols & Pictographs
      r'\u{1F680}-\u{1F6FF}' // Transport & Map Symbols
      r'\u{1F700}-\u{1F77F}' // Alchemical Symbols
      r'\u{1F780}-\u{1F7FF}' // Geometric Shapes Extended
      r'\u{1F800}-\u{1F8FF}' // Supplemental Arrows-C
      r'\u{1F900}-\u{1F9FF}' // Supplemental Symbols and Pictographs
      r'\u{1FA00}-\u{1FA6F}' // Chess Symbols
      r'\u{1FA70}-\u{1FAFF}' // Symbols and Pictographs Extended-A
      r'\u{2600}-\u{26FF}' // Miscellaneous Symbols
      r'\u{2700}-\u{27BF}' // Dingbats
      r'\u{1F1E6}-\u{1F1FF}' // Regional Indicator Symbols
      r'\u{1F900}-\u{1F9FF}]', // Supplemental Symbols and Pictographs
      unicode: true);

  // Test the single character against the emoji regex
  return emojiRegex.hasMatch(input);
}
