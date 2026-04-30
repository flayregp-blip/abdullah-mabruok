import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/subscription/subscription_manager.dart';
import 'package:shortzz/model/user_model/user_model.dart';

class SubscriptionScreenController extends BaseController {
  RxList<Package> packages = <Package>[].obs;
  Rx<Package?> selectedPackage = Rx(null);
  Function(User? user)? onUpdateUser;

  SubscriptionScreenController(this.onUpdateUser);

  @override
  void onInit() {
    super.onInit();
    packages.value = SubscriptionManager.shared.packages;
    if (packages.isNotEmpty) {
      selectedPackage.value = SubscriptionManager.shared.packages.first;
    }
  }

  void onMakePurchase() async {
    if (selectedPackage.value != null) {
      showLoader();
      bool? status = await SubscriptionManager.shared.makePurchase(selectedPackage.value!);
      stopLoader();
      if (status == true) {
        User? user = SessionManager.instance.getUser();
        user?.isVerify = 1;
        onUpdateUser?.call(user);
        SessionManager.instance.setUser(user);
        Get.back(result: true);
      }
    }
  }

  void onRestoreSubscription() async {
    showLoader();
    bool? status = await SubscriptionManager.shared.restorePurchase();
    stopLoader();
    if (status == true) {
      Get.back(result: true);
    }
  }

  void onSubscriptionTap(Package package) {
    selectedPackage.value = package;
  }
}
