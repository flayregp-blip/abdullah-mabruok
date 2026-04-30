import 'package:flutter/material.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class FullNameWithBlueTick extends StatelessWidget {
  final Widget? child;
  final double? iconSize;
  final double? fontSize;
  final Color? fontColor;
  final String? icon;
  final String? username;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextStyle? style;
  final int? isVerify;
  final VoidCallback? onTap;
  final double opacity;

  const FullNameWithBlueTick(
      {super.key,
      required this.username,
      this.child,
      this.iconSize,
      this.fontSize,
      this.fontColor,
      this.mainAxisAlignment,
      this.crossAxisAlignment,
      this.icon,
      this.style,
      this.isVerify = 0,
      this.onTap,
      this.opacity = 1});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              username ?? '',
              style: style ??
                  TextStyleCustom.unboundedMedium500(
                      color: fontColor ?? textDarkGrey(context),
                      fontSize: fontSize ?? 11,
                    opacity: opacity,
                  ).copyWith(height: 2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isVerify == 1) const SizedBox(width: 3),
          if (isVerify == 1)
            Image.asset(
              icon ?? AssetRes.icBlueTick,
              height: iconSize ?? 15,
            ),
          const SizedBox(width: 6),
          if (child != null) child!
        ],
      ),
    );
  }
}
