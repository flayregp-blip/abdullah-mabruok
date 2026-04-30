import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/livestream/livestream.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/livestream_screen_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class BattleStartCountdownOverlay extends StatefulWidget {
  final bool isHost;
  final Livestream stream;

  const BattleStartCountdownOverlay(
      {super.key, required this.isHost, required this.stream});

  @override
  State<BattleStartCountdownOverlay> createState() =>
      _BattleStartCountdownOverlayState();
}

class _BattleStartCountdownOverlayState
    extends State<BattleStartCountdownOverlay>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<LivestreamScreenController>();

  late AnimationController _animationController;
  RxInt countDownValue = AppRes.battleStartInSecond.obs;
  Timer? timer;
  Livestream? stream;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    stream = widget.stream;
    controller.battleStartPlayer.pause();
    battleCountdownTimer();
  }

  void battleCountdownTimer() async {
    final DateTime battleStartTime =
        DateTime.fromMillisecondsSinceEpoch(stream?.battleCreatedAt ?? 0);
    final DateTime battleEndTime = battleStartTime
        .add(const Duration(seconds: AppRes.battleStartInSecond));

    _timerStart(() async {
      final nowTime = DateTime.now();
      final int secondsRemaining =
          (battleEndTime.difference(nowTime).inSeconds);

      countDownValue.value =
          secondsRemaining.clamp(0, AppRes.battleStartInSecond);

      // Loggers.error(
      //     '$battleStartTime || $battleEndTime || $nowTime || ${countDownValue.value}');
      Loggers.info(
          '[BATTLE STARTING] Battle start in ${battleEndTime.difference(DateTime.now()).inMilliseconds} sec');

      if (countDownValue.value <= 0) {
        controller.minViewerTimeoutTimer?.cancel();
        controller.battleStartPlayer.seek(const Duration(seconds: 0));
        controller.battleStartPlayer.play();
        timer?.cancel();
        controller.updateLiveStreamData(
            battleType: BattleType.running, type: LivestreamType.battle);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: blackPure(context).withValues(alpha: .7),
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(AssetRes.icBattleVs, width: 150),
          Text(
            LKey.battleStartingIn.tr.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyleCustom.unboundedBlack900(
                color: whitePure(context), fontSize: 30),
          ),
          Obx(
            () => countDownValue.value <= -1
                ? const SizedBox()
                : AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                                colors: <Color>[
                                  whitePure(context).withValues(alpha: 0),
                                  whitePure(context).withValues(alpha: .5)
                                ],
                                transform: GradientRotation(
                                    2 * pi * _animationController.value)),
                            border: Border.all(
                                color: whitePure(context)
                                    .withAlpha((255 * 0.1).toInt()),
                                width: 1.5)),
                        alignment: Alignment.center,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: animation.value,
                                child: child);
                          },
                          child: Text(
                            '$countDownValue',
                            style: TextStyleCustom.unboundedExtraBold800(
                                color: whitePure(context), fontSize: 90),
                            key: ValueKey<int>(countDownValue.value),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (widget.isHost)
            FittedBox(
              child: InkWell(
                onTap: () {
                  timer?.cancel();
                  controller.updateLiveStreamData(
                      battleType: BattleType.initiate,
                      type: LivestreamType.livestream);
                },
                child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: whitePure(context).withValues(alpha: .2),
                        border: Border.all(
                            color: whitePure(context).withValues(alpha: .3))),
                    child: Text(
                      LKey.cancel.tr,
                      style: TextStyleCustom.outFitRegular400(
                          color: whitePure(context)),
                    )),
              ),
            )
        ],
      ),
    );
  }

  void _timerStart(VoidCallback callBack) {
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (t) {
        callBack.call();
        // Cancel the timer after 5 seconds
        // if (t.tick >= 10) {
        //   timer?.cancel();
        // }
      },
    );
  }
}
