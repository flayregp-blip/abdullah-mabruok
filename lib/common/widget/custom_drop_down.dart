import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CustomDropDownBtn<T> extends StatelessWidget {
  final List<T> items;
  final T selectedValue;
  final Function(T?)? onChanged;
  final double height;
  final double? width;
  final bool isExpanded;
  final EdgeInsetsGeometry? padding;
  final TextStyle? style;
  final double? menuMaxHeight;
  final String Function(T) getTitle; // Function to extract title

  final Color? bgColor;

  const CustomDropDownBtn(
      {super.key,
      required this.items,
      required this.selectedValue,
      required this.onChanged,
      required this.getTitle,
      this.height = 37,
      this.width,
      this.isExpanded = false,
      this.padding,
      this.style,
      this.menuMaxHeight,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: ShapeDecoration(
        color: bgColor ?? bgGrey(context),
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(cornerRadius: 5, cornerSmoothing: 1),
        ),
      ),
      alignment: Alignment.center,
      child: DropdownButton<T>(
        value: selectedValue,
        icon: Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AssetRes.icDownArrow_1,
              width: 23,
              height: 20,
              color: textLightGrey(context),
            )),
        dropdownColor: bgColor ?? bgGrey(context),
        style: TextStyleCustom.outFitRegular400(color: textLightGrey(context), fontSize: 15),
        underline: const SizedBox(),
        isDense: true,
        isExpanded: isExpanded,
        padding: padding,
        alignment: Alignment.center,
        onChanged: onChanged,
        menuMaxHeight: menuMaxHeight ?? 120,
        borderRadius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1),
        items: items.map<DropdownMenuItem<T>>((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(getTitle(item), style: style),
          );
        }).toList(),
      ),
    );
  }
}
