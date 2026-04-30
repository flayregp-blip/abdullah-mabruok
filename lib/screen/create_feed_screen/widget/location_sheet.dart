import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/service/api/common_service.dart';
import 'package:shortzz/common/service/location/location_service.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/custom_search_text_field.dart';
import 'package:shortzz/common/widget/search_result_tile.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/location_place_model.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LocationSheet extends StatefulWidget {
  final Function(Places place) onLocationTap;

  const LocationSheet({super.key, required this.onLocationTap});

  @override
  State<LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends State<LocationSheet> {
  RxList<Places> places = <Places>[].obs;
  RxBool isLocationLoading = true.obs;
  RxBool isLocationError = false.obs;

  @override
  void initState() {
    super.initState();
    _fetchInitLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2),
      decoration: ShapeDecoration(
        color: whitePure(context),
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.vertical(
            top: SmoothRadius(cornerRadius: 30, cornerSmoothing: 1),
          ),
        ),
      ),
      child: Column(
        children: [
          BottomSheetTopView(title: LKey.location.tr, sideBtnVisibility: false),
          CustomSearchTextField(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            onChanged: (value) {
              isLocationLoading.value = true;
              DebounceAction.shared.call(() async {
                places.value = [];
                List<Places> _place =
                    await CommonService.instance.searchPlace(title: value);
                places.addAll(_place);
                isLocationLoading.value = false;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(
              () => ImageTextListTile(
                items: places,
                onTap: (p0) {
                  Get.back();
                  widget.onLocationTap(p0);
                },
                image: AssetRes.icLocation,
                getDisplayText: (p0) => p0.title,
                getDisplayDescription: (p0) => p0.description,
                isLoading: isLocationLoading,
                noDataWidget: isLocationError.value
                    ? LocationErrorWidget(
                        showError: isLocationError.value,
                        onCompletion: (position) {
                          searchNearBy(position.latitude, position.longitude);
                        },
                      )
                    : null,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _fetchInitLocation() async {
    Position? position;
    isLocationLoading.value = true;
    try {
      position = await LocationService.instance
          .getCurrentLocation(isPermissionDialogShow: true);
    } catch (e) {
      isLocationError.value = true;
      isLocationLoading.value = false;
    }

    if (position != null) {
      await searchNearBy(position.latitude, position.longitude);
      isLocationLoading.value = false;
    }
  }

  Future<void> searchNearBy(double lat, double lon) async {
    List<Places> _place =
        await CommonService.instance.searchNearBy(lat: lat, lon: lon);
    places.addAll(_place);
  }
}

class LocationErrorWidget extends StatelessWidget {
  final bool showError;
  final Function(Position position) onCompletion;

  const LocationErrorWidget(
      {super.key, required this.showError, required this.onCompletion});

  @override
  Widget build(BuildContext context) {
    if (!showError) return const SizedBox();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LKey.seePlacesNearYou.tr,
          style: TextStyleCustom.outFitMedium500(
            color: textDarkGrey(context),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          LKey.turnOnLocationServicesMessage.tr,
          style: TextStyleCustom.outFitLight300(
            color: textDarkGrey(context),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        TextButtonCustom(
          onTap: () async {
            Position position = await LocationService.instance
                .getCurrentLocation(isPermissionDialogShow: true);
            onCompletion.call(position);
          },
          title: LKey.turnOnLocationServicesButton.tr,
          fontSize: 14,
          backgroundColor: textDarkGrey(context),
          titleColor: whitePure(context),
          radius: 5,
          btnHeight: 35,
          margin: const EdgeInsets.symmetric(horizontal: 40),
        ),
      ],
    );
  }
}
