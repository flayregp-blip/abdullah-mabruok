import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CustomSearchTextField extends StatelessWidget {
  final BorderSide? borderSide;
  final EdgeInsets? margin;
  final Function(String value)? onChanged;
  final bool? enable;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final TapRegionCallback? onTapOutside;
  final String? hintText;
  final Widget? suffixIcon;

  const CustomSearchTextField(
      {super.key,
      this.borderSide,
      this.margin,
      this.onChanged,
      this.enable,
      this.onTap,
      this.backgroundColor,
      this.controller,
      this.onTapOutside,
      this.hintText,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
            borderRadius:
                SmoothBorderRadius(cornerRadius: 7, cornerSmoothing: 1),
            side: borderSide ?? BorderSide(color: bgGrey(context))),
        color: backgroundColor ?? bgLightGrey(context),
      ),
      child: TextField(
        onTap: onTap,
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            enabled: enable ?? true,
            constraints: const BoxConstraints(maxHeight: 35),
            contentPadding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 13),
            hintText: hintText ?? LKey.searchHere.tr,
            hintStyle: TextStyleCustom.outFitLight300(
                fontSize: 15, color: textLightGrey(context)),
            hintFadeDuration: const Duration(milliseconds: 200),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: suffixIcon),
        cursorHeight: 15,
        style: TextStyleCustom.outFitLight300(
            fontSize: 15, color: textLightGrey(context)),
        onTapOutside: (event) {
          onTapOutside?.call(event);
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onChanged: onChanged,
      ),
    );
  }
}
