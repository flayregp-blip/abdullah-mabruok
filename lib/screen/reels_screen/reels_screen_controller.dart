import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/model/post_story/comment/fetch_comment_model.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/screen/comment_sheet/helper/comment_helper.dart';
import 'package:shortzz/screen/dashboard_screen/dashboard_screen_controller.dart';
import 'package:shortzz/screen/profile_screen/profile_screen_controller.dart';
import 'package:shortzz/screen/profile_screen/widget/post_options_sheet.dart';
import 'package:shortzz/screen/reels_screen/reel/reel_page_controller.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/screen/report_sheet/report_sheet.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ReelsScreenController extends BaseController {
  RxMap<int, ReelPlayerEntry> players = <int, ReelPlayerEntry>{}.obs;

  static const String tag = "REEL";
  RxInt position = 0.obs;

  PageController pageController = PageController();

  RxList<Post> reels;
  Future<void> Function()? onFetchMoreData;

  final RxBool isRefreshing = false.obs;
  CommentHelper commentHelper = CommentHelper();
  bool isCurrentPageVisible = true;

  ReelPageType reelPageType;

  ReelsScreenController({required this.reels,
    required this.position,
    this.onFetchMoreData,
    required this.reelPageType});

  void controllerAlreadyInitialize({required RxList<Post> reels,
    required RxInt position,
    Future<void> Function()? onFetchMoreData,
    required ReelPageType reelPageType}) {
    print("POSITION : $position");
    this.reels = reels;
    this.position = position;
    this.onFetchMoreData = onFetchMoreData;
    this.reelPageType = reelPageType;
    pageController = PageController(initialPage: position.value);
    players.clear();
  }

  @override
  void onInit() {
    super.onInit();
    // pageController = PageController(initialPage: position.value);
    WakelockPlus.enable();
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
    WakelockPlus.disable();
    disposeAllController();
  }

  Future<void> initVideoPlayer() async {
    /// Initialize 1st video
    await _initializeControllerAtIndex(position.value);

    /// Play 1st video
    _playControllerAtIndex(position.value);

    /// Initialize 2nd vide
    if (position >= 0) {
      await _initializeControllerAtIndex(position.value - 1);
    }
    await _initializeControllerAtIndex(position.value + 1);
  }

  void onPageChanged(int index) {
    if (index > position.value) {
      _fetchMoreData();
      _playNextReel(index);
    } else {
      _playPreviousReel(index);
    }
    position.value = index;

    _playControllerAtIndex(index);
  }

  Future<void> _fetchMoreData() async {
    if (position >= reels.length - 3) {
      Future.delayed(const Duration(seconds: 1), () async {
        await onFetchMoreData?.call().then((value) {
          _initializeControllerAtIndex(position.value + 1);
        });
      });
    }
  }

  void _playNextReel(int index) {
    pauseAllPlayers();
    _initializeControllerAtIndex(index);
    _initializeControllerAtIndex(index + 1);
    _initializeControllerAtIndex(index - 1);

    _disposeAllExcept(index);
  }

  void _playPreviousReel(int index) {
    pauseAllPlayers();
    _initializeControllerAtIndex(index);
    _initializeControllerAtIndex(index + 1);
    _initializeControllerAtIndex(index - 1);

    _disposeAllExcept(index);
  }

  void _disposeAllExcept(int index) {
    final validIndexes = {index - 1, index, index + 1};

    final keys = players.keys.toList(); // 👈 COPY

    for (final i in keys) {
      if (!validIndexes.contains(i)) {
        _disposeControllerAtIndex(i);
        players.remove(i);
      }
    }
  }

  void _disposeControllerAtIndex(int index) {
    ReelPlayerEntry? entry = players[index];
    if (entry == null) return;
    if (entry.status == PlayerStatus.disposed || entry.status == PlayerStatus.none) return;

    final controller = entry.controller;

    if (controller != null) {
      if (entry.listener != null) {
        controller.removeListener(entry.listener!);
      }
      controller.pause();
      controller.dispose();
    }

    entry.controller = null;
    entry.listener = null;
    entry.status = PlayerStatus.disposed;
    players[index] = entry;
    players.refresh();

    Loggers.info("🗑 DISPOSED $index");
  }

  Future<void> _initializeControllerAtIndex(int index) async {
    if (index < 0 || index >= reels.length) return;

    /// 🔒 HARD GUARD (no race possible)
    if (players[index]?.status == PlayerStatus.initializing ||
        players[index]?.status == PlayerStatus.initialized) {
      return;
    }

    /// 🔒 Mark initializing IMMEDIATELY
    players[index] = ReelPlayerEntry(status: PlayerStatus.initializing);
    try {
      late VideoPlayerController controller;

      final reel = reels[index];
      if (reel.id == -1) {
        controller = VideoPlayerController.file(
          File(reel.video ?? ''),
        );
      } else {
        controller = VideoPlayerController.networkUrl(
          Uri.parse(reel.video?.addBaseURL() ?? ''),
        );
      }

      await controller.initialize();
      controller.setLooping(true);

      players[index] = ReelPlayerEntry(
        controller: controller,
        status: PlayerStatus.initialized,
      );

      Loggers.info("🚀 INITIALIZED $index");

      if (index == position.value) {
        _playControllerAtIndex(index);
      }
    } catch (e) {
      Loggers.error("❌ INIT FAILED $index $e");

      _disposeControllerAtIndex(index);
    }
  }

  void _playControllerAtIndex(int index) {
    final dashController = Get.find<DashboardScreenController>();
    if (reelPageType == ReelPageType.home && dashController.selectedPageIndex.value != 0) {
      return;
    }

    final entry = players[index];
    final controller = entry?.controller;

    if (controller == null) return;
    if (!controller.value.isInitialized) return;

    controller.play();

    DebounceAction.shared.call(milliseconds: 3000, () {
      _increaseViewsCount(reels[index]);
    });
    Loggers.info('🚀🚀🚀 PLAYING $index');
  }

  void _increaseViewsCount(Post reelData) {
    PostService.instance.increaseViewsCount(postId: reelData.id).then((value) {
      if (value.status == true) {
        if (Get.isRegistered<ReelController>(tag: reelData.id.toString())) {
          Get.find<ReelController>(tag: reelData.id.toString())
              .updateReelData(reel: reelData, isIncreaseCoin: true);
        }
      }
    });
  }

  void pauseAllPlayers() {
    final keys = players.keys.toList(); // 👈 COPY
    for (var i in keys) {
      _stopControllerAtIndex(i);
    }
  }

  void _stopControllerAtIndex(int index) {
    if (reels.length > index && index >= 0) {
      final controller = players[index]?.controller;
      if (controller != null) {
        controller.pause();
        controller.seekTo(const Duration()); // Reset position
        Loggers.info('🚀🚀🚀 STOPPED $index');
      }
    }
  }

  Future<void> disposeAllController() async {
    final entries = players.entries.toList(); // 👈 COPY
    for (var entry in entries) {
      final controller = entry.value.controller;
      final listener = entry.value.listener;
      if (listener != null) {
        controller?.removeListener(listener);
      }
      controller?.pause();
      await controller?.dispose();
      entry.value.controller = null;
    }
    players.clear();
  }

  /// Handle refresh logic
  Future<void> handleRefresh(Future<void> Function()? onRefresh) async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;

    await onRefresh?.call();
    await Future.delayed(const Duration(milliseconds: 200));
    if (reels.isNotEmpty) {
      position.value = 0;
      pageController.jumpToPage(0);
      await disposeAllController();
      initVideoPlayer();
    }

    isRefreshing.value = false;
    update();
  }

  void onReportTap() {
    Get.bottomSheet(ReportSheet(reportType: ReportType.post, id: reels[position.value].id?.toInt()),
        isScrollControlled: true);
  }

  void onUpdateComment(Comment comment, bool isReplyComment) {
    final post = reels.firstWhereOrNull((e) => e.id == comment.postId);
    if (post == null) {
      return Loggers.error('Post not found');
    }
    final controllerTag = post.id.toString();
    if (Get.isRegistered<ReelController>(tag: controllerTag)) {
      Get.find<ReelController>(tag: controllerTag)
          .reelData
          .update((val) => val?.updateCommentCount(1));
    }
  }

  void openPostOptionsSheet() {
    const tag = ProfileScreenController.tag;

    final controller = Get.isRegistered<ProfileScreenController>(tag: tag)
        ? Get.find<ProfileScreenController>(tag: tag)
        : Get.put(ProfileScreenController(SessionManager.instance.getUser().obs, (user) {}),
            tag: tag);

    Get.bottomSheet(
        PostOptionsSheet(
          controller: controller,
          onChanged: (type) {
            if (type == PublishType.goLive) {
              Future.delayed(
                const Duration(seconds: 1),
                () {
                  final controller = Get.find<DashboardScreenController>();
                  controller.onChanged(2);
                },
              );
            }
          },
        ),
        isScrollControlled: true);
  }

  onUpdateReelData(Post reel) {
    final index = reels.indexWhere((element) => element.id == reel.id);
    if (index != -1) {
      reels[index] = reel; // ✅ update field only
    }
  }
}

class ReelPlayerEntry {
  VideoPlayerController? controller;
  VoidCallback? listener;
  PlayerStatus status;

  ReelPlayerEntry({this.controller, this.listener, this.status = PlayerStatus.none});
}

enum PlayerStatus { none, initializing, initialized, disposed }
