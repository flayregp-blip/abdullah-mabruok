import 'dart:async';
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/common_service.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/service/network_helper/network_helper.dart';
import 'package:shortzz/common/widget/no_internet_sheet.dart';
import 'package:shortzz/common/widget/restart_widget.dart';
import 'package:shortzz/languages/dynamic_translations.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/screen/auth_screen/login_screen.dart';
import 'package:shortzz/screen/dashboard_screen/dashboard_screen.dart';
import 'package:shortzz/screen/on_boarding_screen/on_boarding_screen.dart';
import 'package:shortzz/screen/select_language_screen/select_language_screen.dart';
import 'package:shortzz/utilities/app_res.dart';

class SplashScreenController extends BaseController {
  late StreamSubscription _subscription;
  bool isOnline = true;

  @override
  void onReady() {
    super.onReady();

    Future.wait([fetchSettings()]);

    _subscription = NetworkHelper().onConnectionChange.listen((status) {
      isOnline = status;
      if (isOnline) {
        Get.back();
      } else {
        Get.to(() => const NoInternetSheet(), transition: Transition.downToUp);
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    _subscription.cancel();
  }

  Future<void> fetchSettings() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    bool showNavigate = await CommonService.instance.fetchGlobalSettings();
    if (showNavigate) {
      final translations = Get.find<DynamicTranslations>();
      var setting = SessionManager.instance.getSettings();
      var languages = setting?.languages ?? [];
      List<Language> downloadLanguages = languages.where((element) => element.status == 1).toList();
      if (downloadLanguages.isEmpty) {
        showSnackBar(AppRes.languageAdd, second: 5);
        return;
      }

      var downloadedFiles = await downloadAndParseLanguages(downloadLanguages);

      translations.addTranslations(downloadedFiles);

      var defaultLang = languages.firstWhereOrNull((element) => element.isDefault == 1);

      if (defaultLang != null) {
        SessionManager.instance.setFallbackLang(defaultLang.code ?? 'en');
      }

      RestartWidget.restartApp(Get.context!);
      if (SessionManager.instance.isLogin()) {
        UserService.instance.fetchUserDetails(userId: SessionManager.instance.getUserID()).then((value) {
          if (value != null) {
            Get.off(() => DashboardScreen(myUser: value));
          } else {
            Get.off(() => const LoginScreen());
          }
        });
      } else {
        bool isLanguageSelect = SessionManager.instance.getBool(SessionKeys.isLanguageScreenSelect);
        bool onBoardingShow = SessionManager.instance.getBool(SessionKeys.isOnBoardingScreenSelect);
        if (isLanguageSelect == false) {
          Get.off(() => const SelectLanguageScreen(languageNavigationType: LanguageNavigationType.fromStart));
        } else if (onBoardingShow == false && (setting?.onBoarding ?? []).isNotEmpty) {
          Get.off(() => const OnBoardingScreen());
        } else {
          Get.off(() => const LoginScreen());
        }
      }
    }
  }

  Future<Map<String, Map<String, String>>> downloadAndParseLanguages(List<Language> languages) async {
    const int maxConcurrentDownloads = 3; // Limit concurrent downloads
    final Set<Future<void>> activeDownloads = {}; // Track active downloads
    final languageData = <String, Map<String, String>>{};

    for (var language in languages) {
      if (language.code != null && language.csvFile != null) {
        // Start the download and add it to the active set
        final downloadTask = downloadAndProcessLanguage(language, languageData);
        activeDownloads.add(downloadTask);

        // Limit concurrency
        if (activeDownloads.length >= maxConcurrentDownloads) {
          // Wait for any download to complete
          await Future.any(activeDownloads);

          // Remove completed tasks from the set
          activeDownloads.removeWhere((task) => task == Future.any(activeDownloads));
        }
      }
    }

    // Wait for all remaining downloads to complete
    await Future.wait(activeDownloads);

    return languageData;
  }

  Future<void> downloadAndProcessLanguage(Language language, Map<String, Map<String, String>> languageData) async {
    try {
      final response = await http.get(Uri.parse(language.csvFile?.addBaseURL() ?? ''));
      if (response.statusCode == 200) {
        final csvContent = utf8.decode(response.bodyBytes);
        // Parse the CSV into a map
        final parsedMap = _parseCsvToMap(csvContent);
        languageData[language.code!] = parsedMap;

        Loggers.info('Downloaded and parsed: ${language.code}');
      } else {
        Loggers.error('Failed to download ${language.code}: ${response.statusCode}');
      }
    } catch (e) {
      Loggers.error('Error downloading ${language.code}: $e');
    }
  }

  Map<String, String> _parseCsvToMap(String csvContent) {
    final rows = const CsvToListConverter().convert(csvContent);
    final map = <String, String>{};

    for (var row in rows) {
      if (row.length >= 2) {
        map[row[0].toString()] = row[1].toString();
      }
    }
    return map;
  }
}
