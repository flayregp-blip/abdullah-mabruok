import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/enum/chat_enum.dart';
import 'package:shortzz/common/extensions/list_extension.dart';
import 'package:shortzz/common/extensions/user_extension.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/manager/story_view/add_to_cart/add_to_cart_animation.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/chat/chat_thread.dart';
import 'package:shortzz/model/post_story/story/story_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/chat_screen/chat_screen_controller.dart';
import 'package:shortzz/screen/gift_sheet/send_gift_sheet_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

import '../controller/story_controller.dart';
import '../utils.dart';
import 'story_image.dart';
import 'story_video.dart';

/// Indicates where the progress indicators should be placed.
enum ProgressPosition { top, bottom, none }

/// This is used to specify the height of the progress indicator. Inline stories
/// should use [small]
enum IndicatorHeight { small, large }

/// This is a representation of a story item (or page).
class StoryItem {
  /// Specifies how long the page should be displayed. It should be a reasonable
  /// amount of time greater than 0 milliseconds.
  final Duration duration;

  final num id;
  final List<String> viewedByUsersIds;

  /// Has this page been shown already? This is used to indicate that the page
  /// has been displayed. If some pages are supposed to be skipped in a story,
  /// mark them as shown `shown = true`.
  ///
  /// However, during initialization of the story view, all pages after the
  /// last un shown page will have their `shown` attribute altered to false. This
  /// is because the next item to be displayed is taken by the last un shown
  /// story item.
  bool shown;

  /// The page content
  final Widget view;
  final Story? story;

  StoryItem(
    this.view, {
    required this.id,
    required this.viewedByUsersIds,
    required this.duration,
    required this.story,
    this.shown = false,
  });

