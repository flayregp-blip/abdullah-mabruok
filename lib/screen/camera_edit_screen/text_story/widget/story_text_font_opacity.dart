import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class StoryTextFontOpacity extends StatelessWidget {
  final RxDouble progressValue;
  final double min;
  final double max;

  const StoryTextFontOpacity(
      {super.key, required this.progressValue, required this.min, required this.max});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackPure(context),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Obx(
        () => Column(
          children: [
            Text(
              '${(((progressValue.value - min) / (max - min)) * 100).toInt()}%',
              style: TextStyleCustom.outFitRegular400(color: whitePure(context), fontSize: 13),
            ),
            const SizedBox(height: 10),
            Slider(
              value: progressValue.value,
              min: min,
              max: max,
              activeColor: whitePure(context),
              inactiveColor: textDarkGrey(context),
              onChanged: (value) {
                progressValue.value = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
