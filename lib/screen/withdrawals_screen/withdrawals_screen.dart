import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/gift_wallet/withdraw_model.dart';
import 'package:shortzz/screen/withdrawals_screen/withdrawals_screen_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class WithdrawalsScreen extends StatelessWidget {
  const WithdrawalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WithdrawalsScreenController());
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: LKey.withdrawals.tr),
          Expanded(child: Obx(
            () {
              return controller.isLoading.value && controller.withdraws.isEmpty
                  ? const LoaderWidget()
                  : NoDataView(
                      showShow: !controller.isLoading.value &&
                          controller.withdraws.isEmpty,
                      child: ListView.builder(
                        itemCount: controller.withdraws.length,
                        padding: const EdgeInsets.only(top: 1),
                        itemBuilder: (context, index) {
                          Withdraw withdraw = controller.withdraws[index];
                          Color statusColor = withdraw.status == 0
                              ? ColorRes.orange
                              : withdraw.status == 1
                                  ? ColorRes.green
                                  : ColorRes.likeRed;
                          return Container(
                            color: bgLightGrey(context),
                            margin: const EdgeInsets.symmetric(vertical: 1),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${AppRes.hash}${withdraw.requestNumber}',
                                              style: TextStyleCustom
                                                  .unboundedSemiBold600(
                                                      color: textDarkGrey(
                                                          context)),
                                            ),
                                            Text(
                                              '${withdraw.gateway} : ${withdraw.account}',
                                              style: TextStyleCustom
                                                  .outFitLight300(
                                                      color: textLightGrey(
                                                          context),
                                                      fontSize: 13),
                                            ),
                                            Text(
                                              (withdraw.createdAt ?? '')
                                                  .formatDate1,
                                              style: TextStyleCustom
                                                  .outFitLight300(
                                                      color: textLightGrey(
                                                          context),
                                                      fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            (double.parse(
                                                    withdraw.amount ?? '0'))
                                                .currencyFormat,
                                            style:
                                                TextStyleCustom.outFitBold700(
                                                    fontSize: 18,
                                                    color:
                                                        textDarkGrey(context)),
                                          ),
                                          const SizedBox(height: 5),
                                          TextButtonCustom(
                                            onTap: () {},
                                            title: withdraw.status == 0
                                                ? LKey.pending.tr
                                                : withdraw.status == 1
                                                    ? LKey.completed.tr
                                                    : LKey.rejected.tr,
                                            btnHeight: 23,
                                            horizontalMargin: 0,
                                            radius: 5,
                                            fontSize: 12,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            backgroundColor: statusColor
                                                .withValues(alpha: .15),
                                            titleColor: statusColor,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: bgGrey(context),
                                  height: 29,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                      '${(withdraw.coins?.toInt() ?? 0).numberFormat} ${LKey.coins.tr} '
                                      ':'
                                      ' ${(withdraw.coinValue ?? 0).currencyFormat} / ${LKey.coin.tr}',
                                      style: TextStyleCustom.outFitLight300(
                                          color: textLightGrey(context))),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
            },
          ))
        ],
      ),
    );
  }
}
