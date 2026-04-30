import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/model/post_story/music/music_model.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/screen/camera_screen/camera_screen.dart';
import 'package:shortzz/screen/selected_music_sheet/selected_music_sheet_controller.dart';

class AudioDetailsScreenController extends BaseController {
  Rx<Music?> music;
  bool isSavedLoading = false;
  RxList<Post> reelPosts = RxList<Post>();
  PlayerController audioPlayerController = PlayerController();
  RxBool isAudioDownloading = false.obs;
  RxBool isPlaying = false.obs;
  String downloadMusicUrl = '';

  AudioDetailsScreenController(this.music);

  @override
  void onInit() {
    super.onInit();
    fetchReelPostsByMusic();
    audioPlayerEventListener();
  }

  @override
  void onClose() {
    super.onClose();
    audioPlayerController.dispose();
  }

  void onSavedMusic() {
    int musicId = music.value?.id ?? -1;
    if (musicId == -1) {
      return Loggers.error('Invalid Music ID : $musicId');
    }

    if (isSavedLoading) return;

    final user = SessionManager.instance.getUser();
    if (user == null) {
      return;
    }

    final savedMusicIds = user.savedMusicIds
            ?.split(',')
            .where((e) => e.isNotEmpty)
            .map(int.parse)
            .toList() ??
        [];

    if (savedMusicIds.contains(musicId)) {
      savedMusicIds.remove(musicId);
      music.update((val) => val?.isSaved = false);
    } else {
      savedMusicIds.add(musicId);
      music.update((val) => val?.isSaved = true);
    }
    isSavedLoading = true;
    _updateSavedMusicId(savedMusicIds);
  }

  Future<void> _updateSavedMusicId(List<int> savedMusicIds) async {
    await UserService.instance.updateUserDetails(savedMusicIds: savedMusicIds);
    isSavedLoading = false;
  }

  Future<void> fetchReelPostsByMusic() async {
    int musicId = music.value?.id ?? -1;
    if (musicId == -1) {
      return Loggers.error('Invalid Music ID : $musicId');
    }
    isLoading.value = true;
    List<Post> items = await PostService.instance.fetchReelPostsByMusic(
        musicId: musicId,
        lastItemId: reelPosts.isEmpty ? null : reelPosts.last.id?.toInt());
    isLoading.value = false;

    reelPosts.addAll(items);
    music.update((val) => val?.postCount = reelPosts.length);
  }

  void onMakeReel() async {
    if (downloadMusicUrl.isEmpty) {
      showLoader();
      downloadMusicUrl = (await DefaultCacheManager()
              .getSingleFile(music.value?.sound?.addBaseURL() ?? ''))
          .path;
      stopLoader();
    }
    audioPlayerController.pausePlayer();
    SelectedMusic selectedMusic = SelectedMusic(
        Music.fromJson(music.value?.toJson()), 0, downloadMusicUrl, 0);

    Get.to(
      () => CameraScreen(
        cameraType: CameraScreenType.post,
        selectedMusic: selectedMusic,
      ),
    );
  }

  void onPlayPauseMusic() {
    if (downloadMusicUrl.isNotEmpty) {
      if (isPlaying.value) {
        audioPlayerController.pausePlayer();
        isPlaying.value = false;
        return;
      } else {
        audioPlayerController.startPlayer();
        isPlaying.value = true;
        return;
      }
    }
    if (isAudioDownloading.value) return;
    isAudioDownloading.value = true;
    DefaultCacheManager()
        .getSingleFile(music.value?.sound?.addBaseURL() ?? '')
        .then((value) async {
      downloadMusicUrl = value.path;
      await audioPlayerController.preparePlayer(path: value.path);
      await audioPlayerController.startPlayer();
      isPlaying.value = true;
      await audioPlayerController.setFinishMode(finishMode: FinishMode.pause);
      isAudioDownloading.value = false;
    });
  }

  void audioPlayerEventListener() {
    audioPlayerController.onPlayerStateChanged.listen((event) {
      switch (event) {
        case PlayerState.initialized:
          break;
        case PlayerState.playing:
          Loggers.success('Playing');
          isPlaying.value = true;
          break;
        case PlayerState.paused:
          Loggers.success('Pause');
          isPlaying.value = false;
          break;
        case PlayerState.stopped:
          break;
      }
    });
  }
}
