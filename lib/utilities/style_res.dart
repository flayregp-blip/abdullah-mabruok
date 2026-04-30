import 'dart:ui' as ui show Gradient;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

class StyleRes {
  static Gradient themeGradient = const LinearGradient(
    colors: [ColorRes.themeGradient1, ColorRes.themeGradient2],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static Gradient textDarkGreyGradient({double opacity = 1}) => LinearGradient(
        colors: [
          textDarkGrey(Get.context!).withValues(alpha: opacity),
          textDarkGrey(Get.context!).withValues(alpha: opacity)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  static Gradient disabledGreyGradient({double opacity = 1}) => LinearGradient(
        colors: [
          ColorRes.disabledGrey.withValues(alpha: opacity),
          ColorRes.disabledGrey.withValues(alpha: opacity)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  static Gradient textLightGreyGradient({double opacity = 1}) => LinearGradient(
        colors: [
          textLightGrey(Get.context!).withValues(alpha: opacity),
          textLightGrey(Get.context!).withValues(alpha: opacity)
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );

  static Shader wavesGradient = ui.Gradient.linear(
    const Offset(70, 50),
    Offset(Get.width / 2, 0),
    [ColorRes.themeGradient1, ColorRes.themeGradient2],
  );
}
