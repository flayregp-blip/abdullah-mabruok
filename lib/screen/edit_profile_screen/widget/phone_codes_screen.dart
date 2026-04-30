import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/countries_model.dart';
import 'package:shortzz/screen/edit_profile_screen/widget/base_select_sheet.dart';
import 'package:shortzz/screen/edit_profile_screen/widget/phone_codes_screen_controller.dart';

class PhoneCodesScreen extends StatelessWidget {
  const PhoneCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PhoneCodesScreenController>();
    return BaseSelectSheet<Country>(
      title: LKey.phoneCode.tr,
      items: controller.filteredCodes,
      selectedItem: controller.selectedCode,
      getDisplayText: (country) => country.countryName,
      getSecondaryText: (country) => country.phoneCode,
      onSelect: (country) => controller.selectCode(country),
      onSearch: controller.searchPhoneCodes,
    );
  }
}
