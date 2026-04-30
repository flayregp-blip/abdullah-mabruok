import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/widget/confirmation_dialog.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:video_compress/video_compress.dart';

class MediaPickerHelper {
  static final shared = MediaPickerHelper();
  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>> multipleImages({int? limit}) async {
    return await _picker.pickMultiImage(
        maxHeight: AppRes.maxHeight,
        maxWidth: AppRes.maxWidth,
        imageQuality: AppRes.imageQuality,
        limit: limit ?? AppRes.imageLimit);
  }

  Future<XFile?> pickImage({required ImageSource source}) async {
    try {
      return await _picker.pickImage(
          maxHeight: AppRes.maxHeight,
          maxWidth: AppRes.maxWidth,
          imageQuality: AppRes.imageQuality,
          source: source);
    } on PlatformException catch (e) {
      Loggers.error(e.code);
      if (e.code == 'camera_access_denied') {
        _requestImagePermission(source);
      }
    }

    return null;
  }

  Future<MediaFile?> pickVideo({required ImageSource source}) async {
    try {
      XFile? videoFile = await _picker.pickVideo(source: source);
      if (videoFile == null) return null;
      XFile thumbNail = await extractThumbnail(videoPath: videoFile.path);
      return MediaFile(
          file: videoFile, type: MediaType.video, thumbNail: thumbNail);
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied') {
        _requestImagePermission(source);
      }
    }
    return null;
  }

  Future<MediaFile?> pickMedia() async {
    XFile? file = await _picker.pickMedia(
      imageQuality: AppRes.imageQuality,
      maxHeight: AppRes.maxHeight,
      maxWidth: AppRes.maxWidth,
    );

    if (file != null) {
      String? mimeType = lookupMimeType(file.path);
      if (mimeType != null) {
        if (mimeType.contains('image')) {
          return MediaFile(type: MediaType.image, file: file, thumbNail: file);
        } else if (mimeType.contains('video')) {
          BaseController.share.showLoader();
          XFile thumbNail = await extractThumbnail(videoPath: file.path);
          BaseController.share.stopLoader();
          return MediaFile(
              type: MediaType.video, file: file, thumbNail: thumbNail);
        }
      } else {
        Loggers.error('mimeType Empty');
        return null;
      }
    }
    Loggers.error('File Path Not Found');
    return null;
  }

  Future<XFile> extractThumbnail({required String videoPath}) async {
    File thumbnailFile = File('');
    try {
      thumbnailFile = await VideoCompress.getFileThumbnail(videoPath,
          quality: AppRes.imageQuality);
    } catch (e) {
      Loggers.error('extractThumbnail :$e');
    }
    return XFile(thumbnailFile.path);
  }

  Future<Uint8List?> extractThumbnailByte({required String videoPath}) async {
    try {
      final file = await VideoCompress.getByteThumbnail(
        videoPath,
        quality: AppRes.imageQuality,
        position: -1, // Set a valid frame position
      );
      return file;
    } catch (e) {
      Loggers.error('FAILED TO GENERATE THUMBNAIL BYTES: $e');
      return null;
    }
  }

  Future<Duration> getFileDuration(String mediaPath) async {
    final mediaInfoSession = await VideoCompress.getMediaInfo(mediaPath);
    Loggers.info('Duration: ${mediaInfoSession.duration}');
    Duration _duration =
        Duration(seconds: mediaInfoSession.duration?.toInt() ?? 0);
    return _duration;
  }

  Future<MediaInfo> getVideoInfo(String mediaPath) async {
    try {
      final mediaInfoSession = await VideoCompress.getMediaInfo(mediaPath);

      // Loggers.info('getMediaInfo: ${mediaInfoSession.toJson()}');
      Loggers.info(
          'File Size : ${getFileSizeString(bytes: mediaInfoSession.filesize ?? 0, decimals: 0)} Mb '
          '|| Duration : ${(mediaInfoSession.duration ?? 0) / 1000}');
      return mediaInfoSession;
    } catch (e) {
      Loggers.error(e);
      return MediaInfo(path: '');
    }
  }

  String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  Future<XFile?> compressImage(String filePath, String localPath) async {
    try {
      XFile? file =
          await FlutterImageCompress.compressAndGetFile(filePath, localPath);
      Loggers.success('Compress Image : ${file?.path}');
      return file;
    } on UnimplementedError catch (e) {
      Loggers.error('Compress Image Error : ${e.message}');
      return null;
    }
  }

  Future<XFile?> compressVideo(String filePath, String localPath) async {
    MediaInfo oldFile = await getVideoInfo(filePath);
    Loggers.success('Old File ${oldFile.toJson()}');
    MediaInfo? file = await VideoCompress.compressVideo(filePath);
    if (file?.file == null) {
      return null;
    }
    Loggers.success('Compress Video : ${file?.toJson()}');
    return XFile(file?.path ?? '');
  }

  Future<XFile?> compressProfileImage(String filePath) async {
    const int maxSizeInBytes = AppRes.compressQualityInKB * 1024; // 100 KB
    int quality = 95;
    // Get the temporary directory
    final localPath = await PlatformPathExtension.localPath;
    String targetPath =
        '$localPath/compressed_profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    Uint8List? result;
    do {
      result = await FlutterImageCompress.compressWithFile(
        filePath,
        minWidth: 800,
        minHeight: 800,
        quality: quality,
        format: CompressFormat.jpeg,
      );
      if (result == null) return null;
      if (result.lengthInBytes <= maxSizeInBytes) {
        final File _file = File(targetPath)
          ..writeAsBytesSync(result, flush: true);
        return XFile(_file.path);
      }
      quality -= 5;
    } while (
        quality > 10); // Don't go below 10 quality to avoid super poor images
    File _file = File(targetPath)
      ..writeAsBytesSync(result,
          flush: true); // Might still be >100KB if image too big
    return XFile(_file.path);
  }

  Future<bool> _requestImagePermission(ImageSource source) async {
    bool isCamera = source == ImageSource.camera;
    await Get.bottomSheet(
        ConfirmationSheet(
          title: isCamera
              ? LKey.enableCameraAndMicrophoneAccessTitle.tr
              : LKey.enablePhotoAccessTitle.tr,
          description: isCamera
              ? LKey.enableCameraAndMicrophoneAccessDescription.tr
              : LKey.enablePhotoAccessDescription
                  .trParams({'app_name': AppRes.appName}),
          onTap: () {
            openAppSettings().then((value) {
              return value;
            });
          },
          positiveText: LKey.openSettings.tr,
        ),
        isScrollControlled: true);
    return false;
  }
}

enum MediaType { image, video }

class MediaFile {
  final XFile file;
  final XFile thumbNail;
  final MediaType type; // 'image' or 'video'

  MediaFile({required this.file, required this.type, required this.thumbNail});
}
