import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_bg_circle_button.dart';
import 'package:shortzz/common/widget/custom_page_indicator.dart';
import 'package:shortzz/screen/color_filter_screen/color_filter_screen.dart';
import 'package:shortzz/screen/create_feed_screen/create_feed_screen_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';

class FeedImageView extends StatelessWidget {
  final RxList<ImageWithFilter> files;
  final CreateFeedScreenController controller;

  const FeedImageView(
      {super.key, required this.files, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return files.isEmpty
            ? const SizedBox()
            : SizedBox(
                height: Get.width,
                width: Get.width,
                child: Stack(
                  children: [
                    PageView.builder(
                        itemCount: files.length,
                        onPageChanged: (value) {
                          controller.selectedImageIndex.value = value;
                        },
                        itemBuilder: (context, index) {
                          ImageWithFilter file = files[index];
                          return file.colorFilter.isNotEmpty
                              ? ColorFiltered(
                                  colorFilter:
                                      ColorFilter.matrix(file.colorFilter),
                                  child: _file(file.media.path))
                              : _file(file.media.path);
                        }),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (files.length <
                                  (controller.setting.value?.maxImagesPerPost ??
                                      AppRes.imageLimit))
                                CustomBgCircleButton(
                                    image: AssetRes.icPlus,
                                    onTap: controller.selectImages),
                              const SizedBox(width: 5),
                              CustomBgCircleButton(
                                image: AssetRes.icDelete,
                                onTap: controller.onDeleteSelectedImages,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 33,
                                width: 33 + 20,
                              ),
                              CustomPageIndicator(
                                  length: files.length,
                                  selectedIndex: controller.selectedImageIndex),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: CustomBgCircleButton(
                                  image: AssetRes.icFilter,
                                  onTap: () {
                                    Get.bottomSheet(
                                        ColorFilterScreen(
                                          images: files,
                                          onChanged: (items) {
                                            files.value = items;
                                            files.refresh();
                                          },
                                          mediaType: MediaType.image,
                                        ),
                                        isScrollControlled: true,
                                        ignoreSafeArea: false);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _file(String path) {
    return Image.file(File(path),
        height: Get.width, width: Get.width, fit: BoxFit.cover);
  }
}
