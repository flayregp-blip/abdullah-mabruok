import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/gradient_text.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/screen/music_sheet/music_sheet_controller.dart';
import 'package:shortzz/screen/music_sheet/widget/music_list.dart';
import 'package:shortzz/screen/selected_music_sheet/selected_music_sheet_controller.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class MusicCategoryGrid extends StatelessWidget {
  final RxList<MusicCategory> musicCategories;

  const MusicCategoryGrid({
    super.key,
    required this.musicCategories,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MusicSheetController>();
    return Obx(
      () => GridView.builder(
        itemCount: musicCategories.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 85, crossAxisSpacing: 5, mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          MusicCategory musicCategory = musicCategories[index];
          return InkWell(
            onTap: () {
              controller.fetchMusicByCategories(musicCategory.id?.toInt());
              Get.bottomSheet(CategoryMusicSheet(musicCategory: musicCategory),
                      isScrollControlled: true)
                  .then(
                (value) {
                  controller.categoryMusicList.clear();
                },
              );
            },
            child: Container(
              decoration: ShapeDecoration(
                color: bgMediumGrey(context),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 7,
                    cornerSmoothing: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientText(
                    musicCategory.name ?? '',
                    gradient: StyleRes.themeGradient,
                    style: TextStyleCustom.outFitSemiBold600(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${musicCategory.musicsCount ?? 0} ${LKey.music.tr}',
                    style: TextStyleCustom.outFitRegular400(
                        fontSize: 13, color: textLightGrey(context)),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryMusicSheet extends StatelessWidget {
  final MusicCategory musicCategory;
  final Function(SelectedMusic? music)? onMusicAdd;

  const CategoryMusicSheet({super.key, required this.musicCategory, this.onMusicAdd});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MusicSheetController>();
    return Container(
      margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2),
      decoration: ShapeDecoration(
          color: whitePure(context),
          shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.vertical(
                  top: SmoothRadius(cornerRadius: 30, cornerSmoothing: 1)))),
      child: Column(
        children: [
          BottomSheetTopView(title: musicCategory.name ?? '', sideBtnVisibility: false),
          Expanded(
            child: MusicList(musicList: controller.categoryMusicList, isCategorySheet: true),
          )
        ],
      ),
    );
  }
}
