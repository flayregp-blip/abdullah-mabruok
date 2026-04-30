import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/livestream/livestream.dart';
import 'package:shortzz/screen/gift_sheet/send_gift_sheet.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/livestream_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LiveStreamTextFieldView extends StatelessWidget {
  final bool isAudience;
  final LivestreamScreenController controller;

  const LiveStreamTextFieldView(
      {super.key, required this.isAudience, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Livestream stream = controller.liveData.value;
      bool isTextEmpty = controller.isTextEmpty.value;
      bool isBattleON = stream.type == LivestreamType.battle;
      bool isGiftIconVisible = controller.streamViews.firstWhereOrNull(
              (view) => view.streamId == controller.myUserId.toString()) ==
          null;

      List<AppUser> users =
          stream.getAllUsers(controller.firestoreController.users);

      return Container(
        height: 43,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 30, cornerSmoothing: 1),
                side: BorderSide(
                    color: whitePure(context).withValues(alpha: .18))),
            color: whitePure(context).withValues(alpha: .15)),
        child: TextField(
          controller: controller.textCommentController,
          onChanged: (value) {
            controller.isTextEmpty.value = value.isEmpty ? true : false;
          },
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            isCollapsed: true,
            hintText:
                isAudience ? '${LKey.writeHere.tr}..' : LKey.whatDoYouThink.tr,
            hintStyle: TextStyleCustom.outFitLight300(
                color: whitePure(context), fontSize: 17, opacity: .42),
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: TextFieldSuffixIcon(
              controller: controller,
              isBattleOn: isBattleON,
              isAudience: isAudience,
              isTextEmpty: isTextEmpty,
              isGiftIconVisible: isGiftIconVisible,
              users: users,
            ),
          ),
          style: TextStyleCustom.outFitRegular400(
              color: whitePure(context), fontSize: 17),
          cursorColor: whitePure(context).withValues(alpha: .6),
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
        ),
      );
    });
  }
}

class TextFieldSuffixIcon extends StatelessWidget {
  final bool isTextEmpty;
  final bool isAudience;
  final bool isBattleOn;
  final bool isGiftIconVisible;
  final List<AppUser> users;
  final LivestreamScreenController controller;

  const TextFieldSuffixIcon({
    super.key,
    required this.isTextEmpty,
    required this.isAudience,
    required this.isBattleOn,
    required this.controller,
    required this.isGiftIconVisible,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    final bool showGiftIconsForBattle = isTextEmpty &&
        isAudience &&
        isBattleOn &&
        isGiftIconVisible &&
        users.length == 2;

    final bool showSendButton = !isBattleOn || !isGiftIconVisible;

    return AnimatedContainer(
      width: isTextEmpty && isAudience ? 100 : 80,
      alignment: AlignmentDirectional.centerEnd,
      duration: const Duration(milliseconds: 100),
      child: !isTextEmpty
          ? _sendButton(context)
          : showGiftIconsForBattle
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GiftIcon(
                      bgColor: ColorRes.likeRed,
                      onTap: () => controller.onGiftTap(
                        GiftType.battle,
                        battleViewType: BattleView.red,
                        users: [users.first],
                      ),
                    ),
                    GiftIcon(
                      bgColor: ColorRes.battleProgressColor,
                      onTap: () => controller.onGiftTap(
                        GiftType.battle,
                        battleViewType: BattleView.blue,
                        users: [users.last],
                      ),
                    ),
                  ],
                )
              : showSendButton && isTextEmpty && !isAudience
                  ? _sendButton(context)
                  : isBattleOn && isAudience
                      ? _sendButton(context)
                      : !isTextEmpty
                          ? _sendButton(context)
                          : GiftIcon(
                              onTap: () => controller
                                  .onGiftTap(GiftType.livestream, users: users),
                            ),
    );
  }

  Widget _sendButton(BuildContext context) {
    return InkWell(
      onTap: controller.onTextCommentSend,
      child: Container(
        height: 37,
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          LKey.send.tr,
          style: TextStyleCustom.unboundedMedium500(
            color: whitePure(context),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class GiftIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? bgColor;

  const GiftIcon({super.key, this.onTap, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 37,
        width: 37,
        margin: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 3),
        decoration: BoxDecoration(
          gradient: bgColor == null ? StyleRes.themeGradient : null,
          color: bgColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Image.asset(AssetRes.icGift,
            height: 20, width: 20, color: whitePure(context)),
      ),
    );
  }
}
