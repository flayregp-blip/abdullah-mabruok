import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class UserLinkSheet extends StatelessWidget {
  final List<Link> links;

  const UserLinkSheet({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: ShapeDecoration(
              color: whitePure(context),
              shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.vertical(
                    top: SmoothRadius(cornerRadius: 30, cornerSmoothing: 1)),
              )),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                    height: 1,
                    width: Get.width / 4,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    color: bgGrey(context)),
                Column(
                  children: List.generate(
                    links.length,
                    (index) {
                      Link link = links[index];
                      return InkWell(
                        onTap: () {
                          (link.url ?? '').lunchUrlWithHttps;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Row(
                                  children: [
                                    Image.asset(AssetRes.icLink,
                                        color: textDarkGrey(context),
                                        height: 35,
                                        width: 35),
                                    const SizedBox(width: 20),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          link.title ?? '',
                                          style: TextStyleCustom
                                              .unboundedMedium500(
                                                  fontSize: 15,
                                                  color: textDarkGrey(context)),
                                        ),
                                        Text(
                                          link.url ?? '',
                                          style: TextStyleCustom.outFitLight300(
                                              color: textLightGrey(context)),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                              const CustomDivider()
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: AppBar().preferredSize.height / 2),
              ],
            ),
          ),
        )
      ],
    );
  }
}
