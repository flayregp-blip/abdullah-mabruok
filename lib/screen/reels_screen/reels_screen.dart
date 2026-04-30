import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shortzz/common/widget/my_refresh_indicator.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/post_by_id.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/comment_sheet/widget/hashtag_and_mention_view.dart';
import 'package:shortzz/screen/reels_screen/reel/reel_page.dart';
import 'package:shortzz/screen/reels_screen/reels_screen_controller.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/screen/reels_screen/widget/reels_text_field.dart';
import 'package:shortzz/screen/reels_screen/widget/reels_top_bar.dart';
import 'package:shortzz/utilities/theme_res.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ---------------------------------------------------------------
// REELS SCREEN (PAGEVIEW)
// ---------------------------------------------------------------
class ReelsScreen extends StatefulWidget {
  final ReelPageType pageType;
  final User? user;
  final String? hashTag;
  final RxList<Post> reels;
  final int position;
  final Widget? widget;
  final Future<void> Function()? onFetchMoreData;
  final Future<void> Function()? onRefresh;
  final RxBool? isLoading;
  final PostByIdData? postByIdData;

  const ReelsScreen({
    super.key,
    required this.reels,
    required this.position,
    this.widget,
    this.onFetchMoreData,
    this.onRefresh,
    this.isLoading,
    this.postByIdData,
    required this.pageType,
    this.user,
    this.hashTag,
  });

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late final ReelsScreenController controller;

  @override
  void initState() {
    super.initState();
    String tag = widget.pageType.withId(userId: widget.user?.id, hashTag: widget.hashTag);

    // 🔥 Always remove old controller if exists
    if (Get.isRegistered<ReelsScreenController>(tag: tag)) {
      Get.delete<ReelsScreenController>(tag: tag, force: true);
    }

    // ✅ Always create new controller
    controller = Get.put(
      ReelsScreenController(
        reels: widget.reels,
        position: widget.position.obs,
        onFetchMoreData: widget.onFetchMoreData,
        reelPageType: widget.pageType,
      ),
      tag: tag,
    );

    controller.pageController = PageController(initialPage: widget.position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackPure(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(
                child: MyRefreshIndicator(
                  onRefresh: () async {
                    await controller.handleRefresh(widget.onRefresh);
                  },
                  shouldRefresh: widget.onRefresh != null,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Obx(
                        () {
                          return Stack(
                            children: [
                              if (controller.reels.isEmpty)
                                widget.isLoading?.value == true
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.black,
                                        highlightColor: const Color(0x00404040),
                                        child: Container(
                                          color: whitePure(context),
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      )
                                    : NoDataWidgetWithScroll(
                                        title: LKey.reelsEmptyTitle.tr,
                                        description: LKey.reelsEmptyDescription.tr)
                              else
                                VisibilityDetector(
                                  key: Key('reels_list_${widget.pageType}'),
                                  onVisibilityChanged: (info) {
                                    if (info.visibleFraction == 1) {
                                      if (controller.players.isEmpty) {
                                        controller.initVideoPlayer();
                                      }
                                    } else {
                                      controller.pauseAllPlayers();
                                    }
                                  },
                                  child: Obx(
                                    () => PageView.builder(
                                      physics: const CustomPageViewScrollPhysics(),
                                      controller: controller.pageController,
                                      itemCount: controller.reels.length,
                                      scrollDirection: Axis.vertical,
                                      onPageChanged: controller.onPageChanged,
                                      itemBuilder: (context, index) {
                                        Post reel = controller.reels[index];
                                        return Obx(
                                          () {
                                            return ReelPage(
                                              reelData: reel,
                                              likeKey: GlobalKey(),
                                              onUpdateReelData: controller.onUpdateReelData,
                                              videoPlayerController:
                                                  controller.players[index]?.status ==
                                                          PlayerStatus.disposed
                                                      ? null
                                                      : controller.players[index]?.controller,
                                              postByIdData: widget.postByIdData,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                )
                            ],
                          );
                        },
                      ),
                      if (widget.pageType != ReelPageType.home)
                        HashTagAndMentionUserView(helper: controller.commentHelper),
                    ],
                  ),
                ),
              ),
              ReelsTextField(controller: controller),
            ],
          ),
          ReelsTopBar(controller: controller, widget: widget.widget),
        ],
      ),
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({super.parent});

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(mass: 1, stiffness: 1000, damping: 60);
}
