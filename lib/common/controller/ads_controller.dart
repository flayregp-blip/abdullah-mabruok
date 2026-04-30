import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/manager/ads_manager.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/subscription/subscription_manager.dart';

class AdsController extends BaseController {
  InterstitialAd? interstitialAd;

  @override
  void onInit() {
    super.onInit();
    loadInterstitialAd(); // preload when controller initializes
  }

  Future<void> showInterstitialAdIfAvailable({bool isPopScope = false}) async {
    final setting = SessionManager.instance.getSettings();

    // Check ad status for platform
    final isAdDisabled =
        (Platform.isAndroid && setting?.admobAndroidStatus == 0) ||
            (Platform.isIOS && setting?.admobIosStatus == 0);

    // Early return if ads are disabled or user is subscribed or ad is not loaded
    if (isAdDisabled || isSubscribe.value || interstitialAd == null) {
      if (!isPopScope) {
        Get.back();
      }
      return;
    }
    if (!isPopScope) {
      Get.back();
    }
    await interstitialAd!.show(); // Safe to use `!` after null check
  }

  Future<void> loadInterstitialAd() async {
    if (isSubscribe.value) return;

    AdsManager.instance.loadInterstitialAd(onAdLoaded: (ad) {
      interstitialAd = ad;

      interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd(); // Reload for next time
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd();
        },
      );
    });
  }
}
