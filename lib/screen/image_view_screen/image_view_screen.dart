import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_page_indicator.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ImageViewScreen extends StatefulWidget {
  final List<Images> images;
  final int selectedIndex;
  final Function(int position)? onChanged;
  final String tag;

  const ImageViewScreen({super.key, required this.images, this.selectedIndex = 0, this.onChanged, required this.tag});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  RxInt selectedIndex = 0.obs;
  List<Images> images = [];

  @override
  void initState() {
    super.initState();
    images = widget.images;
    selectedIndex.value = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Get.back();
      },
      direction: DismissiblePageDismissDirection.multi,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            controller: PageController(initialPage: selectedIndex.value),
            onPageChanged: (value) {
              selectedIndex.value = value;
              widget.onChanged?.call(value);
            },
            itemBuilder: (context, index) {
              Images? image = images[index];
              return Hero(
                tag: '${widget.tag}_${image.image}',
                child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(image.image?.addBaseURL() ?? ''),
                  // wantKeepAlive: true,
                  minScale: PhotoViewComputedScale.contained,
                  // initialScale: PhotoViewComputedScale.contained,
                  backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                  maxScale: PhotoViewComputedScale.covered, // or adjust as needed
                ),
              );
            },
          ),
          if (images.length > 1)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomPageIndicator(
                  length: images.length,
                  selectedIndex: selectedIndex,
                ),
              ),
            ),
          SafeArea(
            bottom: false,
            child: GestureDetector(
              onTap: Get.back,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  AssetRes.icBackArrow,
                  height: 20,
                  width: 20,
                  color: whitePure(context),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
