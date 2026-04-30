import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/privacy_policy_text.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/common/widget/text_field_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/auth_screen/auth_screen_controller.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ForgetPasswordSheet extends StatelessWidget {
  const ForgetPasswordSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthScreenController>();
    return Container(
      height: 400,
      margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2.5),
      decoration: ShapeDecoration(
          shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.vertical(
                  top: SmoothRadius(cornerRadius: 40, cornerSmoothing: 1))),
          color: scaffoldBackgroundColor(context)),
      child: SafeArea(
        minimum: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            BottomSheetTopView(title: LKey.forgetPassword.tr),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFieldCustom(
                      controller: controller.forgetEmailController,
                      title: LKey.email.tr,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    TextButtonCustom(
                        onTap: controller.forgetPassword,
                        title: LKey.forgetPassword.tr,
                        backgroundColor: textDarkGrey(context),
                        titleColor: whitePure(context),
                        margin: const EdgeInsets.all(15)),
                    const PrivacyPolicyText(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
