import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:shortzz/screen/edit_profile_screen/widget/add_edit_link_sheet.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class BuildLinkView extends StatelessWidget {
  final EditProfileScreenController controller;

  const BuildLinkView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(LKey.links.tr,
                  style: TextStyleCustom.outFitRegular400(
                      color: textDarkGrey(context), fontSize: 17)),
              const SizedBox(width: 5),
              InkWell(
                  onTap: controller.openAddEditLinkSheet,
                  child: Icon(CupertinoIcons.plus_circle_fill,
                      color: textDarkGrey(context), size: 22))
            ],
          ),
        ),
        const SizedBox(height: 5),
        Obx(
          () => Column(
            children: List.generate(
              controller.links.length,
              (index) {
                Link link = controller.links[index];
                return Container(
                  color: bgLightGrey(context),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              link.title ?? '',
                              style: TextStyleCustom.unboundedMedium500(
                                  color: textDarkGrey(context), fontSize: 15),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              link.url ?? '',
                              style: TextStyleCustom.outFitLight300(
                                  color: textLightGrey(context)),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      PopupMenuButton<LinkType>(
                        onSelected: (value) {
                          controller.handleLinkAction(value, link);
                        },
                        itemBuilder: (BuildContext context) {
                          final menuItems = <LinkType, String>{
                            LinkType.edit: LKey.edit.tr,
                            LinkType.delete: LKey.delete.tr
                          };

                          return menuItems.entries.map((entry) {
                            return PopupMenuItem<LinkType>(
                              value: entry.key,
                              child: Text(
                                entry.value,
                                style: TextStyleCustom.outFitRegular400(
                                    color: textLightGrey(context),
                                    fontSize: 16),
                              ),
                            );
                          }).toList();
                        },
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 10, cornerSmoothing: 1)),
                        popUpAnimationStyle: const AnimationStyle(
                            curve: Curves.linear,
                            duration: Duration(milliseconds: 500)),
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: bgGrey(context)),
                          alignment: Alignment.center,
                          child: Image.asset(AssetRes.icMore,
                              height: 22, width: 22),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
