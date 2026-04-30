import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/common/widget/reel_list.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/music/music_model.dart';
import 'package:shortzz/screen/audio_details_screen/audio_sheet.dart';
import 'package:shortzz/screen/audio_details_screen/audio_sheet_controller.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class AudioDetailsScreen extends StatelessWidget {
  final Rx<Music?> music;

  const AudioDetailsScreen({super.key, required this.music});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioDetailsScreenController(music), tag: '${music.value?.id}');
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: LKey.audioDetails.tr,
            rowWidget: Obx(() => InkWell(
                  onTap: controller.onSavedMusic,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                        (controller.music.value?.isSaved ?? false)
                            ? AssetRes.icFillBookmark1
                            : AssetRes.icBookmark,
                        width: 22,
                        height: 22,
                        color: textDarkGrey(context)),
                  ),
                )),
          ),
          AudioDetailsProfile(controller: controller),
          Expanded(
              child: ReelList(
            reels: controller.reelPosts,
            isLoading: controller.isLoading,
            onFetchMoreData: controller.fetchReelPostsByMusic,
            pageType: ReelPageType.audio,
          ))
        ],
      ),
    );
  }
}

class AudioDetailsProfile extends StatelessWidget {
  final AudioDetailsScreenController controller;

  const AudioDetailsProfile({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Music? music = controller.music.value;
      return Container(
        margin: const EdgeInsets.only(top: 20, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AudioImageWidget(
                        imageSize: 81,
                        strokeWidth: 3,
                        padding: 6,
                        isPlayIconVisible: true,
                        music: music,
                        onPlayPauseMusic: controller.onPlayPauseMusic,
                        isPlaying: controller.isPlaying,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (music?.postCount ?? 0).numberFormat,
                            style: TextStyleCustom.unboundedSemiBold600(
                                color: textDarkGrey(context), fontSize: 16),
                          ),
                          Text(
                            LKey.reels.tr,
                            style: TextStyleCustom.outFitRegular400(
                                color: textLightGrey(context), fontSize: 15),
                          ),
                        ],
                      ),
                      TextButtonCustom(
                        onTap: controller.onMakeReel,
                        title: LKey.makeReel.tr,
                        titleColor: whitePure(context),
                        backgroundColor: themeAccentSolid(context),
                        btnHeight: 40,
                        horizontalMargin: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    music?.title ?? '',
                    style: TextStyleCustom.outFitRegular400(
                        fontSize: 15, color: textDarkGrey(context)),
                  ),
                  const SizedBox(height: 7),
                  FullNameWithBlueTick(
                    username: music?.user?.username ?? music?.artist ?? '',
                    fontSize: 14,
                    mainAxisAlignment: MainAxisAlignment.center,
                    isVerify: music?.user?.isVerify,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    music?.user?.fullname ?? LKey.admin.tr,
                    style: TextStyleCustom.outFitRegular400(
                        color: textLightGrey(context), fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
