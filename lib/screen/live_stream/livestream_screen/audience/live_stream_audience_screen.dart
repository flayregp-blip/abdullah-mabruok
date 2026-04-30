import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:shortzz/model/livestream/livestream.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/audience/widget/livestream_audience_top_view.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/livestream_screen_controller.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/view/battle_view.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/view/live_stream_bottom_view.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/view/live_video_player.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/view/livestream_view.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/widget/battle_start_countdown_overlay.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/widget/live_stream_background_blur_image.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LiveStreamAudienceScreen extends StatelessWidget {
  final Livestream livestream;
  final bool isHost;

  const LiveStreamAudienceScreen(
      {super.key, required this.livestream, required this.isHost});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(LivestreamScreenController(livestream.obs, isHost));

    return Scaffold(
      backgroundColor: blackPure(context),
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: false,
        child: Stack(
          children: [
            const LiveStreamBlurBackgroundImage(),

            /// Live StreamView
            Obx(() {
              switch (controller.liveData.value.type) {
                case null:
                case LivestreamType.livestream:
                  return LivestreamView(
                    streamViews: controller.streamViews,
                    controller: controller,
                  );
                case LivestreamType.battle:
                  return BattleView(
                    isAudience: true,
                    controller: controller,
                    margin: const EdgeInsets.only(top: 100),
                  );
                case LivestreamType.dummy:
                  return LivestreamVideoPlayer(
                      controller: controller.videoPlayerController);
              }
            }),

            KeyboardAvoider(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LiveStreamAudienceTopView(
                      isAudience: true, controller: controller),
                  LiveStreamBottomView(
                      isAudience: true, controller: controller),
                ],
              ),
            ),

            Obx(
              () {
                Livestream stream = controller.liveData.value;
                bool isBattle = stream.battleType == BattleType.waiting;
                if (isBattle) {
                  return BattleStartCountdownOverlay(
                      isHost: isHost, stream: stream);
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
