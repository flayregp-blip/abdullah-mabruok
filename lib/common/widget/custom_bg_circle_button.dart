import 'package:flutter/material.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CustomBgCircleButton extends StatelessWidget {
  final String image;
  final Color? bgColor;
  final Size? size;
  final double? iconSize;
  final VoidCallback? onTap;

  const CustomBgCircleButton({super.key,
    required this.image,
    this.bgColor,
    this.size,
    this.iconSize,
    this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size?.height ?? 33,
        width: size?.width ?? 33,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor ?? whitePure(context).withValues(alpha: .3)),
        child: Image.asset(
          image,
          width: iconSize ?? 20,
          height: iconSize ?? 20,
          color: whitePure(context),
        ),
      ),
    );
  }
}
