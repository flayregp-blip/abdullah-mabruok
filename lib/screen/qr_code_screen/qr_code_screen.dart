import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/common/widget/gradient_border.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/qr_code_screen/qr_code_screen_controller.dart';
import 'package:shortzz/screen/share_sheet_widget/share_sheet_widget.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QrCodeScreenController());
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: LKey.myQrCode.tr),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                RepaintBoundary(
                  key: controller.screenshotKey,
                  child: Container(
                    color: whitePure(context),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Column(
                      spacing: 30,
                      children: [
                        Text(LKey.scanCodeToCheckProfile.tr,
                            style: TextStyleCustom.unboundedRegular400(color: textDarkGrey(context), fontSize: 15),
                            textAlign: TextAlign.center),
                        GradientBorder(
                            strokeWidth: 15,
                            radius: 50,
                            gradient: StyleRes.themeGradient,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PrettyQrView.data(
                                  data: controller.shareLink.value,
                                  decoration: const PrettyQrDecoration(
                                    quietZone: PrettyQrQuietZone.modules(3),
                                  ),
                                ),
                                CustomImage(
                                    size: const Size(40, 40),
                                    image: controller.myUser?.profilePhoto?.addBaseURL(),
                                    fullName: controller.myUser?.fullname,
                                    strokeColor: whitePure(context),
                                    strokeWidth: 5)
                              ],
                            )),
                        Column(
                          children: [
                            FullNameWithBlueTick(
                              username: controller.myUser?.username,
                              fontSize: 14,
                              iconSize: 20,
                              isVerify: controller.myUser?.isVerify,
                            ),
                            const SizedBox(height: 2),
                            Text(controller.myUser?.fullname ?? '',
                                style: TextStyleCustom.outFitRegular400(color: textLightGrey(context), fontSize: 16)),
                            const SizedBox(height: 15),
                            Text(controller.myUser?.bio ?? '',
                                style: TextStyleCustom.outFitLight300(color: textLightGrey(context), fontSize: 15),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CustomAssetWithBgButton(
                              onTap: () => controller.saveGalleryImage('save'),
                              image: AssetRes.icDownload,
                              boxSize: 58,
                              iconSize: 30),
                          Text(
                            LKey.save.tr,
                            style: TextStyleCustom.outFitLight300(color: textLightGrey(context), fontSize: 15),
                          )
                        ],
                      ),
                      const SizedBox(width: 54),
                      Column(
                        children: [
                          CustomAssetWithBgButton(
                              onTap: () => controller.saveGalleryImage('share'),
                              image: AssetRes.icShare2,
                              boxSize: 58,
                              iconSize: 30),
                          Text(
                            LKey.share.tr,
                            style: TextStyleCustom.outFitLight300(color: textLightGrey(context), fontSize: 15),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
