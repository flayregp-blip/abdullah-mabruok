import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CustomPageIndicator extends StatelessWidget {
  final int length;
  final RxInt selectedIndex;

  const CustomPageIndicator(
      {super.key, required this.length, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      width: Get.width / 3,
      child: Row(
        children: List.generate(
          length,
          (index) {
            return Obx(
              () {
                bool isSelected = selectedIndex.value == index;
                return Expanded(
                  child: Container(
                      height: 1.5,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      color: whitePure(context)
                          .withValues(alpha: isSelected ? 1 : .4)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
