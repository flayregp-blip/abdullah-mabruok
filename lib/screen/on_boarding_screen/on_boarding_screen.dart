import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/common/widget/theme_blur_bg.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/screen/on_boarding_screen/on_boarding_screen_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingScreenController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const ThemeBlurBg(),
          // Image View
          Obx(() =>
              OnBoardingTopBGView(index: controller.selectedPage.value, controller: controller)),
          // Text and Description view with button
          Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: Get.height / 1.4,
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.onBoardingData.length,
                    onPageChanged: controller.onPageChanged,
                    itemBuilder: (context, index) {
                      OnBoarding data = controller.onBoardingData[index];
                      return OnBoardingView(
                        title: (data.title ?? "").tr,
                        description: (data.description ?? '').tr,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: Get.width / 3,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.onBoardingData.length,
                      (index) {
                        return Expanded(
                          child: Obx(() {
                            bool isSelected = controller.selectedPage.value == index;
                            return Container(
                                height: 1,
                                constraints: const BoxConstraints(maxWidth: 1),
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                color: whitePure(context).withValues(alpha: isSelected ? 1 : .4));
                          }),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                TextButtonCustom(
                  onTap: controller.onNextTap,
                  title: LKey.next.tr,
                  titleColor: whitePure(context),
                  backgroundColor: whitePure(context).withValues(alpha: .3),
                  horizontalMargin: 40,
                ),
                SizedBox(height: AppBar().preferredSize.height),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingTopBGView extends StatelessWidget {
  final int index;
  final OnBoardingScreenController controller;

  const OnBoardingTopBGView({super.key, required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    double imageHeight = 400;
    return SafeArea(
      bottom: false,
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: CustomImage(
              key: ValueKey<int>(index),
              size: Size(Get.width, imageHeight),
              image: (controller.onBoardingData[index].image ?? '').addBaseURL(),
              radius: 0,
              isShowPlaceHolder: true,
              fit: BoxFit.fitHeight,
              isImageLoaderVisible: false)),
    );
  }
}

class OnBoardingView extends StatelessWidget {
  final String title;
  final String description;

  const OnBoardingView({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 54),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyleCustom.unboundedBlack900(fontSize: 22, color: whitePure(context)),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: AppRes.titleMaxLine,
          ),
          const SizedBox(height: 20),
          Text(
            description,
            style: TextStyleCustom.outFitRegular400(fontSize: 19, color: whitePure(context)),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: AppRes.descriptionMaxLine,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
