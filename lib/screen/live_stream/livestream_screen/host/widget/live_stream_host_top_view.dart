import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/manager/haptic_manager.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/livestream/livestream.dart';
import 'package:shortzz/model/livestream/livestream_user_state.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/livestream_screen_controller.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/widget/members_sheet.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LiveStreamHostTopView extends StatelessWidget {
  final LivestreamScreenController controller;

  const LiveStreamHostTopView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: SafeArea(
        bottom: false,
        minimum: EdgeInsets.only(top: AppBar().preferredSize.height * 0.7),
        child: Obx(
          () {
            Livestream stream = controller.liveData.value;
            LivestreamUserState? userState = controller.liveUsersStates
                .firstWhereOrNull((element) => element.userId == stream.hostId);
            bool isVisibleBattleBtn =
                stream.battleType == BattleType.initiate &&
                    controller.streamViews.length == 2 &&
                    controller.setting?.liveBattle == 1;
            int count = stream.watchingCount ?? 0;
            int watchingCount = count >= 0 ? count : 0;
            bool isVisible = controller.isViewVisible.value;
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: isVisible ? 1 : 0,
              child: IgnorePointer(
                ignoring: !isVisible,
                child: Container(
                  height: 30,
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      spacing: 3,
                      children: [
                        LiveStreamBorderButton(
                          onTap: controller.onStopButtonTap,
                          backgroundColor: ColorRes.likeRed,
                          title: LKey.stop.tr,
                          shadow: livestreamShadow,
                        ),
                        LiveStreamBorderButton(
                            title: watchingCount.numberFormat,
                            imageIcon: AssetRes.icEye_2,
                            imageColor: whitePure(context)),
                        LiveStreamBorderButton(
                            title: (userState?.totalCoin ?? 0).numberFormat,
                            imageIcon: AssetRes.icCoin),
                        LiveStreamCircleBorderButton(
                            image: AssetRes.icAudience,
                            margin: const EdgeInsets.all(0),
                            size: const Size(30, 30),
                            iconSize: 18,
                            iconColor: whitePure(context),
                            onTap: () {
                              Get.bottomSheet(const MembersSheet(isHost: true),
                                  isScrollControlled: true);
                            },
                          ),
                        if (isVisibleBattleBtn)
                          Expanded(
                            child: InkWell(
                              onTap: controller.startBattle,
                              child: Container(
                                height: 30,
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                    shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius(
                                            cornerRadius: 30),
                                        side: BorderSide(
                                            color: whitePure(context)
                                                .withValues(alpha: .3))),
                                    color: whitePure(context),
                                    shadows: livestreamShadow),
                                child: Text(
                                  LKey.startBattle.tr,
                                  style: TextStyleCustom.unboundedRegular400(
                                      fontSize: 10,
                                      color: themeAccentSolid(context)),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StopLiveStreamSheet extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final String? description;
  final String? positiveText;

  const StopLiveStreamSheet(
      {super.key,
      required this.onTap,
      this.title,
      this.description,
      this.positiveText});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: double.infinity,
          decoration: ShapeDecoration(
              color: whitePure(context),
              shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.vertical(
                      top:
                          SmoothRadius(cornerRadius: 40, cornerSmoothing: 1)))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: .5,
                  color: textLightGrey(context),
                  width: 100,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                title ?? LKey.endStreamTitle.tr,
                style: TextStyleCustom.unboundedRegular400(
                    fontSize: 15, color: textDarkGrey(context)),
              ),
              Text(
                description ?? LKey.endStreamMessage.tr,
                style: TextStyleCustom.outFitLight300(
                    fontSize: 17, color: textLightGrey(context)),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextButtonCustom(
                        onTap: Get.back,
                        title: LKey.cancel.tr,
                        backgroundColor: bgMediumGrey(context)),
                  ),
                  Expanded(
                      child: TextButtonCustom(
                          onTap: () {
                            Get.back();
                            onTap();
                          },
                          title: positiveText ?? LKey.yes.tr,
                          backgroundColor: themeAccentSolid(context),
                          titleColor: whitePure(context),
                          horizontalMargin: 5)),
                ],
              ),
              SizedBox(height: AppBar().preferredSize.height),
            ],
          ),
        )
      ],
    );
  }
}

class LiveStreamBorderButton extends StatelessWidget {
  final Color? backgroundColor;
  final String title;
  final String imageIcon;
  final Color? imageColor;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadow;

  const LiveStreamBorderButton(
      {super.key,
      this.backgroundColor,
      required this.title,
      this.imageIcon = '',
      this.imageColor,
      this.onTap,
      this.shadow});

  @override
  Widget build(BuildContext context) {
    double width = Get.width / 5.5;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        width: width,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 30),
            side: BorderSide(
              color: whitePure(context).withValues(alpha: .3),
            ),
          ),
          shadows: shadow,
          color: backgroundColor ?? blackPure(context).withValues(alpha: .1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 3,
          children: [
            if (imageIcon.isNotEmpty)
              Image.asset(imageIcon, height: 16, width: 16, color: imageColor),
            Text(title,
                style: TextStyleCustom.outFitRegular400(
                    color: whitePure(context))),
          ],
        ),
      ),
    );
  }
}

class LiveStreamCircleBorderButton extends StatelessWidget {
  final String image;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Size? size;
  final Color? iconColor;
  final Color? borderColor;
  final Color? bgColor;
  final double? iconSize;

  const LiveStreamCircleBorderButton({
    super.key,
    required this.image,
    this.margin,
    this.onTap,
    this.size,
    this.iconColor,
    this.borderColor,
    this.iconSize,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticManager.shared.light();
        onTap?.call();
      },
      child: Container(
        height: size?.height ?? 32,
        width: size?.width ?? 32,
        margin: margin,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 30),
              side: BorderSide(
                color: borderColor ?? whitePure(context).withValues(alpha: .3),
              )),
          color: (bgColor ?? blackPure(context)).withValues(alpha: .1),
        ),
        child: Image.asset(
          image,
          height: iconSize ?? 20,
          width: iconSize ?? 20,
          color: iconColor ?? whitePure(context).withValues(alpha: .3),
        ),
      ),
    );
  }
}

final livestreamShadow = [
  BoxShadow(
    color: Colors.black.withValues(alpha: .15),
    offset: const Offset(0, 2),
    blurRadius: 5,
  ),
];
