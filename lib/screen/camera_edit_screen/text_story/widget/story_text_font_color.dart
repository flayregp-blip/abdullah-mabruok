import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/functions/generate_color.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/story_text_view_controller.dart';
import 'package:shortzz/utilities/theme_res.dart';

class StoryTextFontColor extends StatelessWidget {
  const StoryTextFontColor({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoryTextViewController>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 50,
        child: Row(
          children: GenerateColor.instance.fontColor.map((color) {
            return Obx(() {
              bool isSelected = controller.selectedColor.value == color;

              return InkWell(
                onTap: () {
                  controller.selectedColor.value = color;
                },
                child: Container(
                  width: 35,
                  height: 35,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: whitePure(context),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: AnimatedContainer(
                    width: isSelected ? 30 : 35,
                    height: isSelected ? 30 : 35,
                    margin: const EdgeInsets.all(1),
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            });
          }).toList(),
        ),
      ),
    );
  }
}
