import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const CustomDivider(
      {super.key,
      this.height,
      this.color,
      this.width,
      this.margin,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1,
      width: width ?? double.infinity,
      color: color ?? Theme.of(context).dividerColor,
      margin: margin,
      padding: padding,
    );
  }
}
