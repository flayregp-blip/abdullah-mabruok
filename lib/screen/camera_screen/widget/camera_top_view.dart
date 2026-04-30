import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/confirmation_dialog.dart';
import 'package:shortzz/common/widget/custom_border_round_icon.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/camera_screen/camera_screen.dart';
import 'package:shortzz/screen/camera_screen/camera_screen_controller.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/widget/members_sheet.dart';
import 'package:shortzz/screen/selected_music_sheet/selected_music_sheet_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CameraTopView extends StatelessWidget {
  final CameraScreenType cameraType;

  const CameraTopView({super.key, required this.cameraType});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CameraScreenController>();
    final isReelType = cameraType == CameraScreenType.post;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close button
          CustomBorderRoundIcon(
            image: AssetRes.icClose,
            onTap: controller.onBackFromScreen,
          ),

          // Music info section
          Flexible(
            child: _buildMusicInfoSection(controller, isReelType, context),
          ),

          // Action buttons
          _buildActionButtons(controller),
        ],
      ),
    );
  }

  Widget _buildMusicInfoSection(
    CameraScreenController controller,
    bool isReelType,
    BuildContext context,
  ) {
    return SelectedMusicView(
      selectedMusic: controller.selectedMusic,
      isReelType: isReelType,
      onDeleteMusic: controller.onDeleteMusic,
      onMusicTap: controller.onSelectedMusicTap,
    );
  }

  Widget _buildActionButtons(CameraScreenController controller) {
    return Obx(() {
      final isTorchOn = controller.isTorchOn.value;
      final isSelectedMusicEmpty = controller.selectedMusic.value == null;
      final shouldStartRecording = controller.isStartingRecording.value;

      return Column(
        spacing: 15,
        children: [
          // Flash toggle
          CustomBorderRoundIcon(
            onTap: controller.onToggleFlash,
            image: isTorchOn ? AssetRes.icNoFlash : AssetRes.icFlash,
          ),

          // Camera flip (hidden during recording)
          if (!shouldStartRecording)
            CustomBorderRoundIcon(
              onTap: controller.onToggleCamera,
              image: AssetRes.icCameraFlip,
            ),

          // Music button (hidden when music is selected)
          if (isSelectedMusicEmpty)
            CustomBorderRoundIcon(
              onTap: controller.onMusicTap,
              image: AssetRes.icMusic,
            ),

          if (controller.isDeepAr)
            // Filter toggle
            CustomBorderRoundIcon(
              image: AssetRes.icStar,
              onTap: controller.onEffectToggle,
            ),
        ],
      );
    });
  }
}

class SelectedMusicView extends StatelessWidget {
  final Rx<SelectedMusic?> selectedMusic;
  final bool isReelType;
  final VoidCallback onDeleteMusic;
  final Function(SelectedMusic? music) onMusicTap;

  const SelectedMusicView({
    super.key,
    required this.selectedMusic,
    required this.isReelType,
    required this.onDeleteMusic,
    required this.onMusicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!shouldShowMusicView()) return const SizedBox();

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMusicThumbnailWithDelete(context),
          const SizedBox(width: 10),
          _buildMusicInfo(context),
          const SizedBox(width: 10),
        ],
      );
    });
  }

  bool shouldShowMusicView() {
    return (isReelType || selectedMusic.value != null) &&
        selectedMusic.value?.music != null;
  }

  Widget _buildMusicThumbnailWithDelete(BuildContext context) {
    return InkWell(
      onTap: _showDeleteConfirmation,
      child: SizedBox(
        width: 45,
        height: 45,
        child: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            CustomImage(
              size: const Size(39, 39),
              radius: 5,
              image: selectedMusic.value?.music?.image?.addBaseURL(),
              strokeWidth: 2,
              cornerSmoothing: 1,
              isShowPlaceHolder: true,
            ),
            Positioned(
              top: 0,
              left: -3,
              child: BorderRoundedButton(
                  image: AssetRes.icClose,
                  color: textDarkGrey(context),
                  bgColor: whitePure(context),
                  height: 15,
                  width: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicInfo(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () => onMusicTap(selectedMusic.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedMusic.value?.music?.title ?? '',
              style: TextStyleCustom.outFitMedium500(
                fontSize: 15,
                color: whitePure(context),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              selectedMusic.value?.music?.artist ?? '',
              style: TextStyleCustom.outFitLight300(
                color: whitePure(context),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.bottomSheet(
      ConfirmationSheet(
        title: LKey.deleteMusicTitle.tr,
        description: LKey.deleteMusicMessage.tr,
        onTap: onDeleteMusic,
        positiveText: LKey.delete.tr,
      ),
    );
  }
}
