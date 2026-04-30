import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/model/post_story/music/music_model.dart';
import 'package:shortzz/screen/music_sheet/music_sheet_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class MusicList extends StatelessWidget {
  final RxList<Music> musicList;
  final bool isCategorySheet;

  const MusicList({super.key, required this.musicList, this.isCategorySheet = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MusicSheetController>();
    return Obx(
      () => Container(
        color: scaffoldBackgroundColor(context),
        child: controller.isLoading.value
            ? const LoaderWidget()
            : NoDataView(
                showShow: musicList.isEmpty,
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.zero,
                    itemCount: musicList.length,
                    itemBuilder: (context, index) {
                      Music music = musicList[index];
                      return MusicCard(
                        music: music,
                        controller: controller,
                        isCategorySheet: isCategorySheet,
                      );
                    }),
              ),
      ),
    );
  }
}

class MusicCard extends StatelessWidget {
  final Music music;
  final MusicSheetController controller;
  final bool isCategorySheet;

  const MusicCard(
      {super.key, required this.music, required this.controller, this.isCategorySheet = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.onTapMusic(music, isCategorySheet),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: Row(
          children: [
            CustomImage(
                size: const Size(57, 57),
                radius: 5,
                cornerSmoothing: 1,
                isShowPlaceHolder: true,
                image: music.image?.addBaseURL()),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(music.title ?? '',
                    style:
                        TextStyleCustom.outFitMedium500(fontSize: 15, color: textDarkGrey(context)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                Text(
                  '${music.artist} • ${music.duration}',
                  style: TextStyleCustom.outFitLight300(color: textLightGrey(context)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )
              ],
            )),
            const SizedBox(width: 10),
            InkWell(
                onTap: () => controller.onBookMarkTap(music),
                child: Obx(
                  () {
                    bool isSaved = controller.savedMusicIds.contains(music.id);
                    return Image.asset(isSaved ? AssetRes.icFillBookmark1 : AssetRes.icBookmark,
                        color: textDarkGrey(context), height: 22, width: 22);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
