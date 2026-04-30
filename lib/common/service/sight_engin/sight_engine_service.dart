import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_native_video_trimmer/flutter_native_video_trimmer.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/sight_engine/sight_engine_media_model.dart';
import 'package:shortzz/model/sight_engine/text_moderation_model.dart';
import 'package:shortzz/utilities/app_res.dart';

class SightEngineService {
  static var shared = SightEngineService();

  Future<void> checkImagesInSightEngine({
    required List<XFile> xFiles,
    required Function() completion,
  }) async {
    if (SessionManager.instance.getSettings()?.isContentModeration == 0) {
      completion();
      return;
    }
    BaseController.share.showLoader();
    var request = http.MultipartRequest('POST',
        Uri.parse('https://api.sightengine.com/1.0/check-workflow.json'));

    request.fields['workflow'] =
        SessionManager.instance.getSettings()?.sightEngineImageWorkflowId ?? '';
    request.fields['api_user'] =
        SessionManager.instance.getSettings()?.sightEngineApiUser ?? '';
    request.fields['api_secret'] =
        SessionManager.instance.getSettings()?.sightEngineApiSecret ?? '';

    for (XFile xFile in xFiles) {
      File file = File(xFile.path);
      request.files.add(
        http.MultipartFile(
          'media',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split("/").last,
        ),
      );
    }

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    SightEngineMediaModel sightEngineMediaModel =
        SightEngineMediaModel.fromJson(jsonDecode(respStr));

    if (sightEngineMediaModel.error != null) {
      BaseController.share.stopLoader();
      Loggers.error(sightEngineMediaModel.error?.message);
      BaseController.share
          .showSnackBar(sightEngineMediaModel.error?.message ?? '');
      return;
    }

    var result = sightEngineMediaModel.summary?.action ?? '';

    BaseController.share.stopLoader();
    if (result == 'accept') {
      completion(); // All images accepted
    } else if (result == 'reject') {
      var summaryDescription = sightEngineMediaModel.summary?.rejectReason
              ?.map((e) => e.text ?? '')
              .join(', ') ??
          '';
      BaseController.share.showSnackBar(
          '${LKey.mediaRejectedAndContainsSuchThings.tr} $summaryDescription');
    }
  }

  Future<void> checkVideoInSightEngine({required XFile xFile,
    required int duration,
    required Function() completion}) async {
    if (SessionManager.instance.getSettings()?.isContentModeration == 0) {
      completion();
      return;
    }

    File file = File(xFile.path);
    BaseController.share.showLoader();
    if (duration > AppRes.sightEngineCropSec) {
      final videoTrimmer = VideoTrimmer();
      try {
        await videoTrimmer.loadVideo(file.path);
      } catch (e) {
        Loggers.error(e);
      }
      final trimmedPath = await videoTrimmer.trimVideo(
        startTimeMs: 0,
        endTimeMs: AppRes.sightEngineCropSec * 1000,
        includeAudio: false,
      );
      file = File(trimmedPath ?? '');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://api.sightengine.com/1.0/video/check-workflow-sync.json'),
    );
    request.fields['workflow'] =
        SessionManager.instance.getSettings()?.sightEngineVideoWorkflowId ?? '';
    request.fields['api_user'] =
        SessionManager.instance.getSettings()?.sightEngineApiUser ?? '';
    request.fields['api_secret'] =
        SessionManager.instance.getSettings()?.sightEngineApiSecret ?? '';

    request.files.add(
      http.MultipartFile(
          'media', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split("/").last),
    );

    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    SightEngineMediaModel sightEngineMediaModel =
        SightEngineMediaModel.fromJson(jsonDecode(respStr));
    print(jsonDecode(respStr));
    if (sightEngineMediaModel.error != null) {
      BaseController.share.stopLoader();
      BaseController.share
          .showSnackBar(sightEngineMediaModel.error?.message ?? '');
      return;
    }
    var result = sightEngineMediaModel.summary?.action ?? '';
    BaseController.share.stopLoader();
    if (result == 'accept') {
      completion();
    } else if (result == 'reject') {
      var summaryDescription = sightEngineMediaModel.summary?.rejectReason
              ?.map((e) => e.text ?? '')
              .join(', ') ??
          '';
      BaseController.share.showSnackBar(
          '${LKey.mediaRejectedAndContainsSuchThings.tr} $summaryDescription');
    }
  }

  Future<void> chooseTextModeration(
      {required String text, required Function() completion}) async {
    if (SessionManager.instance.getSettings()?.isContentModeration == 0) {
      completion();
      return;
    }
    if (text.isEmpty) {
      completion();
      return;
    }
    BaseController.share.showLoader();
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.sightengine.com/1.0/text/check.json'));
    request.fields.addAll({
      'text': text,
      'lang': 'en,zh,da,nl,fi,fr,de,it,no,pl,pt,es,sv,tl,tr',
      'categories': 'profanity',
      'mode': 'rules',
      'api_user':
          SessionManager.instance.getSettings()?.sightEngineApiUser ?? '',
      'api_secret':
          SessionManager.instance.getSettings()?.sightEngineApiSecret ?? '',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var respStr = await response.stream.bytesToString();
      TextModerationModel textModerationModel =
          TextModerationModel.fromJson(jsonDecode(respStr));
      List<Matches> matches = textModerationModel.profanity?.matches ?? [];
      print(jsonDecode(respStr));
      if (textModerationModel.error != null) {
        BaseController.share.stopLoader();
        BaseController.share
            .showSnackBar(textModerationModel.error?.message ?? '');
        return;
      }
      List<String> words = [];

      for (var element in matches) {
        if (element.intensity == 'high' || element.intensity == 'medium') {
          words.add(element.match ?? '');
        }
      }

      BaseController.share.stopLoader();
      if (words.isEmpty) {
        completion();
      } else {
        log('${LKey.textRejectedAndContainsSuchThings.tr} ${words.join(', ')}');
        BaseController.share.showSnackBar(
            '${LKey.textRejectedAndContainsSuchThings.tr} ${words.join(', ')}');
      }
    } else {
      log(response.reasonPhrase ?? '');
    }
  }
}
