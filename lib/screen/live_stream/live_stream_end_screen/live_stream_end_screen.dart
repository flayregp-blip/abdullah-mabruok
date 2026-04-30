import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/ads_controller.dart';
import 'package:shortzz/model/livestream/livestream_user_state.dart';
import 'package:shortzz/screen/live_stream/live_stream_end_screen/widget/livestream_summary.dart';

class LiveStreamEndScreen extends StatelessWidget {
  final LivestreamUserState? userState;
  final bool isHost;
  final int viewers;

  const LiveStreamEndScreen(
      {super.key,
      required this.userState,
      required this.isHost,
      required this.viewers});

  @override
  Widget build(BuildContext context) {
    AdsController adsController;
    if (!Get.isRegistered<AdsController>()) {
      adsController = Get.put(AdsController());
    } else {
      adsController = Get.find<AdsController>();
    }
    return Scaffold(
        body: LiveStreamSummary(
      userState: userState,
      isHost: isHost,
      viewers: viewers,
      onGoHomeTap: () async {
        adsController.showInterstitialAdIfAvailable();
      },
    ));
  }
}
