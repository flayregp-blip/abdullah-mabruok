import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/widget/confirmation_dialog.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';

class LocationService {
  LocationService._();

  static final instance = LocationService._();

  Future<Position> getCurrentLocation(
      {bool isPermissionDialogShow = false}) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (isPermissionDialogShow) {
        await showServiceDialog();
      }
      return Future.error('Location services are still disabled.');
    }
    permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.denied:
        await Geolocator.requestPermission();
        if (isPermissionDialogShow) {
          await Geolocator.requestPermission().then((value) async {
            if (value != LocationPermission.denied ||
                value != LocationPermission.deniedForever) {
              await showPermissionDialog();
            }
          });
        }
        return Future.error('Location permissions are denied');
      case LocationPermission.deniedForever:
        if (isPermissionDialogShow) {
          showPermissionDialog();
        }
        return Future.error('Location permissions are deniedForever');
      case LocationPermission.whileInUse:
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
        Position position = await getCurrentPosition();

        return position;
    }
  }

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    User? user = SessionManager.instance.getUser();

    final double latitude = position.latitude;
    final double longitude = position.longitude;
    final double userLatitude = user?.lat?.toDouble() ?? 0;
    final double userLongitude = user?.lon?.toDouble() ?? 0;

    // Check if position has changed significantly
    const double locationPrecision = 0.0001; // ~11 meters
    bool hasLocationChanged =
        (latitude - userLatitude).abs() > locationPrecision ||
            (longitude - userLongitude).abs() > locationPrecision;

    if (hasLocationChanged) {
      Future.wait([
        UserService.instance.updateUserDetails(lat: latitude, lon: longitude)
      ]);
    }
    return position;
  }

  Future<void> showPermissionDialog() async {
    Get.bottomSheet(ConfirmationSheet(
      title: LKey.nearbyReelsPermissionTitle.tr,
      description: LKey.nearbyReelsPermissionDescription.tr,
      onTap: () {
        openAppSettings();
      },
    ));
  }

  Future<void> showServiceDialog() async {
    await Get.bottomSheet(ConfirmationSheet(
      title: LKey.locationServicesDisabledTitle.tr,
      description: LKey.locationServicesDisabledDescription.tr,
      onTap: () async {
        await Geolocator.openLocationSettings();
      },
    ));
  }
}
