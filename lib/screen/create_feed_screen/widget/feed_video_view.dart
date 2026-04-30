import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/duration_extension.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/widget/custom_bg_circle_button.dart';
import 'package:shortzz/screen/color_filter_screen/color_filter_screen.dart';
import 'package:shortzz/screen/create_feed_screen/create_feed_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';
import 'package:video_player/video_player.dart';

class FeedVideoView extends StatelessWidget {
  final CreateFeedScreenController controller;

  const FeedVideoView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        ImageWithFilter? video = controller.video.value;

        if (video == null) {
          return const SizedBox();
        }

        VideoPlayerController? playerController =
            controller.videoPlayerController.value;

        if (playerController == null) {
          return const SizedBox();
        }

        double width = playerController.value.size.width;
        double height = playerController.value.size.height;

        return Container(
          width: Get.width,
          height: Get.width,
          color: blackPure(context),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(video.colorFilter),
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: width < height ? BoxFit.cover : BoxFit.fitWidth,
                      child: SizedBox(
                        width: width,
                        height: height,
                        child: VideoPlayer(playerController),
                      ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: playerController,
                builder: (context, value, child) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomBgCircleButton(
                              image: AssetRes.icFilter,
                              onTap: () {
                                if (controller.videoPlayerController.value !=
                                    null) {
                                  playerController.pause();
                                  Get.bottomSheet(
                                          ColorFilterScreen(
                                            images: [video],
                                            onChanged: (items) {
                                              controller.video.value =
                                                  items.first;
                                            },
                                            mediaType: MediaType.video,
                                            videoPlayerController: controller
                                                .videoPlayerController.value,
                                          ),
                                          isScrollControlled: true,
                                          ignoreSafeArea: false)
                                      .then((value) {
                                    playerController.play();
                                  });
                                } else {
                                  Loggers.error(
                                      'Video Player controller not found');
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            CustomBgCircleButton(
                              image: AssetRes.icDelete,
                              onTap: controller.selectedVideoDelete,
                            ),
                          ],
                        ),
                      ),
                      CustomBgCircleButton(
                          image: value.isPlaying
                              ? AssetRes.icPause
                              : AssetRes.icPlay,
                          bgColor: textDarkGrey(context).withValues(alpha: .4),
                          size: const Size(65, 65),
                          iconSize: 40,
                          onTap: () {
                            if (value.isPlaying) {
                              playerController.pause();
                            } else {
                              playerController.play();
                            }
                          }),
                      Container(
                        height: 35,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: ShapeDecoration(
                            color: textDarkGrey(context).withValues(alpha: .3),
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius(
                                    cornerRadius: 5, cornerSmoothing: 1))),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 40,
                                child: Text(
                                  value.position.printDuration,
                                  style: TextStyleCustom.outFitMedium500(
                                      color: whitePure(context), fontSize: 12),
                                )),
                            Expanded(
                              child: Slider(
                                value: value.position.inMicroseconds.toDouble(),
                                min: 0,
                                max: value.duration.inMicroseconds.toDouble(),
                                thumbColor: themeAccentSolid(context),
                                activeColor: whitePure(context),
                                inactiveColor:
                                    whitePure(context).withValues(alpha: .3),
                                onChangeStart: (value) {
                                  playerController.pause();
                                },
                                onChangeEnd: (value) {
                                  playerController.play();
                                },
                                onChanged: (value) {
                                  playerController.seekTo(
                                      Duration(microseconds: value.toInt()));
                                },
                              ),
                            ),
                            Container(
                              width: 40,
                              alignment: AlignmentDirectional.centerEnd,
                              child: Text(
                                value.duration.printDuration,
                                style: TextStyleCustom.outFitMedium500(
                                    color: whitePure(context), fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
