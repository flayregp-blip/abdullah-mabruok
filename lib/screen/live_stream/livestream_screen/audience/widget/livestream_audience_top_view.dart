import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/haptic_manager.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/common/widget/gradient_border.dart';
import 'package:shortzz/common/widget/gradient_text.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/livestream/livestream.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/audience/widget/live_stream_user_info_sheet.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/host/widget/live_stream_host_top_view.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/livestream_screen_controller.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/view/livestream_view.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/widget/members_sheet.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LiveStreamAudienceTopView extends StatelessWidget {
  final bool isAudience;
  final LivestreamScreenController controller;

  const LiveStreamAudienceTopView(
      {super.key, this.isAudience = false, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      minimum: EdgeInsets.only(top: AppBar().preferredSize.height * 0.7),
      child: Obx(() {
        bool isVisible = controller.isViewVisible.value;
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: isVisible ? 1 : 0,
          child: IgnorePointer(
            ignoring: !isVisible,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  _BuildTopView(controller: controller),
                  _BuildCenterView(controller: controller),
                  _BuildBottomView(controller: controller)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _BuildTopView extends StatelessWidget {
  final LivestreamScreenController controller;

  const _BuildTopView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () {
            Livestream stream = controller.liveData.value;
            bool isBattleRunning = stream.battleType != BattleType.initiate;
            bool isAudience =
                stream.coHostIds?.contains(controller.myUserId) == false;

            if (isBattleRunning && !isAudience) return const SizedBox();
            return InkWell(
              onTap: controller.onCloseAudienceBtn,
              child: Container(
                height: 25,
                width: 25,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: whitePure(context).withValues(alpha: .5),
                        width: 1.5)),
                alignment: Alignment.center,
                child: Image.asset(AssetRes.icClose1,
                    color: whitePure(context).withValues(alpha: .5),
                    width: 18,
                    height: 18),
              ),
            );
          },
        ),
        InkWell(
          onTap: () {
            HapticManager.shared.light();
            controller.reportUser(controller.liveData.value.hostId);
          },
          child: Image.asset(AssetRes.icReport,
              color: whitePure(context).withValues(alpha: 0.5),
              width: 28,
              height: 28),
        ),
      ],
    );
  }
}

class _BuildCenterView extends StatelessWidget {
  final LivestreamScreenController controller;

  const _BuildCenterView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Livestream stream = controller.liveData.value;
      AppUser? hostUser = controller.firestoreController.users
          .firstWhereOrNull((element) => element.userId == stream.hostId);
      return Row(
        spacing: 10,
        children: <Widget>[
          InkWell(
            onTap: () {
              Get.bottomSheet(
                LiveStreamUserInfoSheet(
                    isAudience: true,
                    liveUser: hostUser,
                    controller: controller),
                isScrollControlled: true,
              );
            },
            child: GradientBorder(
              strokeWidth: 2,
              gradient: StyleRes.themeGradient,
              radius: 30,
              child: Padding(
                  padding: const EdgeInsets.all(1.5),
                  child: CustomImage(
                      size: const Size(40, 40),
                      image: hostUser?.profile?.addBaseURL(),
                      fit: BoxFit.cover,
                      fullName: hostUser?.fullname)),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                FullNameWithBlueTick(
                  username: hostUser?.username,
                  fontSize: 13,
                  iconSize: 18,
                  fontColor: whitePure(context),
                  isVerify: hostUser?.isVerify,
                ),
                FittedBox(
                  child: Container(
                    height: 18,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: ShapeDecoration(
                      color: whitePure(context).withValues(alpha: 1),
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(cornerRadius: 5),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: GradientText(
                      LKey.host.tr.toUpperCase(),
                      gradient: StyleRes.themeGradient,
                      style: TextStyleCustom.unboundedBold700(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            Livestream liveData = controller.liveData.value;
            bool isBattleOn = liveData.type == LivestreamType.battle;
            bool isCoHost =
                (stream.coHostIds ?? []).contains(controller.myUserId);
            int count = liveData.watchingCount ?? 0;
            int watchingCount = count >= 0 ? count : 0;
            return Row(
              spacing: 5,
              children: [
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: blackPure(context).withValues(alpha: .1),
                    border: Border.all(
                        color: whitePure(context).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Image.asset(AssetRes.icEye_2, height: 20, width: 20),
                      const SizedBox(width: 4),
                      Text(
                        watchingCount.numberFormat,
                        style: TextStyleCustom.outFitMedium500(
                            color: whitePure(context)),
                      ),
                    ],
                  ),
                ),
                if (!isBattleOn && liveData.isRestrictToJoin == 0 && !isCoHost)
                  LiveStreamCircleBorderButton(
                    image: AssetRes.icVideoRequest,
                    margin: EdgeInsets.zero,
                    iconColor: whitePure(context),
                    onTap: () => controller.onVideoRequestSend(liveData),
                  ),
                if (!isBattleOn)
                  LiveStreamCircleBorderButton(
                    image: AssetRes.icAudience,
                    margin: EdgeInsets.zero,
                    iconColor: whitePure(context),
                    onTap: () {
                      Get.bottomSheet(const MembersSheet(isHost: false),
                          isScrollControlled: true);
                    },
                  )
              ],
            );
          })
        ],
      );
    });
  }
}

class _BuildBottomView extends StatelessWidget {
  final LivestreamScreenController controller;

  const _BuildBottomView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Livestream data = controller.liveData.value;
      bool isBattleView = data.type == LivestreamType.battle;
      StreamView? hostView = controller.streamViews
          .firstWhereOrNull((element) => element.streamId == '${data.hostId}');
      if (isBattleView) {
        return const SizedBox();
      }
      bool isDummyLive = data.isDummyLive == 1;
      return Container(
        width: 40,
        alignment: Alignment.center,
        child: MuteUnMuteButton(
            isMute: isDummyLive
                ? controller.isPlayerMute
                : (hostView?.isMuted ?? false).obs,
            onTap: () => isDummyLive
                ? controller.togglePlayerAudioToggle()
                : controller.toggleStreamAudio(data.hostId)),
      );
    });
  }
}
