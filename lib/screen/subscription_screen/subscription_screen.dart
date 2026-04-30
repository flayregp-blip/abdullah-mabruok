import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shortzz/common/widget/custom_back_button.dart';
import 'package:shortzz/common/widget/gradient_text.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/subscription_screen/subscription_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class SubscriptionScreen extends StatelessWidget {
  final Function(User? user)? onUpdateUser;

  const SubscriptionScreen({super.key, this.onUpdateUser});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionScreenController(onUpdateUser));
    return Scaffold(
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            const Align(
              alignment: AlignmentDirectional.centerStart,
              child: CustomBackButton(
                padding: EdgeInsets.all(10),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  GradientText(LKey.plus.tr,
                      gradient: StyleRes.themeGradient,
                      style:
                          TextStyleCustom.unboundedExtraBold800(fontSize: 44)),
                  const SizedBox(height: 10),
                  Text(LKey.subscribeToPlus.tr,
                      style: TextStyleCustom.outFitRegular400(
                          fontSize: 18, color: textLightGrey(context)),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BuildIconWithText(
                          icon: AssetRes.icNoAds, title: LKey.noAds.tr),
                      const SizedBox(width: 10),
                      BuildIconWithText(
                          icon: AssetRes.icBlueTick,
                          title: LKey.getVerified.tr),
                    ],
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        children: List.generate(
                          controller.packages.length,
                          (index) {
                            Package package = controller.packages[index];

                            return Obx(() {
                              bool isSelected = controller
                                      .selectedPackage.value?.identifier ==
                                  package.identifier;
                              return InkWell(
                                onTap: () =>
                                    controller.onSubscriptionTap(package),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7.5),
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                      shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius(
                                            cornerRadius: 10,
                                            cornerSmoothing: 1),
                                        side: BorderSide(
                                          color: isSelected
                                              ? Colors.transparent
                                              : textLightGrey(context)
                                                  .withValues(alpha: .2),
                                        ),
                                      ),
                                      color: isSelected
                                          ? null
                                          : bgLightGrey(context),
                                      gradient: isSelected
                                          ? StyleRes.themeGradient
                                          : null,
                                      shadows: isSelected
                                          ? [
                                              BoxShadow(
                                                  color: disableGrey(context),
                                                  blurRadius: 10)
                                            ]
                                          : null),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          spacing: 5,
                                          children: [
                                            Text(
                                              package.getDetail.title,
                                              style: TextStyleCustom
                                                  .unboundedMedium500(
                                                      fontSize: 15,
                                                      color: isSelected
                                                          ? whitePure(context)
                                                          : textLightGrey(
                                                              context)),
                                            ),
                                            if (package.getDetail.description
                                                .isNotEmpty)
                                              Text(
                                                package.getDetail.description,
                                                style: TextStyleCustom
                                                    .outFitRegular400(
                                                        color: isSelected
                                                            ? whitePure(context)
                                                            : textLightGrey(
                                                                context)),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        package.storeProduct.priceString,
                                        style:
                                            TextStyleCustom.outFitExtraBold800(
                                                fontSize: 24,
                                                color: isSelected
                                                    ? whitePure(context)
                                                    : textLightGrey(context)),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  TextButtonCustom(
                      onTap: controller.onMakePurchase,
                      title: LKey.subscribeNow.tr,
                      backgroundColor: textDarkGrey(context),
                      titleColor: whitePure(context)),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20.0, top: 40),
                    child: Text(
                      LKey.subscriptionTerms.tr,
                      style: TextStyleCustom.outFitLight300(
                          fontSize: 13, color: textLightGrey(context)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: AppBar().preferredSize.height / 2.5),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class BuildIconWithText extends StatelessWidget {
  final String icon;
  final String title;

  const BuildIconWithText({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 30),
            side: BorderSide(color: bgGrey(context))),
        color: bgMediumGrey(context),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            height: 22,
            width: 28,
            alignment: AlignmentDirectional.centerStart,
          ),
          Text(
            title,
            style: TextStyleCustom.outFitRegular400(
                fontSize: 15, color: textDarkGrey(context)),
          )
        ],
      ),
    );
  }
}

extension RevenueCatProduct on Package {
  SubscriptionDetail get getDetail {
    final StoreProduct product = storeProduct;

    String getTrialDescription() {
      final intro = product.introductoryPrice;
      if (intro == null) return '';
      final count = intro.periodNumberOfUnits;
      return LKey.freeTrialDescription
          .trParams({'count': '$count', 'get_period': getPeriod});
    }

    String getBilledDescription(String unitLabel, int months) {
      final trial = getTrialDescription();
      return trial.isEmpty
          ? months <= 1
              ? ''
              : LKey.subscriptionDescription.trParams(
                  {'price': calculatePrice(months), 'unit_label': unitLabel})
          : trial;
    }

    return switch (packageType) {
      PackageType.unknown || PackageType.custom => SubscriptionDetail(),
      PackageType.lifetime => SubscriptionDetail(
          title: LKey.lifetime.tr,
        ),
      PackageType.annual => SubscriptionDetail(
          title: LKey.annual.tr,
          description: getBilledDescription(LKey.annually.tr, 12)),
      PackageType.sixMonth => SubscriptionDetail(
          title: LKey.sixMonth.tr,
          description: getBilledDescription(LKey.semiAnnually.tr, 6)),
      PackageType.threeMonth => SubscriptionDetail(
          title: LKey.threeMonth.tr,
          description: getBilledDescription(LKey.threeMonths.tr, 3)),
      PackageType.twoMonth => SubscriptionDetail(
          title: LKey.twoMonth.tr,
          description: getBilledDescription(LKey.twoMonths.tr, 2)),
      PackageType.monthly => SubscriptionDetail(
          title: LKey.monthly.tr,
          description: getBilledDescription(LKey.monthly.tr, 1)),
      PackageType.weekly => SubscriptionDetail(
          title: LKey.weekly.tr, description: LKey.giveItATry.tr),
    };
  }

  String calculatePrice(int months) {
    if (months <= 1) return '';
    final perMonth = storeProduct.price / months;
    final currencySymbol = storeProduct.priceString[0];
    return '$currencySymbol${perMonth.toStringAsFixed(2)}';
  }

  String get getPeriod {
    final intro = storeProduct.introductoryPrice;
    final unit = intro?.periodUnit;
    final cycles = intro?.cycles ?? 1;

    return switch (unit) {
      PeriodUnit.day => LKey.day.tr.trPlural(LKey.days.tr, cycles),
      PeriodUnit.week => LKey.week.tr.trPlural(LKey.weeks.tr, cycles),
      PeriodUnit.month => LKey.month.tr.trPlural(LKey.months.tr, cycles),
      PeriodUnit.year => LKey.year.tr.trPlural(LKey.years.tr, cycles),
      _ => '',
    };
  }
}

class SubscriptionDetail {
  String title;
  String description;

  SubscriptionDetail({this.title = '', this.description = ''});
}
