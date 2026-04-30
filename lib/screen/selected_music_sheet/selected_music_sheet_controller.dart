import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/model/post_story/music/music_model.dart';

class SelectedMusicSheetController extends BaseController {
  int videoDurationInMs;
  SelectedMusic selectedMusic;

  PlayerController audioPlayer = PlayerController();
  Rx<int?> durationInMilliSec = Rx(null);
  Rx<int> audioStartInMilliSec = Rx(0);

  RxBool isPlaying = false.obs;
  Timer? _timer;
  StreamSubscription? positionSubscription;

  SelectedMusicSheetController(this.videoDurationInMs,
      this.selectedMusic); // Function(SelectedMusic? music)? onMusicAdd;

  ScrollController scrollController = ScrollController();
  RxList<double> waves = RxList();
  double oneBarValue = 0;
  final double borderWidth = 10;
  final double barWidth = 2;
  final double barHorizontalMargin = 1;
  final double barInBoxCount = 30;
  RxDouble currentProgress = 0.0.obs;
  RxDouble scrollOffset = 0.0.obs;

  double get barTotalWidth => barWidth + (barHorizontalMargin * 2);

  double get boxWidth => barTotalWidth * barInBoxCount;

  int get previousBar => (scrollOffset.value / barTotalWidth).toInt();

  int get currentBars =>
      (previousBar + (currentProgress.value * barInBoxCount)).toInt();

  @override
  void onReady() {
    super.onReady();
    initPlayer();
  }

  @override
  void onClose() {
    super.onClose();
    audioPlayer.release();
    _timer?.cancel();
    audioPlayer.dispose();
    positionSubscription?.cancel();
  }

  void initPlayer() async {
    Loggers.info(
        'INITIAL VIDEO DURATION SECOND : (${videoDurationInMs / 1000})');
    Loggers.info('Selected Audio Data : (${selectedMusic.toJson()})');
    try {
      await audioPlayer.preparePlayer(path: selectedMusic.downloadedURL ?? '');
      audioPlayer.seekTo(selectedMusic.audioStartMS ?? 0);
      audioStartInMilliSec.value = selectedMusic.audioStartMS ?? 0;

      oneBarValue = (barInBoxCount / (videoDurationInMs / 1000));
      durationInMilliSec.value = await audioPlayer.getDuration();
      for (double i = 0;
          i <= (oneBarValue * ((durationInMilliSec.value ?? 0) / 1000)).toInt();
          i++) {
        waves.add(i);
      }
      scrollController.addListener(_onScroll);
      DebounceAction.shared.call(() {
        scrollController.animateTo(
            ((selectedMusic.audioStartMS ?? 0) / 1000) *
                barTotalWidth *
                oneBarValue,
            duration: const Duration(milliseconds: 10),
            curve: Curves.bounceIn);
        playPause();
      });
    } catch (e) {
      Loggers.error("Error loading audio source: $e");
    }
  }

  void _onScroll() {
    currentProgress.value = 0.0;
    if (isPlaying.value == true) {
      onPause();
    } else {
      DebounceAction.shared.call(() async {
        int scrollOffset = scrollController.offset.toInt();
        int startDuration =
            ((scrollOffset / barTotalWidth) / oneBarValue).toInt();
        audioStartInMilliSec.value = (startDuration * 1000);
        this.scrollOffset.value = scrollOffset.toDouble();
        onPlayAudio();
      });
    }
  }

  Future<void> playPause() async {
    (isPlaying.value) ? await onPause() : await onPlayAudio();
  }

  void _listenPlayer() {
    currentProgress.value = 0.0;
    positionSubscription = audioPlayer.onCurrentDurationChanged.listen((event) {
      int relativePosition = (event.milliseconds.inMilliseconds + 100) -
          audioStartInMilliSec.value;
      currentProgress.value = (relativePosition / videoDurationInMs);

      Loggers.info('Current Progress : $currentProgress');
    });
    audioPlayer.onCompletion.listen(
      (event) {
        Loggers.success('DONE');
        currentProgress.value = 1;
        isPlaying.value = false;
      },
    );
  }

  Future<void> onPlayAudio() async {
    _listenPlayer();
    try {
      await audioPlayer.seekTo(audioStartInMilliSec.value);
      // await Future.delayed(const Duration(milliseconds: 500));
      await audioPlayer.startPlayer();
      audioPlayer.setFinishMode(finishMode: FinishMode.pause);

      int endTime =
          ((durationInMilliSec.value ?? 0) - audioStartInMilliSec.value);

      if (videoDurationInMs < endTime) {
        endTime = videoDurationInMs;
      }

      isPlaying.value = true;

      _timer = Timer(Duration(milliseconds: videoDurationInMs), () async {
        await onPause();
      });
    } catch (e) {
      Loggers.error('ON PLAY ERROR : $e');
    }
  }

  Future<void> onPause() async {
    try {
      await audioPlayer.pausePlayer();
      await positionSubscription?.cancel();
      isPlaying.value = false;
      _timer?.cancel();
    } catch (e) {
      Loggers.error(e);
    } finally {
      Loggers.info('PAUSE');
    }
  }

  void onContinueTap() async {
    int audioTotalMilliSec = durationInMilliSec.value ?? 0;
    int audioStartingMilliSec = audioStartInMilliSec.value;

    if (audioTotalMilliSec > videoDurationInMs &&
        (audioTotalMilliSec - audioStartingMilliSec) < videoDurationInMs) {
      int trimmedDuration = audioTotalMilliSec - audioStartingMilliSec;

      if (trimmedDuration < videoDurationInMs) {
        int missingDuration = videoDurationInMs - trimmedDuration;
        audioStartingMilliSec -= missingDuration;
        if (audioStartingMilliSec.isNegative) {
          return Loggers.error('Player Not Ready');
        }
      }
    }

    Loggers.info('READY FOR THE PLAY');
    onPause();
    SelectedMusic music = SelectedMusic(
        selectedMusic.music,
        audioStartingMilliSec,
        selectedMusic.downloadedURL,
        audioStartingMilliSec + videoDurationInMs);
    Get.back(result: music);
  }
}

class SelectedMusic {
  Music? music;
  int? audioStartMS;
  String? downloadedURL;
  int? endMilliSec;

  SelectedMusic(
      this.music, this.audioStartMS, this.downloadedURL, this.endMilliSec);

  Map<String, dynamic> toJson() {
    return {
      'music': music?.toJson(), // Assuming Music class has a toJson method
      'downloadedURL': downloadedURL,
      'audioStartMS': audioStartMS,
      'endMilliSec': endMilliSec,
    };
  }
}
