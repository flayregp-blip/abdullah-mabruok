import 'dart:ui';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/music/music_model.dart';
import 'package:shortzz/screen/audio_details_screen/audio_details_screen.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class AudioSheet extends StatefulWidget {
  final Music? music;

  const AudioSheet({super.key, this.music});

  @override
  State<AudioSheet> createState() => _AudioSheetState();
}

class _AudioSheetState extends State<AudioSheet> {
  Rx<Music?> music = Rx<Music?>(null);
  bool isSavedLoading = false;

  @override
  void initState() {
    super.initState();
    music = widget.music.obs;
  }

  void onSavedMusic() {
    int musicId = music.value?.id ?? -1;
    if (musicId == -1) {
      return Loggers.error('Invalid Music ID : $musicId');
    }

    if (isSavedLoading) return;

    final user = SessionManager.instance.getUser();
    if (user == null) {
      return;
    }

    final savedMusicIds = user.savedMusicIds
            ?.split(',')
            .where((e) => e.isNotEmpty)
            .map(int.parse)
            .toList() ??
        [];

    if (savedMusicIds.contains(musicId)) {
      savedMusicIds.remove(musicId);
      music.update((val) => val?.isSaved = false);
    } else {
      savedMusicIds.add(musicId);
      music.update((val) => val?.isSaved = true);
    }

    isSavedLoading = true;

    _updateSavedMusicId(savedMusicIds);
  }

  Future<void> _updateSavedMusicId(List<int> savedMusicIds) async {
    await UserService.instance.updateUserDetails(savedMusicIds: savedMusicIds);
    isSavedLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: ShapeDecoration(
              shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.vertical(
                      top: SmoothRadius(cornerRadius: 40, cornerSmoothing: 1))),
              color: whitePure(context)),
          alignment: Alignment.center,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                    height: 2,
                    width: 100,
                    color: bgGrey(context),
                    margin: const EdgeInsets.only(top: 10, bottom: 20)),
                Container(
                  height: 115,
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 21, height: 27),
                      AudioImageWidget(
                          music: widget.music, isPlaying: false.obs),
                      Align(
                          alignment: const Alignment(0, -.8),
                          child: InkWell(
                            onTap: onSavedMusic,
                            child: Obx(
                              () => Image.asset(
                                  music.value?.isSaved ?? false
                                      ? AssetRes.icFillBookmark1
                                      : AssetRes.icBookmark,
                                  color: textDarkGrey(context),
                                  width: 21,
                                  height: 25),
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.music?.title ?? '',
                  style: TextStyleCustom.outFitRegular400(
                      fontSize: 15, color: textDarkGrey(context)),
                ),
                const SizedBox(height: 7),
                FullNameWithBlueTick(
                  username: widget.music?.user?.username ??
                      widget.music?.artist ??
                      '',
                  fontSize: 14,
                  mainAxisAlignment: MainAxisAlignment.center,
                  isVerify: widget.music?.user?.isVerify,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.music?.user?.fullname ?? LKey.admin.tr,
                  style: TextStyleCustom.outFitRegular400(
                      color: textLightGrey(context), fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  (widget.music?.postCount ?? 0).toString(),
                  style: TextStyleCustom.unboundedSemiBold600(
                      color: textDarkGrey(context), fontSize: 16),
                ),
                Text(
                  LKey.reels.tr,
                  style: TextStyleCustom.outFitRegular400(
                      color: textLightGrey(context), fontSize: 15),
                ),
                const SizedBox(height: 25),
                TextButtonCustom(
                  onTap: () {
                    Get.back();
                    Get.to(() => AudioDetailsScreen(music: music));
                  },
                  title: LKey.checkVideos.tr,
                  backgroundColor: themeAccentSolid(context),
                  titleColor: whitePure(context),
                  horizontalMargin: 40,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AudioImageWidget extends StatelessWidget {
  final double? imageSize;
  final bool? isPlayIconVisible;
  final Music? music;
  final VoidCallback? onPlayPauseMusic;
  final RxBool isPlaying;
  final double strokeWidth;
  final double padding;

  const AudioImageWidget(
      {super.key,
      this.imageSize,
      this.isPlayIconVisible,
      this.music,
      this.onPlayPauseMusic,
      required this.isPlaying,
      this.strokeWidth = 3,
      this.padding = 7});

  @override
  Widget build(BuildContext context) {
    Size size = Size(imageSize ?? 110, imageSize ?? 110);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: textDarkGrey(context).withValues(alpha: .2),
                  blurRadius: 25)
            ],
          ),
        ),
        CustomImage(
            image: music?.image?.addBaseURL(),
            size: Size(size.width, size.height),
            fullName: music?.user?.fullname),
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(180),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
            child: SizedBox(height: size.height, width: size.width),
          ),
        ),
        CustomImage(
          image: music?.image?.addBaseURL(),
          size: Size(size.width - padding, size.height - padding),
          fullName: music?.user?.fullname,
          strokeColor: Colors.white,
          strokeWidth: strokeWidth,
          isStokeOutSide: false,
        ),
        if (isPlayIconVisible ?? false)
          Obx(
            () => InkWell(
                onTap: onPlayPauseMusic,
                child: Image.asset(
                    !isPlaying.value ? AssetRes.icPlay : AssetRes.icPause,
                    height: 30,
                    width: 30,
                    color: whitePure(context))),
          )
      ],
    );
  }
}
