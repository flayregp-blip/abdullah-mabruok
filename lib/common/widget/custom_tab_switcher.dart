import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CustomTabSwitcher extends StatelessWidget {
  final List<String> items;
  final Function(int index) onTap;
  final RxInt selectedIndex;
  final Widget? widget;
  final int widgetTabIndex;
  final EdgeInsets? margin;
  final Color? selectedFontColor;
  final Color? backgroundColor;

  const CustomTabSwitcher(
      {super.key,
      required this.items,
      required this.onTap,
      required this.selectedIndex,
      this.widget,
      this.widgetTabIndex = -1,
      this.margin,
      this.selectedFontColor,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 45,
        width: double.infinity,
        margin: margin ?? const EdgeInsets.symmetric(vertical: 10),
        decoration: ShapeDecoration(
          color: backgroundColor ?? bgMediumGrey(context),
          shape: SmoothRectangleBorder(
              borderRadius:
                  SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1),
              side: BorderSide(color: bgGrey(context))),
        ),
        padding: const EdgeInsets.all(4),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            // Tab Indicator
            LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedAlign(
                  alignment: Alignment(
                    (selectedIndex * 2 / (items.length - 1)) - 1,
                    // Dynamic alignment
                    0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: constraints.maxWidth / items.length,
                    decoration: ShapeDecoration(
                      shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(
                            cornerRadius: 10 - 2, cornerSmoothing: 1),
                      ),
                      color: whitePure(context),
                    ),
                  ),
                );
              },
            ),
            // Tab Content
            Row(
              children: List.generate(
                items.length,
                (index) {
                  bool isSelected = selectedIndex.value == index;
                  return Expanded(
                    child: InkWell(
                      onTap: () => onTap(index),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            items[index].tr,
                            style: TextStyleCustom.outFitRegular400(
                                color: !isSelected
                                    ? textLightGrey(context)
                                    : (selectedFontColor ??
                                        textDarkGrey(context)),
                                fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          if (widget != null && widgetTabIndex == index) widget!
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
