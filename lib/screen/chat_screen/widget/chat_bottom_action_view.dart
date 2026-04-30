import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/enum/chat_enum.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/common/widget/gradient_text.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/chat/chat_thread.dart';
import 'package:shortzz/screen/chat_screen/chat_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ChatBottomActionView extends StatelessWidget {
  final ChatScreenController controller;

  const ChatBottomActionView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          const CustomDivider(),
          const SizedBox(height: 10),
          Obx(() {
            ChatThread conversationUser = controller.conversationUser.value;
            bool iBlocked = conversationUser.iBlocked ?? false;
            bool iAmBlocked = conversationUser.iAmBlocked ?? false;

            if (iBlocked) {
              return ChatUnBlockedView(
                conversationUser: conversationUser,
                onTapUnblock: controller.toggleBlockUnblock,
              );
            } else if (iAmBlocked) {
              return const ChatIBlockedView();
            } else {
              print("123456 ${conversationUser.chatType}");
              if (conversationUser.chatType == ChatType.request) {
                return ChatBottomRequestView(
                    controller: controller, conversation: conversationUser);
              }
              return Stack(alignment: Alignment.center, children: [
                ChatTextField(
                    controller: controller.textController,
                    isTextEmpty: controller.isTextEmpty,
                    onChange: controller.onTextFieldChanged,
                    onCameraTap: controller.onCameraTap,
                    onChatActionTap: controller.onChatActionTap,
                    onSendTextMessage: controller.onSendTextMessage,
                    actions: ChatAction.getChatActions(
                        isGiphyEnabled: controller.setting?.gifSupport == 1)),
                AudioWavesContainer(controller: controller)
              ]);
            }
          }),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onChange;
  final VoidCallback? onCameraTap;
  final VoidCallback? onSendTextMessage;
  final Function(ChatAction value)? onChatActionTap;
  final RxBool isTextEmpty;
  final Color? borderColor;
  final List<ChatAction> actions;

  const ChatTextField(
      {super.key,
      required this.controller,
      this.onChange,
      this.onCameraTap,
      required this.isTextEmpty,
      this.onSendTextMessage,
      this.onChatActionTap,
      this.borderColor,
      this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 30),
            side: BorderSide(color: borderColor ?? bgGrey(context))),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Obx(() {
        bool hasNoText = isTextEmpty.value;
        return TextField(
          controller: controller,
          onChanged: onChange,
          textAlignVertical: TextAlignVertical.center,
          minLines: 1,
          maxLines: 3,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            border: InputBorder.none,
            hintText: '${LKey.writeHere.tr}..',
            hintStyle:
                TextStyleCustom.outFitLight300(color: textLightGrey(context)),
            prefixIconConstraints: const BoxConstraints(),
            prefixIcon: InkWell(
              onTap: onCameraTap,
              child: AnimatedContainer(
                height: 40,
                width: !hasNoText ? 0 : 40,
                duration: const Duration(milliseconds: 100),
                margin: EdgeInsets.only(
                    left: TextDirection.rtl == Directionality.of(context)
                        ? 10
                        : 2,
                    right: TextDirection.ltr == Directionality.of(context)
                        ? 10
                        : 2,
                    top: 2,
                    bottom: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeAccentSolid(context).withValues(alpha: .1),
                ),
                alignment: Alignment.center,
                child: Image.asset(AssetRes.icCamera,
                    height: 25, width: 25, color: themeAccentSolid(context)),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: AnimatedContainer(
              width: hasNoText ? 140 : 80,
              alignment: AlignmentDirectional.centerEnd,
              duration: const Duration(milliseconds: 100),
              child: hasNoText
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                          actions.length,
                          (index) {
                            return InkWell(
                              onTap: () => onChatActionTap?.call(actions[index]),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: Image.asset(actions[index].image,
                                    width: 25,
                                    height: 25),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: onSendTextMessage,
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GradientText(
                            LKey.send.tr,
                            gradient: StyleRes.themeGradient,
                            style: TextStyleCustom.unboundedMedium500(
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          style: TextStyleCustom.outFitRegular400(
              color: textLightGrey(context), fontSize: 16),
        );
      }),
    );
  }
}

class ChatBottomRequestView extends StatelessWidget {
  final ChatScreenController controller;
  final ChatThread conversation;

  const ChatBottomRequestView({
    super.key,
    required this.controller,
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Text(
              LKey.chatRequestMessage.trParams(
                  {'chat_user_name': '${conversation.chatUser?.username}'}),
              style: TextStyleCustom.outFitLight300(
                  fontSize: 15, color: textLightGrey(context))),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              controller.requestType.length,
              (index) {
                UserRequestAction requestType = controller.requestType[index];
                return Expanded(
                  child: InkWell(
                    onTap: () =>
                        controller.onChatRequestTap(requestType, conversation),
                    child: Container(
                      height: 37,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: ShapeDecoration(
                          color: requestType.color(context),
                          shape: SmoothRectangleBorder(
                              borderRadius:
                                  SmoothBorderRadius(cornerRadius: 30))),
                      alignment: Alignment.center,
                      child: Text(
                        requestType.title.tr.capitalize ?? '',
                        style: TextStyleCustom.outFitRegular400(
                            color: requestType.titleColor(context)),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class AudioWavesContainer extends StatelessWidget {
  final ChatScreenController controller;

  const AudioWavesContainer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.audioWidthAnimation == null) {
      return const SizedBox();
    }
    return AnimatedBuilder(
      animation: controller.audioWidthAnimation!,
      builder: (context, child) {
        return Align(
          alignment: Alignment.centerLeft,
          child: ClipRect(
            // Prevents overflow by clipping excess
            child: Container(
              width: controller.audioWidthAnimation!.value,
              height: 46,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: ShapeDecoration(
                color: bgLightGrey(context),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(cornerRadius: 30),
                ),
              ),
              child: controller.audioWidthAnimation!.value >
                      120 // Hide Row when width is too small
                  ? Row(
                      children: [
                        // Left icon
                        InkWell(
                          onTap: controller.deleteRecordedAudio,
                          child: AnimatedContainer(
                            height: 45,
                            width: 45,
                            duration: const Duration(milliseconds: 100),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 1, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorRes.likeRed.withValues(alpha: .1)),
                            alignment: Alignment.center,
                            child: Image.asset(AssetRes.icDelete,
                                height: 25, width: 25, color: ColorRes.likeRed),
                          ),
                        ),
                        // Middle expanding waveform
                        Expanded(
                          child: AudioWaveforms(
                            size: Size(MediaQuery.of(context).size.width, 35),
                            recorderController: controller.recorderController,
                            waveStyle: WaveStyle(
                                middleLineColor: Colors.transparent,
                                extendWaveform: true,
                                waveThickness: 1.5,
                                spacing: 3,
                                waveColor: bgGrey(context),
                                gradient: StyleRes.wavesGradient),
                          ),
                        ),
                        // Right send button
                        InkWell(
                          onTap: controller.sendRecordedAudio,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GradientText(
                              LKey.send.tr,
                              gradient: StyleRes.themeGradient,
                              style: TextStyleCustom.unboundedMedium500(
                                  fontSize: 15),
                            ),
                          ),
                        )
                      ],
                    )
                  : null, // Hide Row when width is 0
            ),
          ),
        );
      },
    );
  }
}

class ChatUnBlockedView extends StatelessWidget {
  final ChatThread conversationUser;
  final Function(ChatThread conversationUser) onTapUnblock;

  const ChatUnBlockedView(
      {super.key, required this.conversationUser, required this.onTapUnblock});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          spacing: 5,
          children: [
            Text(
                LKey.youBlockedUser.trParams({
                  'block_user_name': '${conversationUser.chatUser?.username}'
                }),
                style: TextStyleCustom.outFitLight300(
                    fontSize: 15, color: textLightGrey(context)),
                textAlign: TextAlign.center),
            InkWell(
              onTap: () => onTapUnblock(conversationUser),
              child: Container(
                height: 37,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: ShapeDecoration(
                    color: bgGrey(context),
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(cornerRadius: 30))),
                alignment: Alignment.center,
                child: Text(
                  LKey.unBlock.tr.capitalize ?? '',
                  style: TextStyleCustom.outFitRegular400(
                      color: textDarkGrey(context)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatIBlockedView extends StatelessWidget {
  const ChatIBlockedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(LKey.youAreBlockedByThisUser.tr,
        style: TextStyleCustom.outFitLight300(
            fontSize: 15, color: textLightGrey(context)),
        textAlign: TextAlign.center);
  }
}
