import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/custom_search_text_field.dart';
import 'package:shortzz/common/widget/custom_tab_switcher.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/music_sheet/music_sheet_controller.dart';
import 'package:shortzz/screen/music_sheet/widget/music_category_grid_view.dart';
import 'package:shortzz/screen/music_sheet/widget/music_list.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class MusicSheet extends StatelessWidget {
  final int videoDurationInSecond;

  const MusicSheet({super.key, required this.videoDurationInSecond});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MusicSheetController(videoDurationInSecond));
    return Container(
      margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2),
      decoration: ShapeDecoration(
        color: whitePure(context),
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.vertical(
            top: SmoothRadius(cornerRadius: 30, cornerSmoothing: 1),
          ),
        ),
      ),
      child: Column(
        children: [
          BottomSheetTopView(
              title: LKey.selectMusic.tr, sideBtnVisibility: true),
          CustomTabSwitcher(
              onTap: controller.onChangedMusicCategories,
              selectedIndex: controller.selectedMusicCategory,
              items: controller.categories,
              margin: const EdgeInsets.symmetric(horizontal: 10)),
          Row(
            children: [
              Expanded(
                child: CustomSearchTextField(
                  controller: controller.searchController,
                  onTap: controller.onSearchTap,
                  onChanged: controller.onChanged,
                  onTapOutside: controller.onTapOutside,
                ),
              ),
              Obx(
                () => controller.isSearch.value
                    ? InkWell(
                        onTap: controller.onCancelTap,
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(LKey.cancel.tr,
                                style: TextStyleCustom.outFitRegular400(
                                    fontSize: 15,
                                    color: textLightGrey(context)))),
                      )
                    : const SizedBox(),
              )
            ],
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Obx(
                () => Stack(
                  children: [
                    PageView(
                      controller: controller.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        MusicList(musicList: controller.exploreMusicList),
                        MusicCategoryGrid(
                            musicCategories: controller.musicCategoryList),
                        MusicList(musicList: controller.savedMusicList),
                      ],
                    ),
                    if (controller.isSearch.value)
                      MusicList(musicList: controller.searchMusicList),
                    if (controller.isMusicDownloading.value)
                      const LoaderWidget()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
