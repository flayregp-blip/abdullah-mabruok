import 'package:flutter/material.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/model/chat/message_data.dart';

class ChatGIFMessage extends StatelessWidget {
  final MessageData message;
  const ChatGIFMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return CustomImage(
        size: const Size(118, 118),
        image: message.imageMessage,
        radius: 15,
        cornerSmoothing: 1,
        fit: BoxFit.contain,
        isShowPlaceHolder: true);
  }
}
