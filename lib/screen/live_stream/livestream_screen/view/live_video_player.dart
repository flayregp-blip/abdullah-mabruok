import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LivestreamVideoPlayer extends StatelessWidget {
  final Rx<VideoPlayerController?> controller;

  const LivestreamVideoPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      VideoPlayerController? player = controller.value;
      if (player == null) {
        return const SizedBox();
      }
      double width = player.value.size.width;
      double height = player.value.size.height;
      return ClipRRect(
        child: SizedBox.expand(
          child: FittedBox(
            fit: width < height ? BoxFit.cover : BoxFit.fitWidth,
            child: SizedBox(
              width: width,
              height: height,
              child: VideoPlayer(player),
            ),
          ),
        ),
      );
    });
  }
}
