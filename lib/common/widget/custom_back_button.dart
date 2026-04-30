import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CustomBackButton extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final Color? color;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;

  const CustomBackButton(
      {super.key,
      this.height = 20,
      this.width = 20,
      this.onTap,
      this.color,
      this.alignment,
      this.image,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Get.back(),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(3.0),
        child: Image.asset(
          image ?? AssetRes.icBackArrow,
          height: height,
          width: width,
          color: color ?? textDarkGrey(context),
          alignment: alignment ?? Alignment.center,
        ),
      ),
    );
  }
}
