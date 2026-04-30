import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/story_text_view_controller.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class StoryTextFontStyle extends StatelessWidget {
  const StoryTextFontStyle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoryTextViewController>();
    return Container(
      color: blackPure(context),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              controller.alignList.length,
              (index) {
                FontAlign align = controller.alignList[index];
                return InkWell(
                  onTap: () {
                    controller.selectedAlignment.value = align;
                  },
                  child: Obx(
                    () {
                      bool isSelected = controller.selectedAlignment.value == align;
                      return Icon(
                        align.icon,
                        color: isSelected ? whitePure(context) : textLightGrey(context),
                        size: 30,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Align'.toUpperCase(),
            style: TextStyleCustom.outFitRegular400(color: whitePure(context), fontSize: 12),
          )
        ],
      ),
    );
  }
}
