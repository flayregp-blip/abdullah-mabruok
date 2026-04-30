import 'dart:io';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/duration_extension.dart';
import 'package:shortzz/common/widget/custom_back_button.dart';
import 'package:shortzz/common/widget/custom_bg_circle_button.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/color_filter_screen/widget/color_filtered.dart';
import 'package:shortzz/screen/create_feed_screen/create_feed_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';
import 'package:video_player/video_player.dart';

enum MediaType { image, video }

class ColorFilterScreen extends StatefulWidget {
  final List<ImageWithFilter> images;
  final Function(List<ImageWithFilter> items) onChanged;
  final MediaType mediaType;
  final VideoPlayerController? videoPlayerController;

  const ColorFilterScreen({
    super.key,
    required this.images,
    required this.onChanged,
    required this.mediaType,
    this.videoPlayerController,
  });

  @override
  State<ColorFilterScreen> createState() => _ColorFilterScreenState();
}

class _ColorFilterScreenState extends State<ColorFilterScreen> {
  late final PageController _pageController;
  final RxInt _selectedImageIndex = 0.obs;
  final RxList<ImageWithFilter> _images = <ImageWithFilter>[].obs;
  List<double> _selectedFilter = defaultFilter;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
    _images.assignAll(widget.images);
    _selectedFilter = widget.images.first.colorFilter;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    super.dispose();
  }

  void _applyFilterToAll() {
    if (_images.isEmpty) return;

    final selectedFilter = _images[_selectedImageIndex.value].colorFilter;
    for (var i = 0; i < _images.length; i++) {
      _images[i] = ImageWithFilter(
          media: _images[i].media,
          colorFilter: selectedFilter,
          thumbnail: _images[i].thumbnail);
    }
    _images.refresh();
  }

  void _applyFilterToSelected(int index, List<double> filter) {
    if (index >= _images.length) return;

    _selectedFilter = filter;
    _images[index] = ImageWithFilter(
      media: _images[index].media,
      colorFilter: filter,
      thumbnail: _images[index].thumbnail,
    );
  }

  Widget _buildImagePreview() {
    return SizedBox(
      height: Get.height / 2.5,
      child: Obx(
        () => PageView.builder(
          controller: _pageController,
          itemCount: _images.length,
          onPageChanged: (value) {
            _selectedImageIndex.value = value;
            _selectedFilter = _images[value].colorFilter;
          },
          itemBuilder: (context, index) {
            final imageWithFilter = _images[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ClipSmoothRect(
                  radius:
                      SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1),
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.matrix(imageWithFilter.colorFilter),
                    child: Image.file(
                      File(imageWithFilter.media.path),
                      fit: BoxFit.cover,
                    ),
                  )),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Obx(
      () {
        if (widget.videoPlayerController == null) {
          return const SizedBox();
        }

        final controller = widget.videoPlayerController!;
        final value = controller.value;
        final width = value.size.width;
        final height = value.size.height;

        return Container(
          width: Get.width,
          height: Get.width,
          color: blackPure(context),
          child: Stack(
            alignment: Alignment.center,
            children: [
              FittedBox(
                fit: width < height ? BoxFit.cover : BoxFit.fitWidth,
                child: SizedBox(
                    width: width,
                    height: height,
                    child: ColorFiltered(
                      colorFilter:
                          ColorFilter.matrix(_images.first.colorFilter),
                      child: VideoPlayer(controller),
                    )),
              ),
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 35),
                        CustomBgCircleButton(
                          image: value.isPlaying
                              ? AssetRes.icPause
                              : AssetRes.icPlay,
                          bgColor: textDarkGrey(context).withValues(alpha: .4),
                          size: const Size(65, 65),
                          iconSize: 40,
                          onTap: () {
                            if (value.isPlaying) {
                              controller.pause();
                            } else {
                              controller.play();
                            }
                          },
                        ),
                        Container(
                          height: 35,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: ShapeDecoration(
                            color: textDarkGrey(context).withValues(alpha: .3),
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                cornerRadius: 5,
                                cornerSmoothing: 1,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Text(
                                  value.position.printDuration,
                                  style: TextStyleCustom.outFitMedium500(
                                    color: whitePure(context),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  value:
                                      value.position.inMicroseconds.toDouble(),
                                  min: 0,
                                  max: value.duration.inMicroseconds.toDouble(),
                                  thumbColor: themeAccentSolid(context),
                                  activeColor: whitePure(context),
                                  inactiveColor:
                                      whitePure(context).withValues(alpha: .3),
                                  onChangeStart: (_) => controller.pause(),
                                  onChangeEnd: (_) => controller.play(),
                                  onChanged: (value) {
                                    if (!_isDisposed) {
                                      controller.seekTo(Duration(
                                          microseconds: value.toInt()));
                                    }
                                  },
                                ),
                              ),
                              Container(
                                width: 40,
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text(
                                  value.duration.printDuration,
                                  style: TextStyleCustom.outFitMedium500(
                                    color: whitePure(context),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterThumbnails() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        itemCount: filters.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return Obx(() {
            final isSelected = _selectedFilter == filter.colorFilter;
            final thumbnailPath = widget.mediaType == MediaType.image
                ? _images[_selectedImageIndex.value].media.path
                : (_images.first.thumbnail.path);
            return FilterThumbnail(
              filter: filter,
              isSelected: isSelected,
              onTap: () => _applyFilterToSelected(
                  _selectedImageIndex.value, filter.colorFilter),
              path: thumbnailPath,
              type: widget.mediaType,
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackPure(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SafeArea(
            bottom: false,
            minimum: EdgeInsets.only(top: AppBar().preferredSize.height),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(
                    image: AssetRes.icClose,
                    color: whitePure(context),
                    width: 25,
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                      widget.onChanged.call(_images);
                    },
                    child: Container(
                      height: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: whitePure(context)),
                      ),
                      alignment: const Alignment(0, -0.1),
                      child: Text(
                        LKey.done.tr,
                        style: TextStyleCustom.outFitRegular400(
                          color: whitePure(context),
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          switch (widget.mediaType) {
            MediaType.image => _buildImagePreview(),
            MediaType.video => _buildVideoPreview(),
          },
          SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                if (_images.length > 1)
                  InkWell(
                    onTap: _applyFilterToAll,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: ShapeDecoration(
                        color: whitePure(context),
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 7,
                            cornerSmoothing: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        LKey.applyAll.tr,
                        style: TextStyleCustom.outFitRegular400(
                          color: blackPure(context),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                _buildFilterThumbnails(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterThumbnail extends StatelessWidget {
  final Filters filter;
  final bool isSelected;
  final VoidCallback onTap;
  final String path;
  final MediaType type;

  const FilterThumbnail({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
    required this.path,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 5,
        children: [
          InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(path)),
                        colorFilter: ColorFilter.matrix(filter.colorFilter),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 10,
                        cornerSmoothing: 1,
                      ),
                    ),
                  ),
                  ClipSmoothRect(
                    radius: SmoothBorderRadius(
                      cornerRadius: 10,
                      cornerSmoothing: 0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isSelected
                                ? whitePure(context)
                                : whitePure(context).withValues(alpha: .2),
                            width: 1.5),
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 10,
                          cornerSmoothing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            filter.filterName.capitalizeFirst ?? '',
            style: TextStyleCustom.unboundedRegular400(
              fontSize: 12,
              color: whitePure(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
