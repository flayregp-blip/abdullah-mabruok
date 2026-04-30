import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class SettingIconTextWithArrow extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? widget;

  const SettingIconTextWithArrow({super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.widget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 47,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: bgLightGrey(context),
        margin: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          children: [
            Image.asset(icon,
                height: 24, width: 24, color: themeAccentSolid(context)),
            const SizedBox(width: 11),
            Expanded(
                child: Text(title.tr,
                    style: TextStyleCustom.outFitRegular400(
                        fontSize: 15, color: textDarkGrey(context)))),
            const SizedBox(width: 11),
            widget ??
                Image.asset(
                  AssetRes.icForwardArrow,
                  width: 24,
                  height: 20,
                  color: textDarkGrey(context),
                )
          ],
        ),
      ),
    );
  }
}
