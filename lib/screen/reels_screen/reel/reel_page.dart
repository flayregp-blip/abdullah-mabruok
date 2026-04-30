import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/black_gradient_shadow.dart';
import 'package:shortzz/common/widget/double_tap_detector.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/model/post_story/post_by_id.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/screen/reels_screen/reel/reel_page_controller.dart';
import 'package:shortzz/screen/reels_screen/reel/widget/reel_animation_like.dart';
import 'package:shortzz/screen/reels_screen/reel/widget/reel_seek_bar.dart';
import 'package:shortzz/screen/reels_screen/reel/widget/side_bar_list.dart';
import 'package:shortzz/screen/reels_screen/reel/widget/user_information.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/theme_res.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ---------------------------------------------------------------
// REEL PAGE
// ---------------------------------------------------------------
class ReelPage extends StatefulWidget {
  final VideoPlayerController? videoPlayerController;
  final Post reelData;
  final PostByIdData? postByIdData;
  final bool isFromChat;
  final GlobalKey likeKey;
  final Function(Post reel) onUpdateReelData;

  const ReelPage({
    super.key,
    this.videoPlayerController,
    required this.reelData,
    this.postByIdData,
    this.isFromChat = false,
    required this.likeKey,
    required this.onUpdateReelData,
  });

  @override
  State<ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<ReelPage> {
  RxBool isPlaying = true.obs;
  late ReelController reelController;
  Rx<TapDownDetails?> details = Rx(null);

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ReelController>(tag: '${widget.reelData.id}')) {
      reelController = Get.find<ReelController>(tag: '${widget.reelData.id}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!widget.isFromChat) {
          reelController.updateReelData(reel: widget.reelData);
        }
        reelController.notifyCommentSheet(widget.postByIdData);
      });
    } else {
      reelController = Get.put(
        ReelController(widget.reelData.obs, widget.onUpdateReelData),
        tag: '${widget.reelData.id}',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        reelController.notifyCommentSheet(widget.postByIdData);
      });
    }
    isPlaying.value = true;
  }

  void _handleVisibilityChanged(VisibilityInfo info) {
    final controller = widget.videoPlayerController;
    isPlaying.value = true;
    if (!_isControllerAlive(controller)) return;

    final isMostlyVisible = info.visibleFraction > 0.9;
    final isBottomSheetOpen = Get.isBottomSheetOpen == true;

    if (isMostlyVisible && !isBottomSheetOpen) {
      if (!controller!.value.isPlaying) {
        controller.play();
        isPlaying.value = true;
      }
    } else {
      if (controller!.value.isPlaying) {
        controller.pause();
        isPlaying.value = false;
      }
    }
  }

  bool _isControllerAlive(VideoPlayerController? c) {
    try {
      return c != null && c.value.isInitialized;
    } catch (_) {
      return false; // controller disposed
    }
  }

  void onPlayPause() {
    final controller = widget.videoPlayerController;
    if (!_isControllerAlive(controller)) return;

    if (controller!.value.isPlaying) {
      controller.pause();
      isPlaying.value = false;
    } else {
      controller.play();
      isPlaying.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('reel_${widget.reelData.id}'),
      onVisibilityChanged: _handleVisibilityChanged,
      child: DoubleTapDetector(
        onDoubleTap: (value) {
          if (details.value != null) return;
          details.value = value;
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            widget.videoPlayerController != null
                ? CustomCacheVideoPlayer(
                    videoPlayer: widget.videoPlayerController, onPlayPause: onPlayPause)
                : const SizedBox(),

            /// 🕹 Tap Overlay (pause/play)
            InkWell(onTap: onPlayPause, child: const BlackGradientShadow()),

            /// ▶ Play/Pause Icon overlay
            if (widget.videoPlayerController != null)
              Obx(() {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: isPlaying.value ? 0.0 : 1.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: onPlayPause,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        alignment: const Alignment(0.25, 0),
                        child: Image.asset(isPlaying.value ? AssetRes.icPause : AssetRes.icPlay,
                            width: 45, height: 45, color: bgGrey(context)),
                      ),
                    ),
                  ),
                );
              }),

            /// ℹ️ Reel Info Section
            ReelInfoSection(
              controller: reelController,
              likeKey: widget.likeKey,
              videoPlayerPlusController: widget.videoPlayerController,
            ),

            /// 💖 Like Animation
            Obx(() {
              if (details.value == null) return const SizedBox();
              return ReelAnimationLike(
                likeKey: widget.likeKey,
                position: details.value!.globalPosition,
                size: const Size(50, 50),
                leftRightPosition: 8,
                onLikeCall: () {
                  if (reelController.reelData.value.isLiked == true) return;
                  reelController.onLikeTap();
                },
                onCompleteAnimation: () => details.value = null,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ReelInfoSection extends StatelessWidget {
  final ReelController controller;
  final GlobalKey likeKey;
  final VideoPlayerController? videoPlayerPlusController;

  const ReelInfoSection(
      {super.key,
      required this.controller,
      required this.likeKey,
      required this.videoPlayerPlusController});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ReelInfoRow(controller: controller, likeKey: likeKey),
        if (videoPlayerPlusController != null)
          ReelSeekBar(videoController: videoPlayerPlusController, controller: controller)
        else
          const SizedBox(height: 15),
      ],
    );
  }
}

class ReelInfoRow extends StatelessWidget {
  final ReelController controller;
  final GlobalKey likeKey;

  const ReelInfoRow({super.key, required this.controller, required this.likeKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: UserInformation(controller: controller)),
        SideBarList(controller: controller, likeKey: likeKey),
      ],
    );
  }
}

class CustomCacheVideoPlayer extends StatelessWidget {
  final VideoPlayerController? videoPlayer;
  final VoidCallback onPlayPause;

  const CustomCacheVideoPlayer({super.key, required this.videoPlayer, required this.onPlayPause});

  @override
  Widget build(BuildContext context) {
    if (videoPlayer != null && videoPlayer?.value.isInitialized == true) {
      final videoSize = (videoPlayer?.value.size)!;
      final fitType = videoSize.width < videoSize.height ? BoxFit.cover : BoxFit.fitWidth;
      return InkWell(
          onTap: onPlayPause,
          child: Container(
            color: blackPure(context),
            child: SizedBox.expand(
              child: FittedBox(
                fit: fitType,
                child: SizedBox(
                  width: videoSize.width,
                  height: videoSize.height,
                  child: videoPlayer == null ? null : VideoPlayer(videoPlayer!),
                ),
              ),
            ),
          ));
    } else {
      return const LoaderWidget();
    }
  }
}
