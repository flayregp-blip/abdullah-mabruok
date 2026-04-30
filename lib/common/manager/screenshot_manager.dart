import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortzz/common/extensions/common_extension.dart';

import 'logger.dart';

class ScreenshotManager {
  /// Capture widget screenshot
  static Future<XFile?> captureScreenshot(GlobalKey screenshotKey) async {
    try {
      RenderRepaintBoundary? boundary = screenshotKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        print('1');
        return null;
      }

      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final Uint8List? imageBytes = byteData?.buffer.asUint8List();
      if (imageBytes == null) {
        print('2');
        return null;
      }

      final localPath = await PlatformPathExtension.localPath;

      final file = File('${localPath}screenshot.png');

      await file.writeAsBytes(imageBytes);
      print(file.path);
      return XFile(file.path);
    } catch (e) {
      Loggers.error('❌ Screenshot failed: $e');
      return null;
    }
  }
}
