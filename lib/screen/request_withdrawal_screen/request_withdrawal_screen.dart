import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/custom_drop_down.dart';
import 'package:shortzz/common/widget/privacy_policy_text.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/common/widget/text_field_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/request_withdrawal_screen/request_withdrawal_screen_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class RequestWithdrawalScreen extends StatelessWidget {
  const RequestWithdrawalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestWithdrawalScreenController());
    return Scaffold(
        body: Column(
      children: [
        CustomAppBar(title: LKey.requestWithdrawal.tr),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: bgLightGrey(context)),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Obx(
                                () => Text(
                                  (controller.myUser.value?.coinWallet ?? 0).numberFormat,
                                  style: TextStyleCustom.outFitExtraBold800(
                                      color: textDarkGrey(context), fontSize: 28),
                                ),
                              ),
                              Text(LKey.coinBalance.tr,
                                  style: TextStyleCustom.outFitLight300(
                                      color: textLightGrey(context))),
                            ],
                          ),
                          Text(AppRes.equal,
                              style: TextStyleCustom.outFitSemiBold600(
                                  color: textDarkGrey(context), fontSize: 26)),
                          Column(
                            children: [
                              Text(
                                controller.myUser.value
                                        ?.coinEstimatedValue(
                                            controller.settings.value?.coinValue?.toDouble())
                                        .currencyFormat ??
                                    '',
                                style: TextStyleCustom.outFitExtraBold800(
                                    color: textDarkGrey(context), fontSize: 28),
                              ),
                              Text(
                                LKey.estimatedValue.tr,
                                style: TextStyleCustom.outFitLight300(
                                  color: textLightGrey(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: bgGrey(context),
                      height: 29,
                      alignment: Alignment.center,
                      child: Obx(
                        () => Text(
                          '${LKey.currentValue.tr} : ${(controller.settings.value?.coinValue ?? 0).currencyFormat}'
                          ' ${AppRes.slash} ${LKey.coin.tr} ',
                          style: TextStyleCustom.outFitLight300(
                              color: textLightGrey(context), fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              TextFieldCustom(
                onChanged: controller.onChanged,
                controller: controller.amountController,
                title: LKey.amount.tr,
                isPrefixIconShow: true,
                hintText: LKey.enterCoinAmount.tr,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // Allow only numbers
                  LengthLimitingTextInputFormatter(
                      (controller.myUser.value?.coinWallet?.toInt() ?? 0)
                          .toString()
                          .length), // Dynamic limit
                ],
                prefixIcon: Container(
                    height: 49,
                    width: 49,
                    color: textDarkGrey(context),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        right: TextDirection.ltr == Directionality.of(context) ? 13 : 0,
                        left: TextDirection.rtl == Directionality.of(context) ? 13 : 0),
                    child: Image.asset(AssetRes.icCoin, width: 23, height: 23)),
              ),
              Obx(
                () => TextFieldCustom(
                  controller: controller.estimatedAmountController.value,
                  title: LKey.estimatedAmount.tr,
                  enabled: false,
                  hintText: '',
                  isPrefixIconShow: true,
                  prefixIcon: Container(
                      height: 49,
                      width: 49,
                      color: textDarkGrey(context),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          right: TextDirection.ltr == Directionality.of(context) ? 13 : 0,
                          left: TextDirection.rtl == Directionality.of(context) ? 13 : 0),
                      child: Text(
                        controller.settings.value?.currency ?? AppRes.currency,
                        style:
                            TextStyleCustom.outFitLight300(fontSize: 20, color: whitePure(context)),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 5, right: 20),
                child: Text(LKey.selectGateway.tr,
                    style: TextStyleCustom.outFitRegular400(
                        color: textDarkGrey(context), fontSize: 17)),
              ),
              Obx(() {
                var listFromApi = (controller.settings.value?.redeemGateways ?? [])
                    .map((e) => e.title ?? '')
                    .toList();
                var redeemGateways =
                    listFromApi.isEmpty ? [AppRes.emptyGatewayMessage] : listFromApi;
                if (listFromApi.isNotEmpty) {
                  controller.selectedGateway.value = listFromApi.first;
                }
                return CustomDropDownBtn<String>(
                    items: redeemGateways,
                    selectedValue: controller.selectedGateway.value.isEmpty
                        ? redeemGateways.first
                        : controller.selectedGateway.value,
                    getTitle: (value) => value,
                    onChanged: (value) {
                      controller.selectedGateway.value = value ?? '';
                    },
                    bgColor: bgLightGrey(context),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    isExpanded: true,
                    height: 48,
                    style: TextStyleCustom.outFitLight300(
                        color: textLightGrey(context), fontSize: 17));
              }),
              const SizedBox(height: 10),
              TextFieldCustom(
                height: 120,
                controller: controller.accountDetailsController,
                title: LKey.accountDetails.tr,
                hintText: '',
              ),
              const SizedBox(height: 40),
              TextButtonCustom(
                onTap: controller.onSubmit,
                title: LKey.submit.tr,
                horizontalMargin: 15,
                backgroundColor: textDarkGrey(context),
                titleColor: whitePure(context),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  child: const PrivacyPolicyText()),
            ],
          ),
        ))
      ],
    ));
  }
}