  /// Short hand to create text-only page.
  ///
  /// [title] is the text to be displayed on [backgroundColor]. The text color
  /// alternates between [Colors.black] and [Colors.white] depending on the
  /// calculated contrast. This is to ensure readability of text.
  ///
  /// Works for inline and full-page stories. See [StoryView.inline] for more on
  /// what inline/full-page means.
  ///
  static StoryItem text({
    required String title,
    required Color backgroundColor,
    Key? key,
    TextStyle? textStyle,
    bool shown = false,
    bool roundedTop = false,
    bool roundedBottom = false,
    required Duration duration,
    Story? story,
    num id = 0,
    List<String> viewedByUsersIds = const [],
  }) {
    double contrast = ContrastHelper.contrast([
      backgroundColor.r,
      backgroundColor.g,
      backgroundColor.b,
    ], [
      255,
      255,
      255
    ] /** white text */);

    return StoryItem(
        Container(
          key: key,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(roundedTop ? 8 : 0),
                bottom: Radius.circular(roundedBottom ? 8 : 0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Center(
            child: Text(
              title,
              style: textStyle?.copyWith(
                    color: contrast > 1.8 ? Colors.white : Colors.black,
                  ) ??
                  TextStyle(
                    color: contrast > 1.8 ? Colors.white : Colors.black,
                    fontSize: 18,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          //color: backgroundColor,
        ),
        shown: shown,
        duration: duration,
        viewedByUsersIds: viewedByUsersIds,
        id: id,
        story: story);
  }

  /// Factory constructor for page images. [controller] should be same instance as
  /// one passed to the `StoryView`
  factory StoryItem.pageImage({
    required String url,
    required StoryController controller,
    Key? key,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    Map<String, dynamic>? requestHeaders,
    required Duration duration,
    num id = 0,
    Story? story,
    List<String> viewedByUsersIds = const [],
  }) {
    return StoryItem(
        Container(
          key: key,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              StoryImage.url(
                url,
                controller: controller,
                fit: imageFit,
                requestHeaders: requestHeaders,
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      bottom: 24,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    color:
                        caption != null ? Colors.black54 : Colors.transparent,
                    child: caption != null
                        ? Text(
                            caption,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ),
                ),
              )
            ],
          ),
        ),
        shown: shown,
        viewedByUsersIds: viewedByUsersIds,
        duration: duration,
        id: id,
        story: story);
  }

  /// Shorthand for creating inline image. [controller] should be same instance as
  /// one passed to the `StoryView`
  factory StoryItem.inlineImage(
      {required String url,
      Text? caption,
      required StoryController controller,
      Key? key,
      BoxFit imageFit = BoxFit.cover,
      Map<String, dynamic>? requestHeaders,
      bool shown = false,
      bool roundedTop = true,
      bool roundedBottom = false,
      Duration? duration,
      num id = 0,
      List<String> viewedByUsersIds = const [],
      Story? story}) {
    return StoryItem(
        ClipSmoothRect(
          radius: SmoothBorderRadius.vertical(
              top: SmoothRadius(
                  cornerRadius: roundedTop ? 8 : 0, cornerSmoothing: 1),
              bottom: SmoothRadius(
                  cornerRadius: roundedBottom ? 8 : 0, cornerSmoothing: 1)),
          key: key,
          child: Container(
            color: Colors.grey[100],
            child: Container(
              color: Colors.black,
              child: Stack(
                children: <Widget>[
                  StoryImage.url(
                    url,
                    controller: controller,
                    fit: imageFit,
                    requestHeaders: requestHeaders,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        width: double.infinity,
                        child: caption ?? const SizedBox(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        shown: shown,
        viewedByUsersIds: viewedByUsersIds,
        duration: duration ?? const Duration(seconds: 3),
        id: id,
        story: story);
  }

  /// Shorthand for creating page video. [controller] should be same instance as
  /// one passed to the `StoryView`
  factory StoryItem.pageVideo(
    String url, {
    required StoryController controller,
    Key? key,
    required Duration duration,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    Map<String, dynamic>? requestHeaders,
    num id = 0,
    Story? story,
    List<String> viewedByUsersIds = const [],
  }) {
    return StoryItem(
        Container(
          key: key,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              StoryVideo.url(
                url,
                controller: controller,
                requestHeaders: requestHeaders,
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 24),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    color:
                        caption != null ? Colors.black54 : Colors.transparent,
                    child: caption != null
                        ? Text(
                            caption,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ),
                ),
              )
            ],
          ),
        ),
        shown: shown,
        viewedByUsersIds: viewedByUsersIds,
        duration: duration,
        id: id,
        story: story);
  }

  /// Shorthand for creating a story item from an image provider such as `AssetImage`
  /// or `NetworkImage`. However, the story continues to play while the image loads
  /// up.
  factory StoryItem.pageProviderImage(
    ImageProvider image, {
    Key? key,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    Duration? duration,
    num id = 0,
    Story? story,
    List<String> viewedByUsersIds = const [],
  }) {
    return StoryItem(
        Container(
          key: key,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Center(
                child: Image(
                  image: image,
                  height: double.infinity,
                  width: double.infinity,
                  fit: imageFit,
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      bottom: 24,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    color:
                        caption != null ? Colors.black54 : Colors.transparent,
                    child: caption != null
                        ? Text(
                            caption,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ),
                ),
              )
            ],
          ),
        ),
        shown: shown,
        viewedByUsersIds: viewedByUsersIds,
        duration: duration ?? const Duration(seconds: 3),
        id: id,
        story: story);
  }

  /// Shorthand for creating an inline story item from an image provider such as `AssetImage`
  /// or `NetworkImage`. However, the story continues to play while the image loads
  /// up.
  factory StoryItem.inlineProviderImage(
    ImageProvider image, {
    Key? key,
    Text? caption,
    bool shown = false,
    bool roundedTop = true,
    bool roundedBottom = false,
    Duration? duration,
    Story? story,
    num id = 0,
    List<String> viewedByUsersIds = const [],
  }) {
    return StoryItem(
        Container(
          key: key,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(roundedTop ? 8 : 0),
                bottom: Radius.circular(roundedBottom ? 8 : 0),
              ),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              )),
          child: Container(
            margin: const EdgeInsets.only(
              bottom: 16,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: double.infinity,
                child: caption ?? const SizedBox(),
              ),
            ),
          ),
        ),
        shown: shown,
        duration: duration ?? const Duration(seconds: 3),
        viewedByUsersIds: viewedByUsersIds,
        id: id,
        story: story);
  }
}

/// Widget to display stories just like Whatsapp and Instagram. Can also be used
/// inline/inside [ListView] or [Column] just like Google News app. Comes with
/// gestures to pause, forward and go to previous page.
class StoryView extends StatefulWidget {
  /// The pages to displayed.
  final List<StoryItem?> storyItems;

