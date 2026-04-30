import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/coin_wallet_screen/coin_wallet_screen_controller.dart';
import 'package:shortzz/screen/coin_wallet_screen/widget/coin_wallet_list.dart';
import 'package:shortzz/screen/coin_wallet_screen/widget/coin_wallet_top_view.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CoinWalletScreen extends StatelessWidget {
  const CoinWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CoinWalletScreenController());
    return Scaffold(
      body: Column(
        children: [
          const CoinWalletTopView(),
          const SizedBox(height: 15),
          Text(LKey.coinShop.tr,
              style: TextStyleCustom.unboundedRegular400(
                color: textDarkGrey(context),
                fontSize: 17,
              )),
          const SizedBox(height: 5),
          Text(LKey.rechargeWallet.tr,
              style: TextStyleCustom.outFitLight300(color: textLightGrey(context), fontSize: 17),
              textAlign: TextAlign.center),
          CoinWalletList(controller: controller)
        ],
      ),
    );
  }
}
