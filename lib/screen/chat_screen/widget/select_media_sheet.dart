import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortzz/common/functions/media_picker_helper.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class SelectMediaSheet extends StatelessWidget {
  final Function(MediaFile mediaFile) onSelectMedia;

  const SelectMediaSheet({super.key, required this.onSelectMedia});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2.5),
          decoration: ShapeDecoration(
              shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.vertical(
                top: SmoothRadius(cornerRadius: 40, cornerSmoothing: 1),
              )),
              color: scaffoldBackgroundColor(context)),
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                BottomSheetTopView(title: LKey.selectMedia.tr),
                InkWell(
                  onTap: () async {
                    XFile? file = await MediaPickerHelper.shared
                        .pickImage(source: ImageSource.camera);
                    if (file != null) {
                      onSelectMedia
                          .call(MediaFile(file: file, type: MediaType.image, thumbNail: file));
                    } else {
                      Loggers.error('Image File not found');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    child:
                        Text(LKey.image.tr, style: TextStyleCustom.unboundedLight200(fontSize: 17)),
                  ),
                ),
                const CustomDivider(),
                InkWell(
                  onTap: () async {
                    MediaFile? file = await MediaPickerHelper.shared
                        .pickVideo(source: ImageSource.camera);
                    if (file != null) {
                      onSelectMedia.call(MediaFile(
                          file: file.file,
                          type: MediaType.video,
                          thumbNail: file.thumbNail));
                    } else {
                      Loggers.error('Video File not found');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 20, top: 10),
                    child:
                        Text(LKey.video.tr, style: TextStyleCustom.unboundedLight200(fontSize: 17)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
