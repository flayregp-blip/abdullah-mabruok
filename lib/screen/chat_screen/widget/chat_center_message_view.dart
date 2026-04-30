import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/context_menu_widget.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/widget/load_more_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/chat/message_data.dart';
import 'package:shortzz/screen/chat_screen/chat_screen_controller.dart';
import 'package:shortzz/screen/chat_screen/message_type_widget/chat_audio_message.dart';
import 'package:shortzz/screen/chat_screen/message_type_widget/chat_g_i_f_message.dart';
import 'package:shortzz/screen/chat_screen/message_type_widget/chat_gift_message.dart';
import 'package:shortzz/screen/chat_screen/message_type_widget/chat_media_message.dart';
import 'package:shortzz/screen/chat_screen/message_type_widget/chat_post_message.dart';
import 'package:shortzz/screen/chat_screen/message_type_widget/chat_story_reply_message.dart';
import 'package:shortzz/screen/chat_screen/message_type_widget/chat_text_message.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ChatMessageView extends StatelessWidget {
  final ChatScreenController controller;

  const ChatMessageView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Obx(
      () {
        return LoadMoreWidget(
          loadMore: controller.fetchMoreChatList,
          child: ListView.builder(
            itemCount: controller.chatList.length,
            reverse: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              MessageData message = controller.chatList[index];
              bool isMe = message.userId == SessionManager.instance.getUserID();
              print(isMe);
              return Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 7, bottom: 7),
                decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 15, cornerSmoothing: 1))),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    ContextMenuWidget(
                      menuProvider: (_) {
                        return Menu(
                          children: [
                            MenuAction(
                                title: LKey.deleteForYou.tr,
                                callback: () =>
                                    controller.onDeleteForYou(message)),
                            if (isMe)
                              MenuAction(
                                  title: LKey.unSend.tr,
                                  callback: () => controller.onUnSend(message)),
                          ],
                        );
                      },
                      child: Container(
                        decoration: ShapeDecoration(
                            color: scaffoldBackgroundColor(context),
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: 15, cornerSmoothing: 1),
                            )),
                        child: switch (message.messageType) {
                          MessageType.image => ChatMediaMessage(
                              isMe: isMe,
                              message: message,
                              controller: controller),
                          MessageType.video => ChatMediaMessage(
                              isMe: isMe,
                              message: message,
                              controller: controller),
                          MessageType.post => ChatPostMessage(
                              message: message, controller: controller),
                          MessageType.audio => ChatAudioMessage(
                              message: message, controller: controller),
                          MessageType.text =>
                            ChatTextMessage(isMe: isMe, message: message),
                          MessageType.gift =>
                            ChatGiftMessage(message: message, isMe: isMe),
                          MessageType.gif => ChatGIFMessage(message: message),
                          MessageType.storyReply => ChatStoryReplyMessage(
                              controller: controller,
                              message: message,
                              isMe: isMe),
                          null => const SizedBox(),
                        },
                      ),
                    ),
                    ChatDateView(message: message)
                  ],
                ),
              );
            },
          ),
        );
      },
    ));
  }
}

class ChatDateView extends StatelessWidget {
  final MessageData message;

  const ChatDateView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5, top: 3),
      child: Text(
        '${message.id ?? 0}'.chatTimeFormat,
        style: TextStyleCustom.outFitLight300(
            fontSize: 12, color: textLightGrey(context)),
      ),
    );
  }
}

final List<BoxShadow> messageBubbleShadow = [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.10),
    offset: const Offset(0, 4),
    blurRadius: 10,
  ),
];
