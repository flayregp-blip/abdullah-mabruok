import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class NoDataView extends StatelessWidget {
  const NoDataView(
      {super.key,
      this.title,
      this.description,
      this.child,
      this.showShow = true,
      this.bgColor,
      this.safeAreaTop = false});

  final String? title;
  final String? description;
  final Widget? child;
  final bool showShow;
  final Color? bgColor;
  final bool safeAreaTop;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showShow)
          SafeArea(
              top: safeAreaTop,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 3,
                  children: [
                    Center(
                      child: Text(
                        (title ?? LKey.noData).tr,
                        style: TextStyleCustom.unboundedSemiBold600(
                            color: textLightGrey(context), fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text((description ?? LKey.noContentMessage).tr,
                        style: TextStyleCustom.outFitLight300(
                          color: textLightGrey(context),
                        ),
                        textAlign: TextAlign.center),
                  ],
                ),
              )),
        if (child != null) child!
      ],
    );
  }
}

class NoDataWidgetWithScroll extends StatelessWidget {
  final String title;
  final String description;

  const NoDataWidgetWithScroll(
      {super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NoDataView(safeAreaTop: true, title: title, description: description),
        SingleChildScrollView(
          child: SizedBox(width: double.infinity, height: Get.height),
        ),
      ],
    );
  }
}
