import 'package:dismissible_page/dismissible_page.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/service/navigation/navigate_with_controller.dart';
import 'package:shortzz/common/service/url_extractor/parsers/base_parser.dart';
import 'package:shortzz/common/widget/custom_bg_circle_button.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/custom_page_indicator.dart';
import 'package:shortzz/common/widget/double_tap_detector.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/hashtag_screen/hashtag_screen.dart';
import 'package:shortzz/screen/image_view_screen/image_view_screen.dart';
import 'package:shortzz/screen/post_screen/single_post_screen.dart';
import 'package:shortzz/screen/post_screen/widget/url_card.dart';
import 'package:shortzz/screen/reels_screen/reels_screen.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/font_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class PostViewCenter extends StatelessWidget {
  final Post post;
  final void Function()? onHeartAnimationEnd;
  final Function(TapDownDetails) onDoubleTap;

  const PostViewCenter(
      {super.key,
      required this.post,
      this.onHeartAnimationEnd,
      required this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => SinglePostScreen(post: post, isFromNotification: false));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((post.description ?? '').isNotEmpty)
            PostTextView(
                description: post.descriptionWithUserName,
                mentionUsers: post.mentionedUsers ?? [],
                metadata: post.metaData),
          if ((post.images ?? []).isNotEmpty)
            PostImageView(
              post: post,
              onDoubleTap: onDoubleTap,
              onHeartAnimationEnd: onHeartAnimationEnd,
            ),
          if ((post.video ?? '').isNotEmpty)
            PostVideoView(
              post: post,
              onDoubleTap: onDoubleTap,
              onHeartAnimationEnd: onHeartAnimationEnd,
            )
        ],
      ),
    );
  }
}

class PostTextView extends StatefulWidget {
  final String? description;
  final List<User> mentionUsers;
  final Color? basicTextColor;
  final Color? hashtagTextColor;
  final Color? mentionTextColor;
  final double? basicTextOpacity;
  final UrlMetadata? metadata;

  const PostTextView(
      {super.key,
      required this.description,
      required this.mentionUsers,
      this.basicTextColor,
      this.hashtagTextColor,
      this.mentionTextColor,
      this.basicTextOpacity,
      this.metadata});

  @override
  State<PostTextView> createState() => _PostTextViewState();
}

class _PostTextViewState extends State<PostTextView> {
  ValueNotifier<bool> isCollapsed = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    TextStyle collapsedStyle = TextStyleCustom.outFitLight300(
        fontSize: 15,
        color: widget.basicTextColor ?? textLightGrey(context),
        opacity: .8);

    return InkWell(
      onTap: () {
        isCollapsed.value = !isCollapsed.value;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreText(
            widget.description ?? '',
            isCollapsed: isCollapsed,
            trimMode: TrimMode.Line,
            trimLines: AppRes.trimLine,
            colorClickableText: Colors.pink,
            trimCollapsedText: LKey.more.tr,
            trimExpandedText: ' ${LKey.less.tr}',
            lessStyle: collapsedStyle,
            moreStyle: collapsedStyle,
            style: TextStyleCustom.outFitRegular400(
                color: widget.basicTextColor ?? textDarkGrey(context),
                fontSize: 15,
                opacity: widget.basicTextOpacity),
            annotations: [
              Annotation(
                regExp: AppRes.hashTagRegex,
                spanBuilder: ({required String text, TextStyle? textStyle}) =>
                    TextSpan(
                        text: text,
                        style: textStyle?.copyWith(
                          color: widget.hashtagTextColor ??
                              themeAccentSolid(context),
                          fontFamily: FontRes.outFitMedium500,
                          fontSize: 15,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => HashtagScreen(hashtag: text, index: 1),
                                preventDuplicates: false);
                          }),
              ),
              Annotation(
                regExp: AppRes.urlRegex,
                spanBuilder: ({required String text, TextStyle? textStyle}) =>
                    TextSpan(
                        text: text,
                        style: textStyle?.copyWith(
                          color: themeAccentSolid(context),
                          fontFamily: FontRes.outFitMedium500,
                          fontSize: 15,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await text.lunchUrlWithHttps;
                          }),
              ),
              Annotation(
                regExp: AppRes.userNameRegex,
                spanBuilder: ({required String text, TextStyle? textStyle}) {
                  return TextSpan(
                    text: text,
                    style: textStyle?.copyWith(
                      color: widget.mentionTextColor ?? blueFollow(context),
                      fontFamily: FontRes.outFitMedium500,
                      fontSize: 15,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        String id = text.replaceAll('@', '');
                        User? mentionUser = widget.mentionUsers
                            .firstWhereOrNull(
                                (element) => element.username == id);
                        if (mentionUser != null) {
                          NavigationService.shared
                              .openProfileScreen(mentionUser);
                        }
                      },
                  );
                },
              ),
            ],
          ),
          if (widget.metadata != null) UrlCard(metadata: widget.metadata)
        ],
      ),
    );
  }
}

