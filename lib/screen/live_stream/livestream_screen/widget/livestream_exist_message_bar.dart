import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/duration_extension.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/livestream/livestream.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/livestream_screen_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LivestreamExistMessageBar extends StatefulWidget {
  final LivestreamScreenController controller;
  final Livestream stream;

  const LivestreamExistMessageBar(
      {super.key, required this.controller, required this.stream});

  @override
  State<LivestreamExistMessageBar> createState() =>
      _LivestreamExistMessageBarState();
}

class _LivestreamExistMessageBarState extends State<LivestreamExistMessageBar> {
  late final RxInt currentSecLeft;
  Timer? _timer;

  bool get isBattleView => widget.stream.type == LivestreamType.battle;

  @override
  void initState() {
    super.initState();
    startCountDown();
  }

  void startCountDown() async {
    currentSecLeft =
        (!isBattleView ? 10 : AppRes.battleEndMainViewInSecond).obs;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      Loggers.info(!isBattleView
          ? '[LIVESTREAM END] in $currentSecLeft sec.'
          : '[BATTLE END] Main View in $currentSecLeft sec.');
      if (currentSecLeft.value <= 1) {
        _timer?.cancel();
        if (isBattleView) {
          await widget.controller.updateLiveStreamData(
              battleType: BattleType.end, type: LivestreamType.livestream);
          widget.controller.updateUserStateToFirestore(
              widget.controller.myUserId,
              currentBattleCoin: 0);
          Future.delayed(
              const Duration(seconds: AppRes.battleCooldownDurationInSecond),
              () {
            widget.controller
                .updateLiveStreamData(battleType: BattleType.initiate);
            widget.controller.startMinViewerTimeoutCheck();
          });
        } else {
          widget.controller.hostEndStream();
        }
      } else {
        currentSecLeft.value--;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    currentSecLeft.close(); // Free Rx memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: whitePure(context).withValues(alpha: .1),
      ),
      child: Row(
        spacing: 5,
        children: [
          Expanded(
            child: Text(
              isBattleView
                  ? LKey.youWillBeSentBackToMainView.tr
                  : LKey.streamEndedMinUserDescription.trParams({
                      'viewers_count':
                          widget.controller.minViewersThreshold.toString()
                    }),
              style: TextStyleCustom.outFitLight300(
                  color: whitePure(context), fontSize: 17),
            ),
          ),
          Obx(
            () => Text(
              Duration(seconds: currentSecLeft.value).printDuration,
              style: TextStyleCustom.unboundedMedium500(
                color: whitePure(context),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
