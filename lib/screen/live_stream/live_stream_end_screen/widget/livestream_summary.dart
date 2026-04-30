import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/common/widget/gradient_text.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/livestream/livestream_user_state.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/widget/live_stream_background_blur_image.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LiveStreamSummary extends StatelessWidget {
  final LivestreamUserState? userState;
  final int viewers;
  final bool isHost;
  final VoidCallback? onGoHomeTap;

  const LiveStreamSummary(
      {super.key,
      this.userState,
      required this.isHost,
      required this.viewers,
      this.onGoHomeTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const LiveStreamBlurBackgroundImage(),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CustomImage(
                      size: const Size(137, 137),
                      image: userState?.user?.profile?.addBaseURL(),
                      fullName: userState?.user?.fullname,
                      strokeColor: whitePure(context),
                      strokeWidth: 6),
                  const SizedBox(height: 11),
                  FullNameWithBlueTick(
                    username: userState?.user?.username,
                    fontSize: 14,
                    fontColor: whitePure(context),
                    isVerify: userState?.user?.isVerify,
                    iconSize: 18,
                  ),
                  Text(userState?.user?.fullname ?? '',
                      style: TextStyleCustom.outFitRegular400(
                          fontSize: 16, color: textLightGrey(context))),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 5),
                    child: Text(
                      isHost ? LKey.streamEnded.tr : LKey.yourStreamEnded.tr,
                      style: TextStyleCustom.unboundedRegular400(
                          fontSize: 20, color: whitePure(context)),
                    ),
                  ),
                  Text(
                    LKey.belowIsTheSummaryOfYourStream.tr,
                    style: TextStyleCustom.outFitThin100(
                        fontSize: 17, color: textLightGrey(context)),
                  ),
                ],
              ),
              Column(
                children: [
                  BuildTextAndValueTiles(
                    title: LKey.streamedFor.tr,
                    value: (userState?.joinStreamTime ??
                            DateTime.now().millisecondsSinceEpoch)
                        .elapsedTimeFromEpoch,
                  ),
                  BuildTextAndValueTiles(
                      title: LKey.viewers.tr,
                      value: '${(viewers - 1).clamp(0, viewers)}'),
                  BuildTextAndValueTiles(
                    title: LKey.followersGained.tr,
                    value: '${userState?.followersGained.length ?? 0}',
                  ),
                  BuildTextAndValueTiles(
                    title: LKey.totalCoinsCollected.tr,
                    value: userState?.totalCoin.toString() ?? '0',
                    widget: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          '${LKey.fromBattle.tr} : ${userState?.totalBattleCoin ?? 0} + ${LKey.live.tr} : ${userState?.liveCoin ?? 0}',
                          style: TextStyleCustom.outFitThin100(
                              color: whitePure(context).withValues(
                            alpha: .7,
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: isHost ? onGoHomeTap : Get.back,
                child: Container(
                  height: 57,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                      shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                              cornerRadius: 10, cornerSmoothing: 1),
                          side: BorderSide.none),
                      color: whitePure(context)),
                  child: GradientText(
                    isHost ? LKey.goHome.tr : LKey.getBack.tr,
                    gradient: StyleRes.themeGradient,
                    style: TextStyleCustom.unboundedMedium500(fontSize: 17),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class BuildTextAndValueTiles extends StatelessWidget {
  final Widget? widget;
  final String title;
  final String value;

  const BuildTextAndValueTiles(
      {super.key, this.widget, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: .5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      color: whitePure(context).withValues(alpha: .1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyleCustom.outFitLight300(
                    color: whitePure(context).withValues(alpha: .7),
                    fontSize: 16),
              ),
              Text(
                value,
                style: TextStyleCustom.outFitMedium500(
                    color: whitePure(context).withValues(alpha: .7),
                    fontSize: 18),
              ),
            ],
          ),
          if (widget != null) widget!
        ],
      ),
    );
  }
}
