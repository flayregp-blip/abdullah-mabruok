import 'dart:ui';

import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/model/general/countries_model.dart';
import 'package:shortzz/screen/edit_profile_screen/edit_profile_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';

class PhoneCodesScreenController extends BaseController {
  List<Country> allCountries = [];
  RxList<Country> filteredCodes = <Country>[].obs;
  Rx<Country?> selectedCode = Rx(null);
  EditProfileScreenController? editProfileController;

  @override
  void onReady() async {
    super.onReady();
    if (Get.isRegistered<EditProfileScreenController>()) {
      editProfileController = Get.find<EditProfileScreenController>();
    }
    loadCodes();
  }

  void selectCode(Country code) {
    selectedCode.value = code;
  }

  void searchPhoneCodes(String query) {
    query = query.toLowerCase();
    filteredCodes.value = allCountries.where((model) {
      return (model.countryCode.toLowerCase().contains(query)) ||
          (model.countryName.toLowerCase().contains(query)) ||
          (model.phoneCode.contains(query));
    }).toList();
  }

  Future<void> loadCodes() async {
    allCountries = await parseCountries(filePath: AssetRes.countriesCSV);
    filteredCodes.value = allCountries;
    if (editProfileController?.userData.value?.countryCode == null) {
      selectedCode.value = getPhoneCodeFromIP();
    } else {
      selectedCode.value = allCountries.firstWhereOrNull((element) =>
          element.countryCode ==
          editProfileController?.userData.value?.countryCode);
    }
  }

  Country? getPhoneCodeFromIP() {
    return allCountries.firstWhereOrNull((model) {
      return model.countryCode ==
          PlatformDispatcher.instance.locale.countryCode;
    });
  }
}
