import 'package:deepar_flutter_plus/deepar_flutter_plus.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retrytech_plugin/retrytech_plugin.dart';
import 'package:shortzz/common/widget/black_gradient_shadow.dart';
import 'package:shortzz/common/widget/custom_border_round_icon.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/screen/camera_screen/camera_screen_controller.dart';
import 'package:shortzz/screen/camera_screen/widget/camera_bottom_view.dart';
import 'package:shortzz/screen/camera_screen/widget/camera_top_view.dart';
import 'package:shortzz/screen/selected_music_sheet/selected_music_sheet_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

enum CameraScreenType { post, story }

class CameraScreen extends StatelessWidget {
  final CameraScreenType cameraType;
  final SelectedMusic? selectedMusic;

  const CameraScreen({super.key, required this.cameraType, this.selectedMusic});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(CameraScreenController(cameraType, selectedMusic.obs));

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: blackPure(context),
        resizeToAvoidBottomInset: false,
        body: Stack(
          alignment: Alignment.center,
          children: [
            _buildCameraPreview(controller),
            const Align(
              alignment: Alignment.bottomCenter,
              child: BlackGradientShadow(
                height: 150,
              ),
            ),
            _buildCameraUI(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview(CameraScreenController controller) {
    return AspectRatio(
      aspectRatio: 0.52,
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 1),
        child: controller.isDeepAr
            ? Obx(
                () {
                  DeepArControllerPlus deepArControllerPlus =
                      controller.deepArControllerPlus.value;
                  return controller.isDeepARInitialized.value
                      ? Transform.scale(
                          scale: deepArControllerPlus.aspectRatio *
                              0.62, //change value as needed
                          child: DeepArPreviewPlus(deepArControllerPlus),
                        )
                      : const LoaderWidget();
                },
              )
            : RetrytechPlugin.shared.cameraView,
      ),
    );
  }

  Widget _buildCameraUI(
      BuildContext context, CameraScreenController controller) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CameraTopView(cameraType: cameraType),
          if (cameraType == CameraScreenType.story)
            _buildTextStoryButton(controller),
          CameraBottomView(cameraType: cameraType),
        ],
      ),
    );
  }

  Widget _buildTextStoryButton(CameraScreenController controller) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: CustomBorderRoundIcon(
          image: AssetRes.icText,
          onTap: controller.onNavigateTextStory,
        ),
      ),
    );
  }
}
