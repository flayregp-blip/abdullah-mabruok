import 'dart:io';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/manager/haptic_manager.dart';
import 'package:shortzz/common/widget/confirmation_dialog.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/camera_edit_screen/camera_edit_screen_controller.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/story_text_view_controller.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/widget/text_editor_sheet.dart';
import 'package:shortzz/screen/camera_screen/camera_screen_controller.dart';
import 'package:shortzz/utilities/text_style_custom.dart';

class CameraEditImageView extends StatelessWidget {
  final CameraEditScreenController cameraEditController;

  const CameraEditImageView({super.key, required this.cameraEditController});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoryTextViewController(cameraEditController));
    return Obx(
      () {
        // Retrieve the selected background style once to avoid repetitive computation
        PostStoryContent content = cameraEditController.content.value;
        bool isTextStory = content.type == PostStoryContentType.storyText;
        var gradient = cameraEditController
            .storyGradientColor[cameraEditController.selectedBgIndex.value];
        List<double> filter = cameraEditController.selectedFilter.value;

        return Container(
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1)),
          ),
          child: RepaintBoundary(
            key: controller.previewContainer,
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.matrix(filter),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: ShapeDecoration(
                      shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                              cornerRadius: 10, cornerSmoothing: 1)),
                      // color: content.bgColor,
                      gradient: isTextStory ? gradient : content.bgGradient,
                    ),
                    child: ClipSmoothRect(
                      radius: SmoothBorderRadius(
                          cornerRadius: 10, cornerSmoothing: 1),
                      child: Stack(
                        children: [
                          if (content.type == PostStoryContentType.storyImage)
                            Align(
                                alignment: Alignment.center,
                                child: Image.file(File(content.content ?? ''),
                                    width: double.infinity,
                                    fit: BoxFit.fitWidth)),
                        ],
                      ),
                    ),
                  ),
                ),
                ...controller.textWidgets.asMap().map(
                  (i, element) {
                    return MapEntry(
                        i,
                        DraggableTextWidget(
                          data: element,
                          onUpdate: (updatedData) =>
                              controller.updateTextWidget(i, updatedData),
                          onDelete: () => controller.deleteTextWidget(i),
                        ));
                  },
                ).values,
              ],
            ),
          ),
        );
      },
    );
  }
}

class DraggableTextWidget extends StatefulWidget {
  final TextWidgetData data;
  final Function(TextWidgetData updatedData) onUpdate;
  final VoidCallback onDelete;

  const DraggableTextWidget({
    super.key,
    required this.data,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<DraggableTextWidget> createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<DraggableTextWidget> {
  double _baseFontScale = 1.0;
  double _initialRotationAngle =
      0.0; // Initial rotation angle when scaling starts
  Offset _initialFocalPoint = Offset.zero; // Initial focal point for panning
  Offset _initialPosition =
      Offset.zero; // Position of the text when scaling starts
  final _controller = Get.find<StoryTextViewController>();
  bool _isViewVisible = true;

  void onScaleStart(ScaleStartDetails details) {
    setState(() {
      _baseFontScale = widget.data.fontScale;
      _initialFocalPoint = details.focalPoint;
      _initialPosition = Offset(widget.data.left, widget.data.top);
      _initialRotationAngle = widget.data.fontAngle;
    });
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Update position (panning)
      final Offset delta = details.focalPoint - _initialFocalPoint;
      double leftX = _initialPosition.dx + (delta.dx / 2);
      double topY = _initialPosition.dy + (delta.dy / 2);

      // Update font scale (scaling)
      double fontScale = (_baseFontScale * details.scale).clamp(0.2, 100);

      // Update rotation angle
      double rotationAngle = _initialRotationAngle + details.rotation;

      // Notify parent of changes
      widget.onUpdate(TextWidgetData(
          text: widget.data.text,
          top: topY,
          left: leftX,
          fontSize: widget.data.fontSize,
          fontScale: fontScale,
          fontAngle: rotationAngle,
          fontColor: widget.data.fontColor,
          fontAlign: widget.data.fontAlign,
          googleFontFamily: widget.data.googleFontFamily,
          opacity: widget.data.opacity));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openTextEditor,
      onLongPress: () {
        HapticManager.shared.light();
        Get.bottomSheet(ConfirmationSheet(
          title: LKey.delete.tr,
          description: LKey.deleteTextConfirmation.tr,
          onTap: widget.onDelete,
        ));
      },
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      child: ClipRRect(
        child: Stack(
          children: [
            // Draggable text widget
            Positioned(
              left: widget.data.left,
              top: widget.data.top,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(widget.data.fontAngle)
                  ..scaleByDouble(
                    widget.data.fontScale,
                    widget.data.fontScale,
                    1.0,
                    1.0,
                  ),
                child: Container(
                  width: Get.width - 50,
                  color: Colors.transparent,
                  constraints:
                      const BoxConstraints(minWidth: 100, minHeight: 50),
                  child: Text(
                    _isViewVisible ? widget.data.text : '',
                    style: _getTextStyle(
                        widget.data.googleFontFamily,
                        widget.data.fontSize,
                        widget.data.fontColor,
                        widget.data.opacity),
                    textAlign: widget.data.fontAlign.align,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _getTextStyle(
      GoogleFontFamily? font, double fontSize, Color color, double opacity) {
    return font?.style.copyWith(
          fontSize: fontSize,
          color: color.withValues(alpha: opacity),
        ) ??
        TextStyleCustom.outFitMedium500(
            fontSize: fontSize, color: color, opacity: opacity);
  }

  void openTextEditor() {
    _isViewVisible = false;
    setState(() {});
    Get.bottomSheet<TextWidgetData>(TextEditorSheet(data: widget.data),
            isScrollControlled: true,
            ignoreSafeArea: false,
            // backgroundColor: textVeryLightGrey(context).withValues(alpha: 1),
            enableDrag: false,
            isDismissible: false,
            // barrierColor: textVeryLightGrey(context).withValues(alpha: 1),
            persistent: false)
        .then((value) {
      _isViewVisible = true;
      setState(() {});
      if (value != null) {
        widget.onUpdate(value);
        widget.onDelete();
        _controller.textWidgets.add(value);
      }
    });
  }
}
