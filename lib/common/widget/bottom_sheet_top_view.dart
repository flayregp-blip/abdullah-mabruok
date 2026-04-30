import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class BottomSheetTopView extends StatelessWidget {
  final String title;
  final bool sideBtnVisibility;
  final EdgeInsets? margin;

  const BottomSheetTopView(
      {super.key,
      required this.title,
      this.sideBtnVisibility = true,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(top: 10, bottom: 9),
      child: Column(
        children: [
          const CustomDivider(
            width: 130,
            height: 1,
          ),
          Container(
            height: 55,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: sideBtnVisibility
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                if (sideBtnVisibility) const SizedBox(height: 25, width: 25),
                Text(title,
                    style: TextStyleCustom.unboundedRegular400(
                        color: textDarkGrey(context), fontSize: 15)),
                if (sideBtnVisibility)
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close_rounded,
                      size: 25,
                      color: textDarkGrey(context),
                    ),
                  )
              ],
            ),
          ),
          const CustomDivider(height: 1),
        ],
      ),
    );
  }
}
