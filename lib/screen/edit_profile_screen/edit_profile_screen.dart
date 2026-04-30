import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/common/widget/text_field_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:shortzz/screen/edit_profile_screen/widget/build_link_view.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class EditProfileScreen extends StatelessWidget {
  final Function(User? user)? onUpdateUser;

  const EditProfileScreen({super.key, this.onUpdateUser});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileScreenController(onUpdateUser));
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: LKey.editProfile.tr),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 49,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    alignment: AlignmentDirectional.centerStart,
                    color: bgLightGrey(context),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${LKey.userId.tr} : ${controller.userData.value?.id}',
                      style: TextStyleCustom.outFitLight300(
                          fontSize: 17, color: textLightGrey(context)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(LKey.profileImage.tr,
                        style: TextStyleCustom.outFitRegular400(
                            fontSize: 17, color: textDarkGrey(context))),
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 8, bottom: 12),
                    decoration: BoxDecoration(color: bgLightGrey(context)),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerStart,
                    child: InkWell(
                      onTap: controller.onChangeProfileImage,
                      child: Stack(
                        children: [
                          Obx(
                            () => controller.fileProfileImage.value != null
                                ? ClipOval(
                                    child: Image.file(
                                        File(controller
                                                .fileProfileImage.value?.path ??
                                            ''),
                                        height: 86,
                                        width: 86,
                                        fit: BoxFit.cover))
                                : CustomImage(
                                    size: const Size(86, 86),
                                    image: controller
                                        .userData.value?.profilePhoto
                                        ?.addBaseURL(),
                                    fullName:
                                        controller.userData.value?.fullname,
                                  ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 26,
                              width: 26,
                              decoration: BoxDecoration(
                                  color: textDarkGrey(context),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Image.asset(AssetRes.icEdit_1,
                                    width: 22,
                                    height: 22,
                                    color: whitePure(context)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  TextFieldCustom(
                    controller: controller.fullNameController,
                    title: LKey.fullName.tr,
                  ),
                  Obx(() {
                    return TextFieldCustom(
                      controller: controller.usernameController,
                      title: LKey.username.tr,
                      onChanged: controller.checkUsernameAvailability,
                      isError: !controller.isValidUserName.value,
                    );
                  }),
                  TextFieldCustom(
                      controller: controller.bioController,
                      title: LKey.bio.tr,
                      height: 100),
                  TextFieldCustom(
                    controller: controller.emailController,
                    title: LKey.email.tr,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFieldCustom(
                      controller: controller.phoneNumberController,
                      title: LKey.phoneNumber.tr,
                      isPrefixIconShow: true),
                  BuildLinkView(controller: controller)
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.symmetric(vertical: 20),
            child: TextButtonCustom(
              onTap: controller.onSaveTap,
              title: LKey.save.tr,
              backgroundColor: textDarkGrey(context),
              titleColor: whitePure(context),
            ),
          ),
        ],
      ),
    );
  }
}
