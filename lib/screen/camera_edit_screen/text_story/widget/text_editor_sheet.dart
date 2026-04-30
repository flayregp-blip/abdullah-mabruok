import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/story_text_view_controller.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/widget/story_text_font_color.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/widget/story_text_font_opacity.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/widget/story_text_font_style.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/widget/story_text_font_widget.dart';
import 'package:shortzz/utilities/app_res.dart';

import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';
import 'package:uuid/uuid.dart';

class TextEditorSheet extends StatelessWidget {
  final TextWidgetData data;

  const TextEditorSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoryTextViewController>();
    final textController = TextEditingController(text: data.text.trim());

    controller
      ..selectedTextOpacity.value = data.opacity
      ..selectedFontFamily.value = data.googleFontFamily
      ..selectedColor.value = data.fontColor
      ..selectedAlignment.value = data.fontAlign
      ..selectedFontSize.value = data.fontSize;

    return Container(
      color: blackPure(context).withValues(alpha: 0.4),
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            minimum: EdgeInsets.only(top: AppBar().preferredSize.height),
            child: ConfirmButton(
                controller: controller,
                data: data,
                textController: textController),
          ),
          Expanded(
              child: CustomStoryTextField(
                  controller: controller, textController: textController)),
          StoryTextEditorToolbar(controller: controller),
        ],
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final StoryTextViewController controller;
  final TextEditingController textController;
  final TextWidgetData data;

  const ConfirmButton({super.key,
    required this.controller,
    required this.textController,
    required this.data});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: FittedBox(
        child: InkWell(
          onTap: () {
            TextWidgetData data1 = data;
            data1.fontSize = controller.selectedFontSize.value;
            Get.back(
                result: controller.createUpdatedData(
                    data, textController.text.trim()));
          },
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(cornerRadius: 30),
                side: BorderSide(color: whitePure(context), width: 1),
              ),
              color: whitePure(context).withValues(alpha: 0.2),
            ),
            child: Text(
              LKey.done.tr,
              style: TextStyleCustom.outFitRegular400(
                  fontSize: 17, color: whitePure(context)),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomStoryTextField extends StatelessWidget {
  final StoryTextViewController controller;
  final TextEditingController textController;

  const CustomStoryTextField(
      {super.key, required this.controller, required this.textController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: Get.width - 50,
        child: TextField(
          controller: textController,
          autofocus: true,
          // onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          textAlignVertical: TextAlignVertical.center,
          expands: true,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: LKey.typeSomething,
            // hintStyle: TextStyleCustom.outFitMedium500(
            //     fontSize: 25, color: whitePure(context), opacity: 0.5),
            hintStyle: _getTextStyle(
                font: controller.selectedFontFamily.value,
                fontSize: controller.selectedFontSize.value,
                color: controller.selectedColor.value,
                opacity: 0.5),
          ),
          textAlign: controller.selectedAlignment.value.align,
          style: _getTextStyle(
              font: controller.selectedFontFamily.value,
              fontSize: controller.selectedFontSize.value,
              color: controller.selectedColor.value,
              opacity: controller.selectedTextOpacity.value),
          cursorHeight: controller.selectedFontSize.value,
          cursorColor: whitePure(Get.context!),
        ),
      );
    });
  }

  TextStyle _getTextStyle(
      {GoogleFontFamily? font,
      required double fontSize,
      required Color color,
      required double opacity}) {
    return font?.style.copyWith(
          fontSize: fontSize,
          color: color.withValues(alpha: opacity),
        ) ??
        TextStyleCustom.outFitMedium500(
            fontSize: fontSize, color: color, opacity: opacity);
  }
}

class StoryTextEditorToolbar extends StatelessWidget {
  final StoryTextViewController controller;

  const StoryTextEditorToolbar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          switch (controller.selectorEditorIndex.value) {
            case StoryTextEditor.font:
              return const StoryTextFontWidget();
            case StoryTextEditor.style:
              return const StoryTextFontStyle();
            case StoryTextEditor.color:
              return const StoryTextFontColor();
            case StoryTextEditor.opacity:
              return StoryTextFontOpacity(
                  progressValue: controller.selectedTextOpacity,
                  min: 0.0,
                  max: 1.0);
            // case StoryTextEditor.textSize:

            // return StoryTextFontOpacity(
            //     progressValue: controller.selectedFontSize,
            //     min: AppRes.minFontSize,
            //     max: AppRes.maxFontSize);
          }
        }),
        Container(
          decoration: ShapeDecoration(
            color: blackPure(Get.context!).withValues(alpha: 1),
            shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.zero),
          ),
          padding: const EdgeInsets.all(10.0),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: controller.editorList.map((editor) {
                return Obx(() {
                  final isSelected =
                      controller.selectorEditorIndex.value == editor;
                  return StoryTextImageWithText(
                    onTap: () => controller.onEditorTap(editor),
                    image: editor.image,
                    text: editor.title,
                    isSelect: isSelected,
                  );
                });
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}

class StoryTextImageWithText extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback onTap;
  final bool isSelect;

  const StoryTextImageWithText({
    super.key,
    required this.image,
    required this.text,
    required this.onTap,
    required this.isSelect,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelect ? whitePure(context) : textLightGrey(context);
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(image, width: 30, height: 30, color: color),
          Text(text,
              style:
                  TextStyleCustom.outFitRegular400(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}

class TextWidgetData {
  String id;
  String text;
  double top, left, fontSize, fontScale, fontAngle, opacity;
  GoogleFontFamily? googleFontFamily;
  Color fontColor;
  FontAlign fontAlign;

  TextWidgetData({
    this.text = '',
    this.top = 75,
    this.left = 9,
    this.fontSize = AppRes.minFontSize,
    this.fontScale = 1.0,
    this.fontAngle = 0.0,
    this.googleFontFamily,
    this.fontColor = Colors.white,
    this.fontAlign = FontAlign.center,
    this.opacity = 1,
  }) : id = const Uuid().v1();
}
