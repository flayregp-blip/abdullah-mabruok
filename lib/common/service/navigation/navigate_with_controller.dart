import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/profile_screen/profile_screen.dart';

Future<T?> navigateWithController<T, C extends GetxController>({
  required String tag,
  required C Function() controllerBuilder,
  required Widget Function() screenBuilder,
}) async {
  if (Get.isRegistered<C>(tag: tag)) {
    Get.delete<C>(tag: tag, force: true); // ✅ ensures correct controller type
  }

  Get.put<C>(controllerBuilder(), tag: tag);
  return Get.to<T>(() => screenBuilder(), preventDuplicates: false);
}

class NavigationService {
  static final NavigationService shared = NavigationService._();

  NavigationService._(); // ✅ private constructor

  Future<void> openProfileScreen(User? user,
      {bool isTopBarVisible = true, Function(User? user)? onUserUpdate}) async {
    await Get.to(
        () => ProfileScreen(
            user: user,
            isTopBarVisible: isTopBarVisible,
            onUserUpdate: onUserUpdate),
        preventDuplicates: false);
  }
}
