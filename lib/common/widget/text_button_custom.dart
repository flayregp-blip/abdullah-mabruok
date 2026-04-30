import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class TextButtonCustom extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Color? backgroundColor;
  final VoidCallback onTap;
  final double? horizontalMargin;
  final double? btnHeight;
  final double? btnWidth;
  final double? fontSize;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? radius;
  final BorderSide? borderSide;
  final Widget? child;

  const TextButtonCustom(
      {super.key,
      required this.onTap,
      required this.title,
      this.titleColor,
      this.backgroundColor,
      this.horizontalMargin,
      this.btnHeight,
      this.padding,
      this.fontSize,
      this.radius,
      this.borderSide,
      this.btnWidth,
      this.margin,
      this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          margin ?? EdgeInsets.symmetric(horizontal: horizontalMargin ?? 15),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: btnHeight ?? 57,
          width: btnWidth,
          padding: padding,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: radius ?? 10, cornerSmoothing: 1),
                  side: borderSide ?? BorderSide.none),
              color: backgroundColor ?? whitePure(context)),
          child: child ??
              Text(
                title.capitalize ?? '',
            style: TextStyleCustom.outFitRegular400(
                color: titleColor ?? textDarkGrey(context),
                fontSize: fontSize ?? 17),
          ),
        ),
      ),
    );
  }
}
