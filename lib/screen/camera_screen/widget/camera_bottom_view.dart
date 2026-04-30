import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_border_round_icon.dart';
import 'package:shortzz/common/widget/dashed_circle_painter.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/screen/camera_screen/camera_screen.dart';
import 'package:shortzz/screen/camera_screen/camera_screen_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CameraBottomView extends StatelessWidget {
  final CameraScreenType cameraType;

  const CameraBottomView({super.key, required this.cameraType});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CameraScreenController>();
    final isReelType = cameraType == CameraScreenType.post;

    return Column(
      children: [
        // Filter/Effect views
        _buildFilterEffectViews(controller),

        // Duration selector (for reels)
        if (isReelType) const _RecordingDurationSelector(),

        // Main control buttons
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Gallery button
              CustomBorderRoundIcon(
                  image: AssetRes.icImage, onTap: controller.onMediaTap),

              // Recording control button
              RecordingControlButton(controller: controller),

              // Stop recording button
              _buildStopRecordingButton(controller),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFilterEffectViews(CameraScreenController controller) {
    return Obx(() {
      if (controller.isEffectShow.value) {
        return _EffectList(controller);
      }
      return const SizedBox();
    });
  }

  Widget _buildStopRecordingButton(CameraScreenController controller) {
    return Obx(() {
      final showStopButton =
          !controller.isRecording.value && controller.isStartingRecording.value;
      return Visibility(
        visible: showStopButton,
        replacement: const SizedBox(width: 37),
        child: CustomBorderRoundIcon(
          image: AssetRes.icCheck,
          onTap: controller.onVideoRecordingStop,
        ),
      );
    });
  }
}

class _EffectList extends StatelessWidget {
  final CameraScreenController controller;

  const _EffectList(this.controller);

  @override
  Widget build(BuildContext context) {
    List<DeepARFilters> deepARFilters =
        controller.appSetting?.deepARFilters ?? [];
    deepARFilters.insert(
        0, DeepARFilters(id: -1, title: 'None', image: AssetRes.icNoFilter));
    return SizedBox(
      height: 89,
      child: ListView.builder(
        itemCount: deepARFilters.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          DeepARFilters effect = deepARFilters[index];

          return InkWell(
            onTap: () => controller.applyARFilterEffect(effect),
            child: Obx(() {
              final isSelected = controller.selectedEffect.value == effect;
              final borderColor =
                  whitePure(context).withAlpha(isSelected ? 255 : 76);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 79,
                height: 89,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Filter thumbnail
                    Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Container(
                        decoration: BoxDecoration(
                          color: whitePure(context),
                          shape: BoxShape.circle,
                        ),
                        child: ClipSmoothRect(
                          radius: SmoothBorderRadius(cornerRadius: 30),
                          child: effect.id == -1
                              ? Image.asset(effect.image ?? '',
                                  height: 36, width: 36)
                              : Image.network(effect.image?.addBaseURL() ?? '',
                                  height: 36, width: 36),
                        ),
                      ),
                    ),

                    // Filter name
                    Text(
                      effect.title ?? '',
                      style: TextStyleCustom.outFitLight300(
                        color: whitePure(context),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class _RecordingDurationSelector extends StatelessWidget {
  const _RecordingDurationSelector();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CameraScreenController>();

    return Obx(() {
      final showSelector = !controller.isStartingRecording.value &&
          controller.isSecondListShow.value;

      if (!showSelector) return const SizedBox();

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
          child: Row(
            children: List.generate(
              controller.secondsList.length,
              (index) => _buildDurationItem(context, controller, index),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDurationItem(
      BuildContext context, CameraScreenController controller, int index) {
    final second = AppRes.secondList[index];

    return Obx(() {
      final isSelected = second == controller.selectedSecond.value;
      final textStyle = TextStyleCustom.outFitRegular400(
          color: whitePure(context), fontSize: 15);

      return InkWell(
        onTap: () => controller.selectedSecond.value = second,
        child: Container(
          height: 29,
          width: 60,
          decoration: isSelected
              ? ShapeDecoration(
                  color: whitePure(context).withAlpha(51),
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(cornerRadius: 30),
                    side: BorderSide(
                        color: whitePure(context).withAlpha(128), width: 0.5),
                  ))
              : null,
          alignment: Alignment.center,
          child: Text('${second}s', style: textStyle),
        ),
      );
    });
  }
}

class RecordingControlButton extends StatelessWidget {
  final CameraScreenController controller;

  const RecordingControlButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: 90,
        height: 90,
        child: GestureDetector(
          onTap: controller.onPlayPauseToggle,
          onLongPressStart: (_) => controller.onPlayPauseToggle(type: 1),
          onLongPressEnd: (_) => controller.onPlayPauseToggle(type: 2),
          child: CustomPaint(
            painter: DashedCirclePainter(
                controller.progress / controller.selectedSecond.value),
            child: Center(
              child: controller.isRecording.value
                  ? _buildPauseIndicator(context)
                  : _buildRecordButton(),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPauseIndicator(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(2, (index) {
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 3),
            child: Container(
              height: 30,
              width: 12,
              decoration: ShapeDecoration(
                color: whitePure(context),
                shape: SmoothRectangleBorder(
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 2, cornerSmoothing: 1),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRecordButton() {
    return Container(
      width: 65,
      height: 65,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
    );
  }
}