  /// Callback for when a full cycle of story is shown. This will be called
  /// each time the full story completes when [repeat] is set to `true`.
  final VoidCallback? onComplete;

  final VoidCallback? onBack;

  /// Callback for when a vertical swipe gesture is detected. If you do not
  /// want to listen to such event, do not provide it. For instance,
  /// for inline stories inside ListViews, it is preferable to not to
  /// provide this callback so as to enable scroll events on the list view.
  final Function(Direction?)? onVerticalSwipeComplete;

  /// Callback for when a story is currently being shown.
  final ValueChanged<StoryItem>? onStoryShow;

  /// Where the progress indicator should be placed.
  final ProgressPosition progressPosition;

  /// Should the story be repeated forever?
  final bool repeat;

  /// If you would like to display the story as full-page, then set this to
  /// `false`. But in case you would display this as part of a page (eg. in
  /// a [ListView] or [Column]) then set this to `true`.
  final bool inline;

  // Controls the playback of the stories
  final StoryController controller;

  // Indicator Color
  final Color indicatorColor;

  final Widget Function(StoryItem item)? overlayWidget;

  const StoryView(
      {super.key,
      required this.storyItems,
      required this.controller,
      this.onComplete,
      this.onStoryShow,
      this.progressPosition = ProgressPosition.top,
      this.repeat = false,
      this.inline = false,
      this.onVerticalSwipeComplete,
      this.indicatorColor = Colors.white,
      this.onBack,
      this.overlayWidget});

  @override
  State<StatefulWidget> createState() {
    return StoryViewState();
  }
}

