import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_back_button.dart';
import 'package:shortzz/common/widget/gradient_text.dart';
import 'package:shortzz/common/widget/privacy_policy_text.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/common/widget/text_field_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/auth_screen/auth_screen_controller.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthScreenController>();
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const CustomBackButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5)),
            const SizedBox(height: 10),
            Expanded(
                child: SingleChildScrollView(
              dragStartBehavior: DragStartBehavior.down,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LKey.signUp.tr.toUpperCase(),
                            style: TextStyleCustom.unboundedBlack900(
                              fontSize: 25,
                              color: textDarkGrey(context),
                            ).copyWith(letterSpacing: -.2)),
                        GradientText(LKey.startJourney.tr.toUpperCase(),
                            gradient: StyleRes.themeGradient,
                            style: TextStyleCustom.unboundedBlack900(
                              fontSize: 25,
                              color: textDarkGrey(context),
                            ).copyWith(letterSpacing: -.2)),
                      ],
                    ),
                  ),
                  TextFieldCustom(
                    controller: controller.fullNameController,
                    title: LKey.fullName.tr,
                  ),
                  TextFieldCustom(
                    controller: controller.emailController,
                    title: LKey.email.tr,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFieldCustom(
                    controller: controller.passwordController,
                    title: LKey.password.tr,
                    isPasswordField: true,
                  ),
                  TextFieldCustom(
                    controller: controller.confirmPassController,
                    title: LKey.reTypePassword.tr,
                    isPasswordField: true,
                  ),
                ],
              ),
            )),
            TextButtonCustom(
                onTap: controller.onCreateAccount,
                title: LKey.createAccount.tr,
                backgroundColor: textDarkGrey(context),
                horizontalMargin: 20,
                titleColor: whitePure(context)),
            SizedBox(height: AppBar().preferredSize.height / 1.2),
            const SafeArea(top: false, maintainBottomViewPadding: true, child: PrivacyPolicyText()),
          ],
        ),
      ),
    );
  }
}

