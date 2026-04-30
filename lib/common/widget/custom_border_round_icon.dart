import 'package:flutter/material.dart';
import 'package:shortzz/common/manager/haptic_manager.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CustomBorderRoundIcon extends StatelessWidget {
  final String? image;
  final VoidCallback? onTap;
  final Widget? widget;

  const CustomBorderRoundIcon({super.key, this.image, this.onTap, this.widget});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticManager.shared.light();
        onTap?.call();
      },
      child: Container(
        height: 37,
        width: 37,
        decoration: BoxDecoration(
            color: whitePure(context).withValues(alpha: .20),
            shape: BoxShape.circle,
            border:
                Border.all(color: whitePure(context).withValues(alpha: .25))),
        child: widget ??
            Center(
              child: Image.asset(image!,
                  color: whitePure(context), width: 23, height: 23),
            ),
      ),
    );
  }
}