class StoryViewState extends State<StoryView> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _currentAnimation;
  Timer? _nextDeBouncer;

  StreamSubscription<PlaybackState>? _playbackSubscription;

  TextEditingController textEditingController = TextEditingController();
  FocusNode inputNode = FocusNode();

  VerticalDragInfo? verticalDragInfo;

  StoryItem? get _currentStory {
    return widget.storyItems.firstWhereOrNull((it) => !it!.shown);
  }

  Widget get _currentView {
    var item = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    item ??= widget.storyItems.last;
    return SafeArea(
      child: ClipSmoothRect(
        radius: const SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 10, cornerSmoothing: 1)),
        child: item?.view ?? Container(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // All pages after the first unShown page should have their shown value as
    // false
    final firstPage = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    if (firstPage == null) {
      for (var it2 in widget.storyItems) {
        it2?.shown = false;
      }
    } else {
      final lastShownPos = widget.storyItems.indexOf(firstPage);
      widget.storyItems.sublist(lastShownPos).forEach((it) {
        it?.shown = false;
      });
    }

    _playbackSubscription =
        widget.controller.playbackNotifier.listen((playbackStatus) {
      switch (playbackStatus) {
        case PlaybackState.play:
          _removeNextHold();
          _animationController?.forward();
          break;

        case PlaybackState.pause:
          _holdNext(); // then pause animation
          _animationController?.stop(canceled: false);
          break;

        case PlaybackState.next:
          _removeNextHold();
          _goForward();
          break;

        case PlaybackState.previous:
          _removeNextHold();
          _goBack();
          break;
        case PlaybackState.playFromStart:
          // _goBack();
          break;
      }
    });

    _holdNext(); // then pause animation
    _animationController?.stop(canceled: false);

    _play();
  }

  @override
  void dispose() {
    _clearDeBouncer();

    _animationController?.dispose();
    _playbackSubscription?.cancel();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _play() {
    _animationController?.dispose();
    // get the next playing page
    final storyItem = widget.storyItems.firstWhere((it) {
      return !it!.shown;
    })!;

    if (widget.onStoryShow != null) {
      widget.onStoryShow!(storyItem);
    }

    _animationController =
        AnimationController(duration: storyItem.duration, vsync: this);
    _animationController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        storyItem.shown = true;
        if (widget.storyItems.last != storyItem) {
          _beginPlay();
        } else {
          // done playing
          _onComplete();
        }
      }
    });

    _currentAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController!);

    widget.controller.play();
  }

  void _beginPlay() {
    setState(() {});
    widget.controller.playFromStart();
    _play();
  }

  void _onComplete() {
    if (widget.onComplete != null) {
      widget.controller.pause();
      widget.onComplete!();
    }

    if (widget.repeat) {
      for (var it in widget.storyItems) {
        it!.shown = false;
      }

      _beginPlay();
    }
  }

  void _goBack() {
    _animationController!.stop();

    if (_currentStory == null) {
      widget.storyItems.last!.shown = false;
    }

    if (_currentStory == widget.storyItems.first) {
      _beginPlay();
      if (widget.onBack != null) {
        widget.onBack!();
      }
    } else {
      _currentStory!.shown = false;
      int lastPos = widget.storyItems.indexOf(_currentStory);
      final previous = widget.storyItems[lastPos - 1]!;

      previous.shown = false;

      _beginPlay();
    }
  }

  void _goForward() {
    if (_currentStory != widget.storyItems.last) {
      _animationController!.stop();

      // get last showing
      final last = _currentStory;

      if (last != null) {
        last.shown = true;
        if (last != widget.storyItems.last) {
          _beginPlay();
        }
      }
    } else {
      // this is the last page, progress animation should skip to end
      _animationController!
          .animateTo(1.0, duration: const Duration(milliseconds: 10));
    }
  }

  void _clearDeBouncer() {
    _nextDeBouncer?.cancel();
    _nextDeBouncer = null;
  }

  void _removeNextHold() {
    _nextDeBouncer?.cancel();
    _nextDeBouncer = null;
  }

  void _holdNext() {
    _nextDeBouncer?.cancel();
    _nextDeBouncer = Timer(const Duration(milliseconds: 500), () {});
  }

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  double currentOpacity = 1;
  RxDouble viewOpacity = 1.0.obs;
  Duration viewOpacityDuration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    var story = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    story ??= widget.storyItems.last;
    final bool isMyStory = story?.story?.user == null ||
        story?.story?.user?.id == SessionManager.instance.getUserID();
    return AddToCartAnimation(
      cartKey: cartKey,
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (cart) {
        // You can run the animation by addToCartAnimationMethod, just pass trough the the global key of  the image as parameter
        runAddToCartAnimation = cart;
      },
      child: Column(
        children: [
          KeyboardVisibilityBuilder(builder: (context, isKeyboardOn) {
            isKeyboardOn ? widget.controller.pause() : widget.controller.play();
            return Expanded(
              child: Stack(
                children: <Widget>[
                  _currentView,
                  Obx(() {
                    return AnimatedOpacity(
                      duration: viewOpacityDuration,
                      opacity: viewOpacity.value,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.4),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                      ),
                    );
                  }),
                  Obx(
                    () => AnimatedOpacity(
                      duration: viewOpacityDuration,
                      opacity: viewOpacity.value,
                      child: Visibility(
                        visible:
                            widget.progressPosition != ProgressPosition.none,
                        child: Align(
                          alignment:
                              widget.progressPosition == ProgressPosition.top
                                  ? Alignment.topCenter
                                  : Alignment.bottomCenter,
                          child: SafeArea(
                            bottom: widget.inline ? false : true,
                            // we use SafeArea here for notched and bezels phones
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: PageBar(
                                    widget.storyItems
                                        .map((it) =>
                                            PageData(it!.duration, it.shown))
                                        .toList(),
                                    _currentAnimation,
                                    key: UniqueKey(),
                                    indicatorHeight: widget.inline
                                        ? IndicatorHeight.small
                                        : IndicatorHeight.large,
                                    indicatorColor: widget.indicatorColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    heightFactor: 1,
                    child: GestureDetector(
                      onTapDown: (details) {
                        widget.controller.pause();
                        viewOpacity.value = 0;
                        Loggers.success('onTapDown');
                      },
                      onTapCancel: () {
                        widget.controller.play();
                        Loggers.success('onTapCancel');
                        viewOpacity.value = 1;
                      },
                      onTapUp: (details) {
                        // if debounce timed out (not active) then continue anim
                        if (_nextDeBouncer?.isActive == false) {
                          widget.controller.play();
                        } else {
                          final tapX = details.localPosition.dx;
                          final widgetWidth = MediaQuery.of(context).size.width;

                          if (tapX < widgetWidth / 2) {
                            // Tap on left side
                            widget.controller.previous();
                            debugPrint('Tapped Left');
                          } else {
                            // Tap on right side
                            widget.controller.next();
                            debugPrint('Tapped Right');
                          }
                        }
                        viewOpacity.value = 1;
                      },
                    ),
                  ),
                  if (widget.overlayWidget != null && story != null)
                    SafeArea(
                      child: Obx(
                        () => AnimatedOpacity(
                            opacity: viewOpacity.value,
                            duration: viewOpacityDuration,
                            child: widget.overlayWidget!(story!)),
                      ),
                    ),
                  // Animation to show the cart icon
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 8),
                      child: AddToCartIcon(
                        cartKey: cartKey,
                        icon: Container(
                            width: 20, height: 20, color: Colors.transparent),
                        badgeOptions: const BadgeOptions(
                            active: true,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isKeyboardOn,
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Container(
                        color: Colors.black
                            .withValues(alpha: isKeyboardOn ? 0.6 : 0),
                        alignment: Alignment.center,
                        child: GridView.builder(
                          primary: false,
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 1),
                          itemCount: AppRes.storyQuickReplyEmojis.length,
                          itemBuilder: (BuildContext context, int index) {
                            GlobalKey widgetKey = GlobalKey();
                            return InkWell(
                              onTap: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                currentOpacity = 0;
                                setState(() {});
                                HapticFeedback.mediumImpact();
                                await runAddToCartAnimation(widgetKey);
                                currentOpacity = 1;
                                await cartKey.currentState
                                    ?.runClearCartAnimation();
                                if (story != null) {
                                  if (isMyStory) return;
                                  sendReply(
                                      textReply:
                                          AppRes.storyQuickReplyEmojis[index],
                                      item: story);
                                }
                              },
                              child: AnimatedOpacity(
                                opacity: currentOpacity,
                                duration: const Duration(milliseconds: 1500),
                                child: Container(
                                  key: widgetKey,
                                  margin: const EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppRes.storyQuickReplyEmojis[index],
                                    style: const TextStyle(
                                        fontSize: 40, color: Colors.black),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          isMyStory
              ? const SizedBox(height: 48)
              : Obx(
                  () => AnimatedOpacity(
                    duration: viewOpacityDuration,
                    opacity: viewOpacity.value,
                    child: StoryBottomVIew(
                      textEditingController: textEditingController,
                      onSendTap: () {
                        if (isMyStory) return;
                        if (story != null) {
                          sendReply(
                            item: story,
                            textReply: textEditingController.text.trim(),
                          );
                        }
                      },
                      onGiftTap: () {
                        if (isMyStory) return;
                        onGiftTap(story);
                      },
                    ),
                  ),
                )
        ],
      ),
    );
  }

  void onGiftTap(StoryItem? story) {
    FocusManager.instance.primaryFocus?.unfocus();
    widget.controller.pause();

    if (story == null) {
      return widget.controller.play();
    }

    GiftManager.openGiftSheet(
        userId: story.story?.userId ?? -1,
        onCompletion: (giftManager) {
          widget.controller.play();
          sendReply(
              textReply: '',
              item: story,
              imageReply: jsonEncode(giftManager.gift.toJson()));
        }).then((value) {
      widget.controller.play();
    });
  }

  void sendReply(
      {required StoryItem item,
      required String textReply,
      String? imageReply}) {
    if (textReply.isEmpty && imageReply == null) return;
    User? user = item.story?.user;
    ChatThread conversation = ChatThread(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        lastMsg: '',
        msgCount: 0,
        isDeleted: false,
        deletedId: 0,
        iAmBlocked: false,
        iBlocked: user?.isBlock ?? false,
        requestType: UserRequestAction.accept.title,
        chatType:
            user?.isFollowing ?? false ? ChatType.approved : ChatType.request,
        conversationId:
            [SessionManager.instance.getUserID(), user?.id].conversationId,
        userId: user?.id);
    conversation.chatUser = user?.appUser;

    var chattingController = Get.put(ChatScreenController(conversation.obs),
        tag: '${conversation.conversationId}');
    if (item.story != null) {
      HapticFeedback.mediumImpact();
      chattingController.sendStoryReply(
          story: item.story!, textReply: textReply, imageReply: imageReply);
      textEditingController.text = '';
      FocusManager.instance.primaryFocus?.unfocus();
      BaseController.share.showSnackBar(LKey.messageSent.tr);
    }
  }
}

class StoryBottomVIew extends StatelessWidget {
  final TextEditingController textEditingController;
  final VoidCallback onSendTap;
  final VoidCallback onGiftTap;

  const StoryBottomVIew(
      {super.key,
      required this.textEditingController,
      required this.onSendTap,
      required this.onGiftTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: ShapeDecoration(
                    shape: SmoothRectangleBorder(
                        borderRadius: SmoothBorderRadius(cornerRadius: 30),
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: .18))),
                  ),
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                      border: InputBorder.none,
                      hintText: '${LKey.whatDoYouThink.tr}..',
                      hintStyle: TextStyleCustom.outFitLight300(
                          color: Colors.white, fontSize: 17, opacity: .42),
                      suffixIconConstraints: const BoxConstraints(),
                      suffixIcon: InkWell(
                        onTap: onSendTap,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            LKey.send.tr,
                            style: TextStyleCustom.unboundedMedium500(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    style: TextStyleCustom.outFitRegular400(
                        color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              InkWell(
                onTap: onGiftTap,
                child: Container(
                  height: 37,
                  width: 37,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 1.5, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: StyleRes.themeGradient,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(AssetRes.icGift,
                      height: 20, width: 20, color: whitePure(context)),
                ),
              )
            ],
          ),
        ));
  }
}

/// Capsule holding the duration and shown property of each story. Passed down
/// to the pages bar to render the page indicators.
class PageData {
  Duration duration;
  bool shown;

  PageData(this.duration, this.shown);
}

/// Horizontal bar displaying a row of [StoryProgressIndicator] based on the
/// [pages] provided.
class PageBar extends StatefulWidget {
  final List<PageData> pages;
  final Animation<double>? animation;
  final IndicatorHeight indicatorHeight;
  final Color indicatorColor;

  const PageBar(
    this.pages,
    this.animation, {
    this.indicatorHeight = IndicatorHeight.large,
    this.indicatorColor = Colors.white,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return PageBarState();
  }
}

class PageBarState extends State<PageBar> {
  double spacing = 4;

  @override
  void initState() {
    super.initState();

    int count = widget.pages.length;
    spacing = (count > 15) ? 1 : ((count > 10) ? 2 : 4);

    widget.animation!.addListener(() {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isPlaying(PageData page) {
    return widget.pages.firstWhereOrNull((it) => !it.shown) == page;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.pages.map((it) {
        return Expanded(
          child: Container(
            padding:
                EdgeInsets.only(right: widget.pages.last == it ? 0 : spacing),
            child: StoryProgressIndicator(
              isPlaying(it) ? widget.animation!.value : (it.shown ? 1 : 0),
              indicatorHeight:
                  widget.indicatorHeight == IndicatorHeight.large ? 5 : 3,
              indicatorColor: widget.indicatorColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Custom progress bar. Supposed to be lighter than the
/// original [ProgressIndicator], and rounded at the sides.
class StoryProgressIndicator extends StatelessWidget {
  /// From `0.0` to `1.0`, determines the progress of the indicator
  final double value;
  final double indicatorHeight;
  final Color indicatorColor;

  const StoryProgressIndicator(
    this.value, {
    super.key,
    this.indicatorHeight = 5,
    this.indicatorColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromHeight(
        indicatorHeight,
      ),
      foregroundPainter: IndicatorOval(
        indicatorColor.withValues(alpha: 0.8),
        value,
      ),
      painter: IndicatorOval(
        indicatorColor.withValues(alpha: 0.4),
        1.0,
      ),
    );
  }
}

class IndicatorOval extends CustomPainter {
  final Color color;
  final double widthFactor;

  IndicatorOval(this.color, this.widthFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width * widthFactor, size.height),
            const Radius.circular(3)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/// Concept source: https://stackoverflow.com/a/9733420
class ContrastHelper {
  static double luminance(int? r, int? g, int? b) {
    final a = [r, g, b].map((it) {
      double value = it!.toDouble() / 255.0;
      return value <= 0.03928
          ? value / 12.92
          : pow((value + 0.055) / 1.055, 2.4);
    }).toList();

    return a[0] * 0.2126 + a[1] * 0.7152 + a[2] * 0.0722;
  }

  static double contrast(rgb1, rgb2) {
    return luminance(rgb2[0], rgb2[1], rgb2[2]) /
        luminance(rgb1[0], rgb1[1], rgb1[2]);
  }
}
