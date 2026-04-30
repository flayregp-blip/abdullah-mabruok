import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/common/widget/theme_blur_bg.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/screen/auth_screen/login_screen.dart';
import 'package:shortzz/screen/on_boarding_screen/on_boarding_screen.dart';
import 'package:shortzz/screen/select_language_screen/select_language_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

enum LanguageNavigationType { fromStart, fromSetting }

class SelectLanguageScreen extends StatelessWidget {
  final LanguageNavigationType languageNavigationType;

  const SelectLanguageScreen({super.key, required this.languageNavigationType});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(SelectLanguageScreenController(languageNavigationType));
    return Scaffold(
      body: Stack(
        children: [
          const ThemeBlurBg(),
          SafeArea(
            top: false,
            child: Column(
              children: [
                switch (languageNavigationType) {
                  LanguageNavigationType.fromStart => SafeArea(
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 30),
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              padding: const EdgeInsets.all(15),
                              decoration: ShapeDecoration(
                                  color:
                                      whitePure(context).withValues(alpha: .1),
                                  shape: SmoothRectangleBorder(
                                    borderRadius:
                                        SmoothBorderRadius(cornerRadius: 15),
                                  )),
                              child: Image.asset(AssetRes.icLanguage),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LKey.select.tr.toUpperCase(),
                                  style: TextStyleCustom.unboundedBlack900(
                                      fontSize: 25, color: whitePure(context)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  LKey.language.tr.toUpperCase(),
                                  style: TextStyleCustom.unboundedBlack900(
                                      fontSize: 25,
                                      color: whitePure(context),
                                      opacity: .5),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  LanguageNavigationType.fromSetting => CustomAppBar(
                      title: LKey.languages.tr,
                      titleStyle: TextStyleCustom.unboundedSemiBold600(
                          fontSize: 15, color: whitePure(context)),
                      bgColor: Colors.transparent,
                      iconColor: whitePure(context)),
                },
                Expanded(
                  child: ListView.builder(
                      itemCount: controller.languages.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 25),
                      itemBuilder: (context, index) {
                        Language language = controller.languages[index];
                        return Obx(
                          () {
                            bool isSelected =
                                language == controller.selectedLanguage.value;
                            return RadioGroup<Language?>(
                              groupValue: controller.selectedLanguage.value,
                              onChanged: controller.onLanguageChange,
                              child: Container(
                                height: 60,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                decoration: ShapeDecoration(
                                  shape: SmoothRectangleBorder(
                                    borderRadius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1),
                                    side: isSelected
                                        ? BorderSide(color: whitePure(context))
                                        : const BorderSide(color: Colors.transparent),
                                  ),
                                  color: whitePure(context).withValues(alpha: isSelected ? .3 : .1),
                                ),
                                child: RadioListTile<Language?>(
                                    value: language,
                                    activeColor: whitePure(context),
                                    fillColor: WidgetStatePropertyAll(whitePure(context)),
                                    splashRadius: 0,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    dense: true,
                                    visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      language.localizedTitle ?? '',
                                      style: TextStyleCustom.outFitLight300(fontSize: 15, color: whitePure(context)),
                                    ),
                                    subtitle: Text(
                                      language.title ?? '',
                                      style: TextStyleCustom.outFitMedium500(fontSize: 17, color: whitePure(context)),
                                    )),
                              ),
                            );
                          },
                        );
                      }),
                ),
                if (languageNavigationType == LanguageNavigationType.fromStart)
                  TextButtonCustom(
                    onTap: () {
                      SessionManager.instance.setBool(SessionKeys.isLanguageScreenSelect, true);
                      if ((controller.setting?.onBoarding ?? []).isEmpty) {
                        Get.off(() => const LoginScreen());
                      } else {
                        Get.off(() => const OnBoardingScreen());
                      }
                    },
                    title: LKey.continueText.tr,
                    margin: const EdgeInsets.all(15),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
