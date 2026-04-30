import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/model/chat/message_data.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ChatTextMessage extends StatelessWidget {
  final bool isMe;
  final MessageData message;

  const ChatTextMessage({super.key, required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      constraints: BoxConstraints(maxWidth: Get.width / 1.3),
      decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1),
              side: isMe
                  ? BorderSide.none
                  : BorderSide(color: bgGrey(context), strokeAlign: BorderSide.strokeAlignInside)),
          color: isMe ? null : bgLightGrey(context),
          gradient: isMe ? StyleRes.themeGradient : null),
      child: Text(
        message.textMessage ?? '',
        style: TextStyleCustom.outFitRegular400(
            color: isMe ? whitePure(context) : textDarkGrey(context), fontSize: 16),
      ),
    );
  }
}
