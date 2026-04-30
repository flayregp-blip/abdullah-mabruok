import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/manager/haptic_manager.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CustomToggle extends StatefulWidget {
  final RxBool isOn;
  final Function(bool value)? onChanged;

  const CustomToggle({super.key, required this.isOn, this.onChanged});

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  RxBool isOn = false.obs;

  @override
  void initState() {
    super.initState();
    isOn.value = widget.isOn.value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onChanged != null
          ? () {
              widget.onChanged?.call(!isOn.value);
              isOn.value = !isOn.value;
              setState(() {});
              HapticManager.shared.light();
            }
          : () {},
      child: Obx(
        () => AnimatedContainer(
          height: 25,
          width: 37,
          decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(cornerRadius: 30)),
              gradient: isOn.value
                  ? StyleRes.themeGradient
                  : StyleRes.textLightGreyGradient()),
          alignment: isOn.value
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 3),
          duration: const Duration(milliseconds: 300),
          child: Container(
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: whitePure(context))),
        ),
      ),
    );
  }
}
