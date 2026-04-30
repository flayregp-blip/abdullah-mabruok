import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/widget/no_internet_sheet.dart';

class InternetConnectionManager {
  InternetConnectionManager._();

  static final instance = InternetConnectionManager._();
  AppLifecycleListener? _appLifecycleListener;

  StreamSubscription<InternetStatus>? listener;

  Future<bool> checkInternetConnection() async {
    bool result = await InternetConnection().hasInternetAccess;
    return result;
  }

  void listenNoInternetConnection() {
    listener?.cancel();
    _appLifecycleListener?.dispose();
    listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      print("Internet Status : $status");
      switch (status) {
        case InternetStatus.connected:
          Get.back();
          break;
        case InternetStatus.disconnected:
          Get.to(() => const NoInternetSheet(),
              transition: Transition.downToUp);
          break;
      }
    });
    _appLifecycleListener = AppLifecycleListener(
      onResume: () {
        listener?.resume();
        Loggers.success('❤️onResume');
      },
      onHide: () {
        listener?.pause();
        Loggers.success('❤️onHide');
      },
      onPause: () {
        listener?.pause();
        Loggers.success('❤️onPause');
      },
    );
  }

  void cancel() {
    listener?.cancel();
    _appLifecycleListener?.dispose();
  }
}
