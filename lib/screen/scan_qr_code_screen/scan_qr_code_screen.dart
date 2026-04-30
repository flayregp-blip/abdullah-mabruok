import 'dart:io';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as qr;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/functions/media_picker_helper.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/share_manager.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/service/navigation/navigate_with_controller.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({super.key});

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  final MobileScannerController controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal, detectionTimeoutMs: 3000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: LKey.scanQrCode.tr,
            widget: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(LKey.scanQrProfileSearch.tr,
                  style: TextStyleCustom.outFitLight300(
                      color: textLightGrey(context), fontSize: 14)),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                    height: Get.height,
                    child: MobileScanner(
                      controller: controller,
                      onDetect: (result) async {
                        String url = result.barcodes.first.rawValue ?? '';
                        if (url.isNotEmpty) {
                          controller.pause();
                          fetchDetailFromUrl(
                              result.barcodes.first.rawValue ?? '');
                        } else {
                          BaseController.share.showSnackBar('Url Not found');
                        }
                      },
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: whitePure(context),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: onUploadFromGallery,
                      child: Container(
                        height: 58,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: ShapeDecoration(
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: 10, cornerSmoothing: 1)),
                          color: bgMediumGrey(context),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 12,
                          children: [
                            Image.asset(AssetRes.icUploadGallery,
                                width: 28, height: 28),
                            Text(
                              LKey.uploadFromGallery.tr,
                              style: TextStyleCustom.outFitMedium500(
                                  color: textLightGrey(context), fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void fetchDetailFromUrl(String url) async {
    BaseController.share.showLoader();
    ShareManager.shared.getValuesFromURL(
        url: url,
        completion: (key, value) {
          _navigateToProfileScreen(value);
        });
  }

  Future<void> _navigateToProfileScreen(int userId) async {
    User? user = await UserService.instance.fetchUserDetails(userId: userId);
    BaseController.share.stopLoader();
    if (user != null) {
      await NavigationService.shared.openProfileScreen(user);
      controller.start();
    }
  }

  void onUploadFromGallery() async {
    XFile? image =
        await MediaPickerHelper.shared.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final inputImage = qr.InputImage.fromFile(File(image.path));
    final barcodeScanner = qr.BarcodeScanner();

    try {
      final List<qr.Barcode> barcodes =
          await barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        setState(() {
          String scannedData = barcodes.first.rawValue ?? "";
          Loggers.success("Data got: $scannedData");
          fetchDetailFromUrl(scannedData);
        });
      } else {
        Loggers.error("No QR code detected.");
      }
    } catch (e) {
      Loggers.error("Error scanning image: $e");
    } finally {
      barcodeScanner.close();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
