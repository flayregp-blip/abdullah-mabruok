
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/widget/gradient_border.dart';
import 'package:shortzz/common/widget/gradient_text.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LevelScreen extends StatelessWidget {
  final UserLevel? userLevels;

  const LevelScreen({super.key, this.userLevels});

  @override
  Widget build(BuildContext context) {
    List<UserLevel> levels =
        SessionManager.instance.getSettings()?.userLevels ?? [];
    levels.sort((a, b) => a.coinsCollection.compareTo(b.coinsCollection));
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(gradient: StyleRes.themeGradient),
            child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10),
                          child: Icon(Icons.arrow_back, color: whitePure(context)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            LKey.levels.tr.toUpperCase(),
                            style: TextStyleCustom.unboundedExtraBold800(
                                fontSize: 44, color: whitePure(context)),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            LKey.gatherMoreCoins.tr,
                            style: TextStyleCustom.outFitRegular400(
                                fontSize: 18, color: whitePure(context)),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LKey.level.tr,
                    style: TextStyleCustom.outFitRegular400(
                        color: textLightGrey(context), fontSize: 15)),
                Text(LKey.collection.tr,
                    style: TextStyleCustom.outFitRegular400(
                        color: textLightGrey(context), fontSize: 15)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: levels.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                UserLevel level = levels[index];
                bool isLevelCurrent = levels[index].level == userLevels?.level;
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: ShapeDecoration(
                      shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                              cornerRadius: 10, cornerSmoothing: 1))),
                  child: GradientBorder(
                    strokeWidth: 2,
                    radius: 10,
                    gradient: isLevelCurrent
                        ? StyleRes.themeGradient
                        : StyleRes.textLightGreyGradient(opacity: .2),
                    child: Container(
                      decoration: ShapeDecoration(
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: 10, cornerSmoothing: 1),
                              side: BorderSide(
                                color:
                                    textLightGrey(context).withValues(alpha: 0),
                              )),
                          color: bgLightGrey(context)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      margin: const EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 60,
                            child: GradientText(
                              '${level.level}.',
                              gradient: isLevelCurrent
                                  ? StyleRes.themeGradient
                                  : StyleRes.textLightGreyGradient(),
                              style: TextStyleCustom.outFitBlack900(
                                  color: textLightGrey(context), fontSize: 35),
                            ),
                          ),
                          SizedBox(
                            width: Get.width / 4,
                            child: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) => (isLevelCurrent
                                      ? StyleRes.themeGradient
                                      : StyleRes.textLightGreyGradient())
                                  .createShader(
                                Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height),
                              ),
                              child: RichText(
                                  text: TextSpan(
                                text: LKey.level.tr,
                                style: TextStyleCustom.outFitRegular400(
                                    color: textLightGrey(context),
                                    fontSize: 17),
                                children: [
                                  TextSpan(
                                      text: '  ${level.level}',
                                      style: TextStyleCustom.outFitBold700(
                                          color: textLightGrey(context),
                                          fontSize: 17))
                                ],
                              )),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 75,
                            alignment: Alignment.center,
                            decoration: !isLevelCurrent
                                ? const BoxDecoration()
                                : ShapeDecoration(
                                    shape: SmoothRectangleBorder(
                                        borderRadius: SmoothBorderRadius(
                                            cornerRadius: 8,
                                            cornerSmoothing: 1)),
                                    gradient: StyleRes.themeGradient),
                            child: !isLevelCurrent
                                ? const SizedBox()
                                : Text(
                                    LKey.you.tr,
                                    style: TextStyleCustom.outFitSemiBold600(
                                        color: whitePure(context),
                                        fontSize: 15),
                                  ),
                          ),
                          SizedBox(
                            width: Get.width / 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(AssetRes.icCoin,
                                    width: 18, height: 18),
                                Text(level.coinsCollection.numberFormat,
                                    style: TextStyleCustom.outFitRegular400(
                                        fontSize: 20,
                                        color: textLightGrey(context))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    onPressed: () {},
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
