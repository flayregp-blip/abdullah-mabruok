import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shortzz/common/manager/firebase_notification_manager.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/subscription/subscription_manager.dart';
import 'package:shortzz/common/widget/restart_widget.dart';
import 'package:shortzz/languages/dynamic_translations.dart';
import 'package:shortzz/screen/splash_screen/splash_screen.dart';
import 'package:shortzz/utilities/theme_res.dart';

import 'common/service/network_helper/network_helper.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Loggers.success("Handling a background message: ${message.data}");
  await Firebase.initializeApp();
  if (Platform.isIOS) {
    FirebaseNotificationManager.instance.showNotification(message);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await GetStorage.init('shortzz');

    // Init RevenueCat (handle errors gracefully)
    try {
      await SubscriptionManager.shared.initPlatformState();
    } catch (e, st) {
      Loggers.error('SubscriptionManager init error: $e\n$st');
    }
    (await AudioSession.instance).configure(const AudioSessionConfiguration.speech());

    // Init Ads (ignore async wait if needed)
    MobileAds.instance.initialize();

    NetworkHelper().initialize();

    // Load Translations
    Get.put(DynamicTranslations());

    // Run app
    runApp(const RestartWidget(child: MyApp()));
  } catch (e, st) {
    Loggers.error('Fatal crash during app startup $st');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) =>
          ScrollConfiguration(behavior: MyBehavior(), child: child!),
      translations: Get.find<DynamicTranslations>(),
      locale: Locale(SessionManager.instance.getLang()),
      fallbackLocale: Locale(SessionManager.instance.getFallbackLang()),
      themeMode: ThemeMode.light,
      darkTheme: ThemeRes.darkTheme(context),
      theme: ThemeRes.lightTheme(context),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
