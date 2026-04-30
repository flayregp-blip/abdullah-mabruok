import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/common/widget/custom_tab_switcher.dart';
import 'package:shortzz/common/widget/load_more_widget.dart';
import 'package:shortzz/common/widget/post_list.dart';
import 'package:shortzz/common/widget/reel_list.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/location_screen/location_screen_controller.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LocationScreen extends StatelessWidget {
  final LatLng latLng;
  final String placeTitle;

  const LocationScreen(
      {super.key, required this.latLng, required this.placeTitle});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
        LocationScreenController(latLng.obs, placeTitle.obs),
        tag: DateTime.now().millisecondsSinceEpoch.toString());

    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => GoogleMap(
                onTap: controller.onMapTap,
                initialCameraPosition:
                    CameraPosition(target: latLng, zoom: 14.4746),
                onMapCreated: controller.onMapCreated,
                markers: controller.marker.values.toSet(),
                compassEnabled: false),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: Get.back,
                  child: Container(
                    width: 37,
                    height: 37,
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: whitePure(context),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: blackPure(context).withValues(alpha: .15),
                            offset: const Offset(0, 4),
                            blurRadius: 11.6)
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(AssetRes.icClose,
                        color: textLightGrey(context), height: 20, width: 20),
                  ),
                ),
                Expanded(
                  child: SizedBox.expand(
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.6,
                      maxChildSize: 1,
                      minChildSize: 0.5,
                      builder: (context, scrollController) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: AppBar().preferredSize.height),
                          decoration: BoxDecoration(
                            color: whitePure(context),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                  color: blackPure(context)
                                      .withValues(alpha: 0.15),
                                  offset: const Offset(0, 4),
                                  blurRadius: 11.6)
                            ],
                          ),
                          child: ClipSmoothRect(
                            radius: const SmoothBorderRadius.vertical(
                                top: SmoothRadius(
                                    cornerRadius: 40, cornerSmoothing: 1)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Make customWidget draggable
                                // Ensuring customWidget allows dragging of DraggableScrollableSheet
                                SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: scrollController,
                                    child: customWidget(context, controller)),
                                // Scrollable content
                                Expanded(
                                  child: LoadMoreWidget(
                                    loadMore: controller.fetchMoreData,
                                    child: ListView(
                                      controller: scrollController,
                                      children: [
                                        ExpandablePageView(
                                          controller: controller.pageController,
                                          onPageChanged: (value) {
                                            controller.selectedTabIndex.value =
                                                value;
                                          },
                                          children: [
                                            ReelList(
                                                pageType: ReelPageType.location,
                                                hashTag: "${latLng.latitude}/${latLng.longitude}",
                                                onFetchMoreData:
                                                    controller.fetchReels,
                                                shrinkWrap: true,
                                                reels: controller.reels,
                                                isLoading:
                                                    controller.isReelLoading),
                                            PostList(
                                              shrinkWrap: true,
                                              posts: controller.posts,
                                              isLoading:
                                                  controller.isPostLoading,
                                              onFetchMoreData:
                                                  controller.fetchPosts,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget customWidget(
      BuildContext context, LocationScreenController controller) {
    return Container(
      height: 155,
      color: whitePure(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomDivider(
                color: bgGrey(context),
                margin: const EdgeInsets.only(top: 10, bottom: 15),
                height: 1,
                width: 100),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.placeTitle.value,
                      style: TextStyleCustom.unboundedSemiBold600(
                          color: textDarkGrey(context), fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${controller.latLng.value.getDistance} ${LKey.km.tr}',
                      style: TextStyleCustom.outFitLight300(
                          color: textLightGrey(context), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomTabSwitcher(
            items: [LKey.reels.tr, LKey.feed.tr],
            onTap: (index) {
              controller.onPageChanged(index);
              controller.pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            },
            selectedIndex: controller.selectedTabIndex,
            margin: const EdgeInsets.all(15),
          )
        ],
      ),
    );
  }
}
