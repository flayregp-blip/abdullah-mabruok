import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/manager/internet_connection_manager.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/common/widget/theme_blur_bg.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class NoInternetSheet extends StatelessWidget {
  const NoInternetSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: scaffoldBackgroundColor(context),
        child: Stack(
          children: [
            const ThemeBlurBg(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 150,
              children: [
                Image.asset(
                  AssetRes.icNoInternet,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                          '${LKey.lost.tr}\n${LKey.connection.tr}'
                              .toUpperCase(),
                          style: TextStyleCustom.unboundedBold700(
                              color: whitePure(context), fontSize: 35)),
                      Text(
                        LKey.noInternetDesc.tr,
                        style: TextStyleCustom.outFitMedium500(
                            color: whitePure(context),
                            fontSize: 20,
                            opacity: 0.8),
                      ),
                      SizedBox(height: AppBar().preferredSize.height * 1.5),
                      TextButtonCustom(
                        onTap: () async {
                          InternetConnectionManager.instance
                              .checkInternetConnection()
                              .then((value) {
                            if (value) {
                              Get.back();
                            }
                          });
                        },
                        title: LKey.refresh.tr,
                        titleColor: whitePure(context),
                        backgroundColor:
                            whitePure(context).withValues(alpha: .3),
                        horizontalMargin: 0,
                      ),
                      SizedBox(height: AppBar().preferredSize.height * .5),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
