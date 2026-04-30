import 'dart:math';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/widget/gradient_icon.dart';
import 'package:shortzz/model/chat/message_data.dart';
import 'package:shortzz/screen/chat_screen/chat_screen_controller.dart';
import 'package:shortzz/screen/chat_screen/widget/chat_center_message_view.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ChatAudioMessage extends StatelessWidget {
  final MessageData message;
  final ChatScreenController controller;

  const ChatAudioMessage(
      {super.key, required this.message, required this.controller});

  @override
  Widget build(BuildContext context) {
    Loggers.error(message.waveData);
    List<double> waves = (message.waveData ?? "")
            .split(',')
            .map((e) => e.isEmpty ? 0.0 : double.parse(e))
            .toList() ??
        [];
    if (waves.isEmpty) {
      return const SizedBox();
    }
    return Container(
      height: cardTotalHeight,
      width: cardTotalWidth,
      decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 15, cornerSmoothing: 1),
          ),
          shadows: messageBubbleShadow,
          color: textDarkGrey(context)),
      padding: EdgeInsets.symmetric(horizontal: cardMargin),
      child: Obx(() {
        PlayerValue playerValue = controller.playerValue.value;
        bool isPlaying = (playerValue.state == PlayerState.playing) &&
            (playerValue.id == message.id);
        return Row(
          spacing: 5,
          children: [
            InkWell(
              onTap: () => controller.toggleAudioPlayback(message),
              child: Container(
                  height: buttonSize,
                  width: buttonSize,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: whitePure(context)),
                  alignment: const Alignment(.1, 0),
                  child: GradientIcon(
                      child: Image.asset(
                          isPlaying ? AssetRes.icPause : AssetRes.icPlay,
                          width: 25,
                          height: 25))),
            ),
            SizedBox(
              width: wavesWidth,
              height: 50,
              child: controller.playerValue.value.id == message.id
                  ? AudioFileWaveforms(
                      size: Size(wavesWidth, cardTotalHeight),
                      playerController: controller.playerController,
                      waveformType: WaveformType.fitWidth,
                      playerWaveStyle: PlayerWaveStyle(
                        fixedWaveColor: bgGrey(context),
                        liveWaveGradient: StyleRes.wavesGradient,
                        spacing: 3,
                        waveThickness: 1.5,
                      ))
                  : Row(
                      children: List.generate(waves.length, (index) {
                      var height = waves[index] * 200;
                      return Expanded(
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: 15, cornerSmoothing: 0)),
                            color: bgGrey(context),
                          ),
                          margin: const EdgeInsets.all(1),
                          height: max(2, height),
                        ),
                      );
                    })),
            )
          ],
        );
      }),
    );
  }
}

double get cardTotalWidth => 220;

double get cardTotalHeight => 70;

double get cardMargin => 12;

double get buttonSize => 36;
double wavesWidth = cardTotalWidth - ((cardMargin * 2) + buttonSize + 5);
