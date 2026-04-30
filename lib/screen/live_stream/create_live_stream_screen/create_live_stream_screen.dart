import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/black_gradient_shadow.dart';
import 'package:shortzz/common/widget/custom_back_button.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/gradient_icon.dart';
import 'package:shortzz/common/widget/gradient_text.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/live_stream/create_live_stream_screen/create_live_stream_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CreateLiveStreamScreen extends StatelessWidget {
  const CreateLiveStreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateLiveStreamScreenController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Obx(
            () {
              User? user = controller.myUser.value;
              return controller.localView.value ??
                  CustomImage(
                      size: Size(Get.width, Get.height),
                      cornerSmoothing: 0,
                      radius: 0,
                      image: user?.profilePhoto?.addBaseURL(),
                      fullName: user?.fullname);
            },
          ),
          const Align(
              alignment: Alignment.bottomCenter,
              child: BlackGradientShadow(height: 200)),
          SafeArea(
            child: KeyboardAvoider(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      alignment: AlignmentDirectional.topStart,
                      child: CustomBackButton(
                        image: AssetRes.icClose,
                        height: 30,
                        width: 30,
                        color: whitePure(context),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        onTap: controller.onCloseTap,
                      )),
                  Column(
                    spacing: 10,
                    children: [
                      InkWell(
                        onTap: controller.toggleCamera,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: whitePure(context),
                              shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: GradientIcon(
                            gradient: StyleRes.themeGradient,
                            child: Image.asset(AssetRes.icCameraFlip,
                                width: 26, height: 26),
                          ),
                        ),
                      ),
                      Container(
                        height: 75,
                        decoration: ShapeDecoration(
                          color: whitePure(context).withValues(alpha: .15),
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: 12, cornerSmoothing: 1),
                              side: BorderSide(
                                  color:
                                      whitePure(context).withValues(alpha: .18),
                                  width: 1)),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: controller.titleController,
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: LKey.enterLiveStreamTitle.tr,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              hintStyle: TextStyleCustom.outFitLight300(
                                  fontSize: 17,
                                  color: whitePure(context)
                                      .withValues(alpha: .7))),
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          keyboardType: TextInputType.text,
                          style: TextStyleCustom.outFitRegular400(
                              color: whitePure(context), fontSize: 17),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            bool isChecked = controller.isRestricted.value;
                            return Checkbox(
                              checkColor: textLightGrey(context),
                              fillColor:
                                  const WidgetStatePropertyAll(Colors.white),
                              value: isChecked,
                              shape: RoundedRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: 2, cornerSmoothing: 1)),
                              activeColor: whitePure(context),
                              side: BorderSide.none,
                              onChanged: (bool? value) {
                                controller.isRestricted.value = value ?? false;
                              },
                            );
                          }),
                          Text(
                            LKey.restrictUserRequests.tr,
                            style: TextStyleCustom.outFitLight300(
                                color: whitePure(context), fontSize: 16),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: controller.onStartLive,
                        child: Container(
                          height: 53,
                          decoration: ShapeDecoration(
                              shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                      cornerRadius: 10, cornerSmoothing: 1)),
                              color: whitePure(context)),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          child: GradientText(
                            gradient: StyleRes.themeGradient,
                            LKey.startLive.tr,
                            style: TextStyleCustom.unboundedMedium500(
                                fontSize: 17),
                          ),
                        ),
                      ),
                      SizedBox(height: AppBar().preferredSize.height / 3),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
