import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/screenshot_manager.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/manager/share_manager.dart';
import 'package:shortzz/model/user_model/user_model.dart';

class QrCodeScreenController extends BaseController {
  final GlobalKey screenshotKey = GlobalKey();
  User? myUser = SessionManager.instance.getUser();
  RxString shareLink = ''.obs;

  @override
  onInit() {
    super.onInit();

    shareLink.value = ShareManager.shared.getLink(key: ShareKeys.user, value: myUser?.id ?? 0);
  }

  /// Save screenshot to gallery
  Future<void> saveGalleryImage(String type) async {
    XFile? image = await ScreenshotManager.captureScreenshot(screenshotKey);
    if (image == null) {
      Loggers.error('❌ Failed to capture screenshot.');
      return;
    }
    if (type == 'save') {
      try {
        await Gal.putImage(image.path);
        showSnackBar('Image saved successfully.');
        Loggers.success('✅ Image saved at: ');
      } on GalException catch (e) {
        Loggers.error('❌ Failed to save image.$e');
        showSnackBar(e.type.message);
      }
    } else {
      shareQrCode(image.path);
    }
  }

  void shareQrCode(String path) async {
    final context = Get.context!;

    final box = context.findRenderObject() as RenderBox?;
    final origin = box!.localToGlobal(Offset.zero) & box.size;

    final params = ShareParams(files: [XFile(path)], title: myUser?.username ?? '', sharePositionOrigin: origin);
    try {
      final result = await SharePlus.instance.share(params);
      if (result.status == ShareResultStatus.success) {
        Loggers.success('Thank you for sharing the picture!');
      }
    } catch (e) {
      Loggers.error('❌ Failed to save image.$e');
    }
  }
}