class PostImageView extends StatelessWidget {
  final Post post;
  final double height;
  final EdgeInsets? margin;
  final double? radius;
  final Function(TapDownDetails)? onDoubleTap;
  final void Function()? onHeartAnimationEnd;

  const PostImageView(
      {super.key,
      required this.post,
      this.height = 300,
      this.margin,
      this.radius,
      this.onHeartAnimationEnd,
      this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    RxInt selectedIndex = 0.obs;
    PageController controller = PageController();
    GlobalKey uniqueTag = GlobalKey();
    return DoubleTapDetector(
      onDoubleTap: (details) {
        if (onDoubleTap != null) {
          onDoubleTap?.call(details);
        }
      },
      child: Container(
        margin: margin ?? const EdgeInsets.only(right: 10.0, top: 10),
        constraints: BoxConstraints(
            maxHeight: height,
            minHeight: height,
            maxWidth: MediaQuery.of(context).size.width,
            minWidth: MediaQuery.of(context).size.width),
        child: ClipSmoothRect(
          radius:
              SmoothBorderRadius(cornerRadius: radius ?? 8, cornerSmoothing: 1),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: controller,
                onPageChanged: (value) {
                  selectedIndex.value = value;
                },
                itemCount: (post.images ?? []).length,
                itemBuilder: (context, index) {
                  Images? image = post.images?[index];
                  return Hero(
                    tag: '${uniqueTag}_${image?.image}',
                    child: CustomImage(
                        size: Size(MediaQuery.of(context).size.width, 300),
                        image: image?.image?.addBaseURL(),
                        radius: 0,
                        isShowPlaceHolder: true,
                        cornerSmoothing: 1),
                  );
                },
              ),
              if ((post.images ?? []).length > 1)
                CustomPageIndicator(
                    length: (post.images ?? []).length,
                    selectedIndex: selectedIndex),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: InkWell(
                  onTap: () {
                    context.pushTransparentRoute(ImageViewScreen(
                      images: post.images ?? [],
                      selectedIndex: selectedIndex.value,
                      onChanged: (position) {
                        controller.jumpToPage(position);
                      },
                      tag: '$uniqueTag',
                    ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomBgCircleButton(
                        image: AssetRes.icExpand, size: Size(30, 30)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PostVideoView extends StatelessWidget {
  final Post? post;
  final EdgeInsets? margin;
  final double? radius;
  final Function(TapDownDetails)? onDoubleTap;
  final void Function()? onHeartAnimationEnd;
  final bool isFromChat;

  const PostVideoView(
      {super.key,
      required this.post,
      this.onHeartAnimationEnd,
      this.onDoubleTap,
      this.margin,
      this.radius,
      this.isFromChat = false});

  @override
  Widget build(BuildContext context) {
    return DoubleTapDetector(
      onDoubleTap: (details) {
        if (onDoubleTap != null) {
          onDoubleTap?.call(details);
        }
      },
      onTap: isFromChat
          ? null
          : () {
              Get.to(
                  () => ReelsScreen(reels: [post!].obs, position: 0, pageType: ReelPageType.post));
            },
      child: Container(
        margin: margin ?? const EdgeInsets.only(right: 10.0, top: 10),
        constraints: BoxConstraints(
            maxHeight: 211,
            minHeight: 211,
            maxWidth: MediaQuery.of(context).size.width,
            minWidth: MediaQuery.of(context).size.width),
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
              cornerRadius: radius ?? 10, cornerSmoothing: 1),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImage(
                size: const Size(double.infinity, 211),
                fit: BoxFit.cover,
                radius: radius ?? 10,
                cornerSmoothing: 1,
                image: post?.thumbnail?.addBaseURL(),
              ),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: textDarkGrey(context).withValues(alpha: .4)),
                alignment: Alignment.center,
                child: Image.asset(AssetRes.icPlay, width: 20, height: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
