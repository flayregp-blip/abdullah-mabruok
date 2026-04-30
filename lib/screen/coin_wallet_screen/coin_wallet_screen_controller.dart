
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/gift_wallet_service.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/service/subscription/subscription_manager.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';

class CoinWalletScreenController extends BaseController {
  Rx<User?> myUser = Rx<User?>(null);
  RxList<Package> offerings = <Package>[].obs;

  Setting? get settings => SessionManager.instance.getSettings();
  RxList<CoinPlan> coinPlans = <CoinPlan>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    fetchOfferings();
  }

  void fetchData() {
    myUser.value = SessionManager.instance.getUser();
  }

  void fetchOfferings() {
    List<Package> items = SubscriptionManager.shared.offering;
    offerings.addAll(items);
    if (settings?.coinPackages == null) return;

    for (var data in settings!.coinPackages!) {
      if (data.status == 1) {
        for (var element in items) {
          if ([data.appstoreProductId, data.playStoreProductId]
              .contains(element.storeProduct.identifier)) {
            coinPlans.add(CoinPlan(
                data.coinAmount ?? 0,
                data.id ?? -1,
                element.storeProduct.identifier,
                element.storeProduct.priceString));
          }
        }
      }
    }
  }

  void onPurchase(CoinPlan offer) {
    showLoader(barrierDismissible: false);
    Package package = offerings
        .firstWhere((element) => element.storeProduct.identifier == offer.id);
    SubscriptionManager.shared.makePurchaseCustom(package).then((value) async {
      if (value != null) {
        String isoTime = value.nonSubscriptionTransactions.last.purchaseDate;
        DateTime dt = DateTime.parse(isoTime);
        int millis = dt.millisecondsSinceEpoch;
        User? user = await GiftWalletService.instance
            .buyCoins(id: offer.coinPackageId, purchasedAt: millis.toString());
        stopLoader();
        if (user != null) {
          User? user = await UserService.instance
              .fetchUserDetails(userId: myUser.value?.id);
          if (user != null) {
            myUser.value = user;
            SessionManager.instance.setUser(myUser.value);
          }
        }
      } else {
        stopLoader();
      }
    });
  }

}

class CoinPlan {
  int coin;
  int coinPackageId;
  String id;
  String priceString;

  CoinPlan(this.coin, this.coinPackageId, this.id, this.priceString);
}
