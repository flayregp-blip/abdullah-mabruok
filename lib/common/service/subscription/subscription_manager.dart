import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/utilities/const_res.dart';

bool isPurchaseConfig = false;
RxBool isSubscribe = false.obs;

class SubscriptionManager {
  static var shared = SubscriptionManager();
  List<Package> packages = [];
  List<Package> offering = [];

  Future<void> initPlatformState() async {
    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      if (revenueCatAndroidApiKey.isNotEmpty) {
        configuration = PurchasesConfiguration(revenueCatAndroidApiKey);
        Purchases.setLogLevel(LogLevel.debug);
        await Purchases.configure(configuration);
      }
    } else if (Platform.isIOS) {
      if (revenueCatAppleApiKey.isNotEmpty) {
        configuration = PurchasesConfiguration(revenueCatAppleApiKey);
        Purchases.setLogLevel(LogLevel.debug);
        await Purchases.configure(configuration);
      }
    }
    await checkIsConfigured();
    await fetchOfferings();
  }

  bool checkSubscription(CustomerInfo customerInfo) {
    if (customerInfo.latestExpirationDate == null ||
        customerInfo.latestExpirationDate!.isEmpty) {
      isSubscribe.value = false;
    } else {
      DateTime dt1 =
          DateTime.parse(customerInfo.latestExpirationDate ?? '').toLocal();
      DateTime dt2 = DateTime.now();

      int leftSecond = dt1.difference(dt2).inSeconds;
      log('⏱️ Expire Time : $dt1 == Current Time : $dt2 || Time Left: ${leftSecond > 0 ? leftSecond : 0} seconds');

      if (dt1.compareTo(dt2) < 0) {
        isSubscribe.value = false;
      }
      if (dt1.compareTo(dt2) > 0) {
        isSubscribe.value = true;
      }
    }

    log('🔔 Subscription Status : ${isSubscribe.value ? 'Active' : 'InActive'}');
    return isSubscribe.value;
  }

  Future<void> subscriptionListener() async {
    try {
      Purchases.addCustomerInfoUpdateListener((customerInfo) async {
        int status = checkSubscription(customerInfo) ? 1 : 0;
        User? user = SessionManager.instance.getUser();
        if (user?.isVerify == status) {
          return;
        }
        UserService.instance.updateUserDetails(isVerify: status);
      });
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      log('RevenueCat Error : ${e.message.toString()}');
    }
  }

  Future<void> checkIsConfigured() async {
    isPurchaseConfig = await Purchases.isConfigured;
    log('isPurchaseConfig  :$isPurchaseConfig');
  }

  Future<LogInResult> login(String appUserID) async {
    return await Purchases.logIn(appUserID);
  }

  Future<(Offering?, String?)> fetchOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      // Display current offering with offerings.current
      offering.addAll(offerings.current?.availablePackages
              .where((element) => element.packageType == PackageType.custom) ??
          []);

      packages.addAll(offerings.current?.availablePackages
              .where((element) => element.packageType != PackageType.custom) ??
          []);
      packages
          .sort((a, b) => b.storeProduct.price.compareTo(a.storeProduct.price));

      return (offerings.current, null);
    } on PlatformException catch (e) {
      // Error restoring purchases
      log('Fetch Offering : ${e.message.toString()}');
      return (null, e.message);
    }
  }

  Future<bool?> checkSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return checkSubscription(customerInfo);
    } on PlatformException catch (e) {
      log(e.message.toString());
      // Error fetching purchaser info
    }
    return null;
  }

  Future<bool?> makePurchase(Package package) async {
    try {
      CustomerInfo customerInfo =
          (await Purchases.purchase(PurchaseParams.storeProduct(package.storeProduct))).customerInfo;
      return checkSubscription(customerInfo);
    } on PlatformException catch (e) {
      log("makePurchase $e");

      return null;
    }
  }

  Future<CustomerInfo?> makePurchaseCustom(Package package) async {
    try {
      CustomerInfo info = (await Purchases.purchase(PurchaseParams.storeProduct(package.storeProduct))).customerInfo;
      return info;
    } on PlatformException catch (e) {
      log("makePurchaseCustom: ${e.message}");
      return null;
    }
  }

  Future<bool?> restorePurchase() async {
    try {
      CustomerInfo restoredInfo = await Purchases.restorePurchases();
      return checkSubscription(restoredInfo);
      // ... check restored customerInfo to see if entitlement is now active
    } on PlatformException catch (e) {
      log(e.toString());
      return null;
      // Error restoring purchases
    }
  }
}
