import 'dart:ui';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/utilities/asset_res.dart';

class LiveStreamBlurBackgroundImage extends StatelessWidget {
  const LiveStreamBlurBackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetRes.icBattleView), fit: BoxFit.cover)),
      child: ClipSmoothRect(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 160, sigmaY: 160),
            child: const SizedBox()),
      ),
    );
  }
}
