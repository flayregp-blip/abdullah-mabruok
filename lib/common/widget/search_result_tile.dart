import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/common/widget/load_more_widget.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class SearchResultTile extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String title;
  final String description;

  const SearchResultTile(
      {super.key,
      required this.onTap,
      required this.image,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 12.0, right: 12.0, top: 5, bottom: 9),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: bgMediumGrey(context), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Image.asset(image,
                      height: 20, width: 20, color: textLightGrey(context)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyleCustom.outFitMedium500(
                              fontSize: 16, color: textDarkGrey(context))),
                      Text(description,
                          style: TextStyleCustom.outFitLight300(
                              color: textLightGrey(context))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const CustomDivider()
      ],
    );
  }
}

class ImageTextListTile<T> extends StatelessWidget {
  final RxList<T> items;
  final Function(T) onTap;
  final String image;
  final String Function(T) getDisplayText;
  final String Function(T) getDisplayDescription;
  final Future<void> Function()? loadMore;
  final RxBool isLoading;
  final Widget? noDataWidget;

  const ImageTextListTile(
      {super.key,
      required this.items,
      required this.onTap,
      required this.image,
      required this.getDisplayText,
      required this.getDisplayDescription,
      this.loadMore,
      required this.isLoading,
      this.noDataWidget});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return isLoading.value && items.isEmpty
          ? const LoaderWidget()
          : !isLoading.value && items.isEmpty
              ? (noDataWidget ?? NoDataView(showShow: items.isEmpty))
              : LoadMoreWidget(
                  loadMore: loadMore ?? () async {},
                  child: ListView.builder(
                      itemCount: items.length,
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 30),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () => onTap(item),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0, top: 5, bottom: 9),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: bgMediumGrey(context),
                                          shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        image,
                                        height: 20,
                                        width: 20,
                                        color: textLightGrey(context),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(getDisplayText(item),
                                              style: TextStyleCustom
                                                  .outFitMedium500(
                                                      fontSize: 16,
                                                      color: textDarkGrey(
                                                          context))),
                                          Text(getDisplayDescription(item),
                                              style: TextStyleCustom
                                                  .outFitLight300(
                                                      color: textLightGrey(
                                                          context))),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const CustomDivider()
                          ],
                        );
                      }),
                );
    });
  }
}
