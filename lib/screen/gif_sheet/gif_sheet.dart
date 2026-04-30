import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/custom_search_text_field.dart';
import 'package:shortzz/common/widget/load_more_widget.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/giphy/giphy_model.dart';
import 'package:shortzz/screen/gif_sheet/gif_sheet_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

class GifSheet extends StatelessWidget {
  const GifSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GifSheetController>();

    return Container(
      margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2),
      decoration: ShapeDecoration(
          color: whitePure(context),
          shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.vertical(
                  top: SmoothRadius(cornerRadius: 30, cornerSmoothing: 1)))),
      child: Column(
        children: [
          BottomSheetTopView(title: LKey.gif.tr),
          CustomSearchTextField(
            controller: controller.searchTextController,
            onChanged: controller.onChanged,
            hintText:
                LKey.searchGiphy.trParams({'brand_name': AppRes.gifBrandName}),
          ),
          Expanded(child: Obx(
            () {
              bool isTextEmpty = controller.isTextEmpty.value;
              List<GiphyData> items = isTextEmpty
                  ? controller.trendingList
                  : controller.searchingGiphyList;
              bool isLoading = isTextEmpty
                  ? (controller.isTrendingLoading.value && items.isEmpty)
                  : (controller.isSearchLoading.value && items.isEmpty);

              return isLoading
                  ? const LoaderWidget()
                  : NoDataView(
                      showShow: items.isEmpty,
                      child: LoadMoreWidget(
                        loadMore: isTextEmpty
                            ? controller.fetchTrendingGiphy
                            : controller.fetchSearchGiphy,
                        child: GridView.builder(
                          itemCount: items.length,
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  childAspectRatio: 1,
                                  mainAxisExtent: 120,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                          itemBuilder: (context, index) {
                            GiphyData data = items[index];
                            double width = double.parse(
                                data.images?.original?.width ?? '100');
                            double height = double.parse(
                                data.images?.original?.height ?? '100');
                            return CustomImage(
                              size: Size(width, height),
                              fit: BoxFit.contain,
                              radius: 10,
                              isShowPlaceHolder: true,
                              image: data.images?.original?.url,
                              onTap: () {
                                Get.back(result: data.images?.original?.url);
                              },
                            );
                          },
                        ),
                      ),
                    );
            },
          ))
        ],
      ),
    );
  }
}
