import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/edit_profile_screen/widget/phone_codes_screen.dart';
import 'package:shortzz/screen/edit_profile_screen/widget/phone_codes_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class TextFieldCustom extends StatefulWidget {
  final bool isPrefixIconShow;
  final Widget? prefixIcon;
  final String title;
  final TextEditingController controller;
  final double? height;
  final String? hintText;
  final Function(String value)? onChanged;
  final bool isError;
  final bool? enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPasswordField;

  const TextFieldCustom(
      {super.key,
      this.isPrefixIconShow = false,
      this.height,
      required this.controller,
      required this.title,
      this.prefixIcon,
      this.hintText,
      this.onChanged,
      this.isError = false,
      this.enabled,
      this.keyboardType,
      this.inputFormatters,
      this.isPasswordField = false});

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  bool isHide = true;
  bool isExpand = false;

  late PhoneCodesScreenController controller;

  @override
  void initState() {
    super.initState();
    isExpand = widget.height != null;
    setState(() {});
    if (Get.isRegistered<PhoneCodesScreenController>()) {
      controller = Get.find<PhoneCodesScreenController>();
    } else {
      controller = Get.put(PhoneCodesScreenController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(widget.title,
              style: TextStyleCustom.outFitRegular400(
                  color: textDarkGrey(context), fontSize: 17)),
        ),
        Container(
          height: widget.height,
          margin: const EdgeInsets.only(top: 8, bottom: 12),
          decoration: BoxDecoration(
              color: widget.isError
                  ? ColorRes.likeRed.withValues(alpha: .1)
                  : bgLightGrey(context),
              border: Border.symmetric(
                horizontal: BorderSide(
                    color: widget.isError
                        ? ColorRes.likeRed : Colors.transparent,
                    width: .5),
              )),
          child: TextField(
            controller: widget.controller,
            enabled: widget.enabled,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            obscureText: widget.isPasswordField && isHide,
            expands: isExpand,
            onChanged: widget.onChanged,
            maxLines: isExpand ? null : 1,
            // Ensure maxLines is null when expands is true
            minLines: isExpand ? null : 1,
            // Ensure minLines is null when expands is true
            style: TextStyleCustom.outFitLight300(
                color: textLightGrey(context), fontSize: 17),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText ?? LKey.enterHere.tr,
                hintStyle: TextStyleCustom.outFitLight300(
                    color: textLightGrey(context), fontSize: 17),
                contentPadding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: isExpand ? 10 : (widget.isPasswordField ? 2 : 0),
                    bottom: isExpand ? 10 : 0),
                suffixIconConstraints: const BoxConstraints(),
                suffixIcon: widget.isPasswordField
                    ? InkWell(
                        onTap: () {
                          isHide = !isHide;
                          setState(() {});
                        },
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 100),
                            child: Image.asset(
                                !isHide ? AssetRes.icHideEye : AssetRes.icEye,
                                height: 24,
                                width: 35,
                                color: textLightGrey(context),
                                key: UniqueKey())),
                      )
                    : null,
                prefixIconConstraints: const BoxConstraints(),
                prefixIcon: widget.isPrefixIconShow
                    ? InkWell(
                        onTap: () {
                          Get.bottomSheet(const PhoneCodesScreen(),
                                  isScrollControlled: true,
                                  ignoreSafeArea: false)
                              .then((value) {
                            controller.searchPhoneCodes('');
                          });
                        },
                        child: FittedBox(
                          child: (widget.prefixIcon ??
                              Container(
                                height: 49,
                                color: textDarkGrey(context),
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    right: TextDirection.ltr ==
                                            Directionality.of(context)
                                        ? 13
                                        : 0,
                                    left: TextDirection.rtl ==
                                            Directionality.of(context)
                                        ? 13
                                        : 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() => Text(
                                        '${controller.selectedCode.value?.countryCode ?? ''} ${controller.selectedCode.value?.phoneCode ?? ''}',
                                        style: TextStyleCustom.outFitLight300(
                                            fontSize: 17,
                                            color: whitePure(context)))),
                                    Icon(Icons.arrow_drop_down,
                                        color: whitePure(context), size: 30)
                                  ],
                                ),
                              )),
                        ),
                      )
                    : null),
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            textAlignVertical:
                widget.isPrefixIconShow ? TextAlignVertical.center : null,
            cursorColor: textLightGrey(context),
          ),
        )
      ],
    );
  }
}
