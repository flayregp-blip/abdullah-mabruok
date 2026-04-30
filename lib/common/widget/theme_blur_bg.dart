import 'package:flutter/material.dart';
import 'package:shortzz/utilities/asset_res.dart';

class ThemeBlurBg extends StatelessWidget {
  const ThemeBlurBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetRes.icBackground,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
