import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/widget/custom_back_button.dart';
import 'package:shortzz/common/widget/custom_popup_menu_button.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/coin_wallet_screen/coin_wallet_screen_controller.dart';
import 'package:shortzz/screen/request_withdrawal_screen/request_withdrawal_screen.dart';
import 'package:shortzz/screen/withdrawals_screen/withdrawals_screen.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CoinWalletTopView extends StatelessWidget {
  const CoinWalletTopView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CoinWalletScreenController>();
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight - 50,
                decoration: BoxDecoration(gradient: StyleRes.themeGradient),
                child: SafeArea(
                  minimum: const EdgeInsets.symmetric(vertical: 5),
                  bottom: false,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomBackButton(
                                color: whitePure(context), width: 35),
                            Text(
                              LKey.coinWallet.tr,
                              style: TextStyleCustom.unboundedMedium500(
                                  color: whitePure(context)),
                            ),
                            Visibility(
                              visible: controller.settings?.isWithdrawalOn == 1,
                              replacement: const SizedBox(width: 35),
                              child: CustomPopupMenuButton(
                                  items: [
                                    MenuItem(LKey.withdrawals.tr, () {
                                      Get.to(() => const WithdrawalsScreen());
                                    }),
                                    MenuItem(LKey.requestWithdrawal.tr, () {
                                      Get.to(() =>
                                              const RequestWithdrawalScreen())
                                          ?.then((value) {
                                        controller.fetchData();
                                      });
                                    }),
                                  ],
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: whitePure(context)
                                            .withValues(alpha: .2),
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Image.asset(AssetRes.icMore,
                                            color: whitePure(context),
                                            width: 22,
                                            height: 22)),
                                  )),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Obx(() {
                            User? user = controller.myUser.value;
                            return Text(
                              (user?.coinWallet?.toInt() ?? 0).numberFormat,
                              style: TextStyleCustom.unboundedExtraBold800(
                                  color: whitePure(context), fontSize: 40),
                            );
                          }),
                          Text(
                            LKey.balance.tr,
                            style: TextStyleCustom.outFitLight300(
                                color: whitePure(context).withValues(alpha: .8),
                                fontSize: 18),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Obx(() {
                          User? user = controller.myUser.value;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CoinWalletStatistics(
                                value:
                                    user?.coinCollectedLifetime?.toInt() ?? 0,
                                title: LKey.collected.tr,
                              ),
                              Container(
                                  height: 20,
                                  width: .5,
                                  color: whitePure(context)),
                              CoinWalletStatistics(
                                value: user?.coinGiftedLifetime?.toInt() ?? 0,
                                title: LKey.gifted.tr,
                              ),
                              Container(
                                  height: 20,
                                  width: .5,
                                  color: whitePure(context)),
                              CoinWalletStatistics(
                                value:
                                    user?.coinPurchasedLifetime?.toInt() ?? 0,
                                title: LKey.purchased.tr,
                              ),
                            ],
                          );
                        }),
                      ),
                      const Spacer(),
                      const SizedBox(height: 10),
                      Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              LKey.lifetime.tr,
                              style: TextStyleCustom.outFitLight300(
                                  fontSize: 13, color: whitePure(context)),
                            ),
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          blurRadius: 18,
                          offset: const Offset(0, 4))
                    ]),
                alignment: const Alignment(-0.1, -.1),
                child: Image.asset(AssetRes.icCoin, height: 90, width: 90),
              ))
        ],
      ),
    );
  }
}

class CoinWalletStatistics extends StatelessWidget {
  final String title;
  final int value;

  const CoinWalletStatistics(
      {super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(value.numberFormat,
                style: TextStyleCustom.unboundedMedium500(
                    color: whitePure(context), fontSize: 13)),
            Text(title,
                style: TextStyleCustom.outFitLight300(
                    color: whitePure(context).withValues(alpha: .8),
                    fontSize: 15))
          ],
        ),
      ],
    );
  }
}
