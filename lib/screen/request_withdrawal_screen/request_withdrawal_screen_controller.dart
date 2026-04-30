import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/gift_wallet_service.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/general/status_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';

class RequestWithdrawalScreenController extends BaseController {
  Rx<Setting?> settings = Rx<Setting?>(null);
  Rx<User?> myUser = Rx<User?>(null);

  RxString selectedGateway = ''.obs;
  TextEditingController amountController = TextEditingController();
  Rx<TextEditingController> estimatedAmountController =
      Rx(TextEditingController(text: '0'));
  TextEditingController accountDetailsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _fetchLocalData();
  }

  void _fetchLocalData() {
    settings.value = SessionManager.instance.getSettings();
    myUser.value = SessionManager.instance.getUser();
  }

  void onChanged(String value) {
    if (value.isEmpty) {
      estimatedAmountController.value.text = '0';
      return;
    }

    int maxAllowedCoins =
        myUser.value?.coinWallet?.toInt() ?? 0; // Dynamic max value
    int inputValue = int.tryParse(value) ?? 0;

    if (inputValue > maxAllowedCoins) {
      showSnackBar(LKey.youCanNotEnterMoreThanEtc
          .trParams({'coin': maxAllowedCoins.toString()}));
      amountController.text =
          maxAllowedCoins.toString(); // Set max value dynamically
      amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController.text.length),
      );
    } else {
      estimatedAmountController.value.text =
          '${(settings.value?.coinValue?.toDouble() ?? 0) * inputValue}';
    }
  }

  void onSubmit() async {
    if ((settings.value?.redeemGateways ?? []).isEmpty) {
      return showSnackBar(LKey.redeemGatewayNotFound.tr);
    }
    int amount = amountController.text.trim().isEmpty
        ? 0
        : int.parse(amountController.text.trim());

    if (amount <= (settings.value?.minRedeemCoins ?? 0)) {
      return showSnackBar(LKey.redeemMinCoinDescription.tr);
    }

    showLoader();

    StatusModel model = await GiftWalletService.instance
        .submitWithdrawalRequest(
            coins: amountController.text.trim(),
            gateway: selectedGateway.value,
            account: accountDetailsController.text.trim());

    stopLoader();
    if (model.status == true) {
      Get.back();
    }
    myUser.value?.coinWallet = (myUser.value?.coinWallet ?? 0) -
        int.parse(amountController.text.trim());
    SessionManager.instance.setUser(myUser.value);
    showSnackBar(model.message);
  }
}
