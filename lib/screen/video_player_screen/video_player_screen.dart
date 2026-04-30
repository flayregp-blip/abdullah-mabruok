import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/duration_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/service/navigation/navigate_with_controller.dart';
import 'package:shortzz/common/widget/black_gradient_shadow.dart';
import 'package:shortzz/common/widget/custom_back_button.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/screen/post_screen/widget/post_view_center.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Post? post;

  const VideoPlayerScreen({super.key, this.post});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final Rx<VideoPlayerController?> _videoPlayerController = Rx(null);
  Post? post;
  bool isUIVisible = true;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    _videoPlayerController.value =
        VideoPlayerController.networkUrl(Uri.parse(post?.video?.addBaseURL() ?? ''))
          ..initialize().then((value) {
            _videoPlayerController.value?.play();
            _videoPlayerController.refresh();
            _increaseViewCount();
          });
  }

  @override
  void dispose() {
    if (_videoPlayerController.value != null) {
      _videoPlayerController.value?.dispose();
      _videoPlayerController.value = null; // Set to null after disposing
    }
    super.dispose();
  }

  _increaseViewCount() {
    if (post?.id != null) {
      PostService.instance.increaseViewsCount(postId: post?.id?.toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackPure(context),
      body: Center(
        child: Obx(
          () {
            if (_videoPlayerController.value == null) {
              return CustomImage(
                  size: const Size(double.infinity, double.infinity),
                  image: post?.thumbnail?.addBaseURL(),
                  isShowPlaceHolder: true,
                  radius: 0,
                  fit: BoxFit.cover);
            } else {
              double width = _videoPlayerController.value?.value.size.width ?? 0;
              double height = _videoPlayerController.value?.value.size.height ?? 0;
              return ClipSmoothRect(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_videoPlayerController.value != null)
                      InkWell(
                        onTap: () {
                          isUIVisible = !isUIVisible;
                          setState(() {});
                        },
                        child: VisibilityDetector(
                          onVisibilityChanged: (info) {
                            var visiblePercentage = info.visibleFraction * 100;
                            if (visiblePercentage > 50) {
                              _videoPlayerController.value?.play();
                            } else {
                              _videoPlayerController.value?.pause();
                            }
                          },
                          key: Key(post?.video?.addBaseURL() ?? ''),
                          child: SizedBox.expand(
                            child: FittedBox(
                                fit: width < height ? BoxFit.cover : BoxFit.fitWidth,
                                child: SizedBox(
                                    width: width,
                                    height: height,
                                    child: VideoPlayer(_videoPlayerController.value!))),
                          ),
                        ),
                      )
                    else
                      CustomImage(
                          size: const Size(double.infinity, double.infinity),
                          image: post?.thumbnail?.addBaseURL(),
                          isShowPlaceHolder: true,
                          radius: 0,
                          fit: BoxFit.cover),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: isUIVisible ? 1 : 0,
                      child: ValueListenableBuilder(
                        valueListenable: _videoPlayerController.value!,
                        builder: (context, value, child) {
                          return Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SafeArea(
                                    bottom: false,
                                    child: CustomBackButton(
                                        padding: const EdgeInsets.all(10),
                                        color: whitePure(context)),
                                  ),
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      const BlackGradientShadow(height: 150),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 25),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          spacing: 10,
                                          children: [
                                            PlayerActionView(
                                                value: value,
                                                videoPlayerController: _videoPlayerController),
                                            // UserInfoData(
                                            //     post: post,
                                            //     videoPlayerController: _videoPlayerController)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class PlayerActionView extends StatelessWidget {
  final VideoPlayerValue value;
  final Rx<VideoPlayerController?> videoPlayerController;

  const PlayerActionView({super.key, required this.value, required this.videoPlayerController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: ShapeDecoration(
          color: blackPure(context).withValues(alpha: .6),
          shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1))),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (value.isPlaying) {
                videoPlayerController.value?.pause();
              } else {
                videoPlayerController.value?.play();
              }
            },
            child: Image.asset(
              value.isPlaying ? AssetRes.icPause : AssetRes.icPlay,
              color: whitePure(context),
              height: 30,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            value.position.printDuration,
            style: TextStyleCustom.outFitMedium500(color: whitePure(context), fontSize: 15),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Slider(
                value: value.position.inMicroseconds.toDouble(),
                min: 0,
                max: value.duration.inMicroseconds.toDouble(),
                thumbColor: themeAccentSolid(context),
                activeColor: whitePure(context),
                inactiveColor: whitePure(context).withValues(alpha: .3),
                onChangeStart: (value) {
                  videoPlayerController.value?.pause();
                },
                onChangeEnd: (value) {
                  videoPlayerController.value?.play();
                },
                onChanged: (value) {
                  videoPlayerController.value?.seekTo(Duration(microseconds: value.toInt()));
                },
              ),
            ),
          ),
          Text(
            value.duration.printDuration,
            style: TextStyleCustom.outFitMedium500(color: whitePure(context), fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class UserInfoData extends StatelessWidget {
  final Post? post;
  final Rx<VideoPlayerController?> videoPlayerController;

  const UserInfoData({super.key, this.post, required this.videoPlayerController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          CustomImage(
            size: const Size(40, 40),
            image: post?.user?.profilePhoto?.addBaseURL(),
            fullName: post?.user?.fullname,
            onTap: onNavigateUser,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FullNameWithBlueTick(
                  username: post?.user?.username,
                  isVerify: post?.user?.isVerify,
                  fontColor: whitePure(context),
                  fontSize: 14,
                  onTap: onNavigateUser,
                ),
                InkWell(
                  onTap: onNavigateUser,
                  child: Text(post?.user?.fullname ?? '',
                      style:
                          TextStyleCustom.outFitLight300(color: whitePure(context), fontSize: 16)),
                )
              ],
            ),
          ),
        ]),
        const SizedBox(height: 5),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 0, maxHeight: 200),
          child: SingleChildScrollView(
            child: PostTextView(
              description: post?.descriptionWithUserName,
              mentionUsers: post?.mentionedUsers ?? [],
              basicTextColor: whitePure(context),
              mentionTextColor: whitePure(context),
              hashtagTextColor: whitePure(context),
              basicTextOpacity: .7,
            ),
          ),
        ),
      ],
    );
  }

  void onNavigateUser() {
    NavigationService.shared.openProfileScreen(post?.user);
  }
}
