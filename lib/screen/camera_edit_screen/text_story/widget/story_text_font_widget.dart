import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/story_text_view_controller.dart';
import 'package:shortzz/screen/edit_profile_screen/widget/base_select_sheet.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

class StoryTextFontWidget extends StatelessWidget {
  const StoryTextFontWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoryTextViewController>();
    return Container(
      height: 35,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          InkWell(
            onTap: controller.openFontSheet,
            child: Container(
              height: 30,
              width: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: whitePure(context).withValues(alpha: .3), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: RotatedBox(
                  quarterTurns: 2,
                  child: Image.asset(AssetRes.icDownArrow_1,
                      color: whitePure(context), width: 20, height: 20)),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.outerFontFamilyList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  GoogleFontFamily fontFamily = controller.outerFontFamilyList[index];
                  return InkWell(
                    onTap: () => controller.onFontFamilySelect(fontFamily, 0),
                    child: Obx(
                      () {
                        bool isSelected = controller.selectedFontFamily.value ==
                            controller.outerFontFamilyList[index];
                        return Container(
                          height: 30,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: ShapeDecoration(
                              shape: SmoothRectangleBorder(
                                borderRadius:
                                    SmoothBorderRadius(cornerRadius: 5, cornerSmoothing: 1),
                              ),
                              color: isSelected
                                  ? whitePure(context)
                                  : blackPure(context).withValues(alpha: .2)),
                          child: Text(
                            fontFamily.fontName,
                            style: fontFamily.style.copyWith(
                                color: isSelected
                                    ? blackPure(context)
                                    : whitePure(context),
                                fontSize: 16),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleFontFamilySheet extends StatelessWidget {
  const GoogleFontFamilySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoryTextViewController>();
    return BaseSelectSheet<GoogleFontFamily>(
        title: LKey.fontFamily.tr,
        items: controller.filteredFontFamilyList,
        selectedItem: controller.selectedFontFamily,
        getDisplayText: (p0) => p0.fontName,
        style: (p0) => p0.style,
        onSelect: (p0) => controller.onFontFamilySelect(p0, 1),
        onSearch: controller.onSearchFontFamily);
  }
}
