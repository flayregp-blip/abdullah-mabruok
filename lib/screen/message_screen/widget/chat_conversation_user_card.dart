import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/model/chat/chat_thread.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/chat_screen/chat_screen.dart';
import 'package:shortzz/screen/message_screen/message_screen_controller.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ChatConversationUserCard extends StatelessWidget {
  final ChatThread chatConversation;

  const ChatConversationUserCard({super.key, required this.chatConversation});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessageScreenController>();

    return InkWell(
      onTap: () {
        Get.to(
          () => ChatScreen(conversationUser: chatConversation, user: User(id: chatConversation.userId)),
        );
      },
      onLongPress: () => controller.onLongPress(chatConversation),
      child: Obx(() {
        AppUser? user = chatConversation.chatUserRx.value;
        return Container(
          color: bgLightGrey(context),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              CustomImage(size: const Size(47, 47), image: user?.profile?.addBaseURL(), fullName: user?.fullname),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    FullNameWithBlueTick(
                      username: user?.username,
                      fontSize: 13,
                      iconSize: 18,
                      isVerify: user?.isVerify,
                    ),
                    Text(chatConversation.lastMsg ?? '',
                        style: TextStyleCustom.outFitLight300(fontSize: 15, color: textLightGrey(context)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)
                  ],
                ),
              ),
              Column(
                spacing: 4,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateTime.fromMillisecondsSinceEpoch(int.parse(chatConversation.id ?? '0')).toString().timeAgo,
                      style: TextStyleCustom.outFitLight300(fontSize: 13, color: textLightGrey(context))),
                  Visibility(
                    visible: (chatConversation.msgCount ?? 0) > 0,
                    replacement: const SizedBox(height: 23),
                    child: Container(
                      width: 23,
                      height: 23,
                      decoration: BoxDecoration(color: themeAccentSolid(context), shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(
                        '${chatConversation.msgCount ?? 0}',
                        style: TextStyleCustom.outFitRegular400(fontSize: 12, color: whitePure(context)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
