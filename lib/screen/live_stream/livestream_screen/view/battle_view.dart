import 'dart:math';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/extensions/duration_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/livestream/livestream.dart';
import 'package:shortzz/model/livestream/livestream_user_state.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/livestream_screen_controller.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/view/livestream_view.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class BattleView extends StatefulWidget {
  final bool isAudience;
  final LivestreamScreenController controller;
  final EdgeInsets? margin;

  const BattleView(
      {super.key,
      this.isAudience = false,
      required this.controller,
      this.margin});

  @override
  State<BattleView> createState() => _BattleViewState();
}

class _BattleViewState extends State<BattleView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            LiveBattleOverlayWidget(
                controller: widget.controller, margin: widget.margin),
            Obx(() => BattleTimer(
                controller: widget.controller,
                livestream: widget.controller.liveData.value)),
          ],
        ),
      ),
    );
  }
}

class LiveBattleOverlayWidget extends StatefulWidget {
  final LivestreamScreenController controller;
  final EdgeInsets? margin;

  const LiveBattleOverlayWidget(
      {super.key, required this.controller, this.margin});

  @override
  State<LiveBattleOverlayWidget> createState() =>
      _LiveBattleOverlayWidgetState();
}

class _LiveBattleOverlayWidgetState extends State<LiveBattleOverlayWidget> {
  List<StreamView> streamViews = [];

  @override
  void initState() {
    super.initState();
    streamViews = widget.controller.streamViews;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Livestream stream = widget.controller.liveData.value;
      List<LivestreamUserState> userStates = widget.controller.liveUsersStates;
      List<AppUser> liveUsers = widget.controller.firestoreController.users;

      // Host
      LivestreamUserState? hostState;
      AppUser? hostUser;
      if (streamViews.isNotEmpty) {
        hostState = userStates.firstWhereOrNull(
          (e) => '${e.userId}' == streamViews[0].streamId,
        );
        hostUser = hostState?.getUser(liveUsers);
      }

      // Co-host
      LivestreamUserState? coHostState;
      AppUser? coHostUser;
      if (streamViews.length > 1) {
        coHostState = userStates.firstWhereOrNull(
          (e) => '${e.userId}' == streamViews[1].streamId,
        );
        coHostUser = coHostState?.getUser(liveUsers);
      }

      // User list
      List<AppUser> users = [
        if (hostUser != null) hostUser,
        if (coHostUser != null) coHostUser,
      ];

      // Battle coins
      int red = hostState?.currentBattleCoin ?? 0;
      int blue = coHostState?.currentBattleCoin ?? 0;

      return SafeArea(
        bottom: false,
        child: Container(
          height: Get.height / 2.4,
          width: Get.width,
          margin: widget.margin,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15.0, bottom: 30),
                child: Row(
                  children: List.generate(
                    streamViews.length,
                    (index) {
                      return Expanded(
                        child: LiveStreamUserView(
                          isNameAndSpeakerVisible: false,
                          controller: widget.controller,
                          streamingView: streamViews[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
              BuildProgressBar(red: red, blue: blue),
              BuildStates(red: red, blue: blue, users: users, stream: stream),
              BuildLastTenSecondView(controller: widget.controller),
            ],
          ),
        ),
      );
    });
  }
}

class BuildProgressBar extends StatelessWidget {
  final int red;
  final int blue;

  const BuildProgressBar({super.key, required this.red, required this.blue});

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final total = red + blue == 0 ? 1 : red + blue; // prevent division by zero

    final redWidth = (width * red) / total;
    final blueWidth = (width * blue) / total;
    final alignmentX = ((redWidth / width) * 2) - 1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  height: 10,
                  width: redWidth,
                  color: ColorRes.likeRed,
                  duration: const Duration(milliseconds: 200),
                ),
                AnimatedContainer(
                  height: 10,
                  width: blueWidth,
                  color: ColorRes.battleProgressColor,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
            AnimatedAlign(
              alignment: Alignment(alignmentX, 0),
              duration: const Duration(milliseconds: 200),
              child: Container(
                height: 30,
                width: 30,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: whitePure(context),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Image.asset(AssetRes.icCrown, height: 14, width: 19),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BuildStates extends StatelessWidget {
  final int red;
  final int blue;
  final List<AppUser> users;
  final Livestream stream;

  const BuildStates(
      {super.key,
      required this.red,
      required this.blue,
      required this.users,
      required this.stream});

  @override
  Widget build(BuildContext context) {
    bool isRedWin = red >= blue;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // coin view
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCoinStats(context, topRight: true, coin: red),
                  _buildCoinStats(context, topRight: false, coin: blue),
                ],
              ),
              // winner tag
              if (stream.battleType == BattleType.end)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWinnerTag(context,
                        rightSide: false, winnerTag: isRedWin),
                    _buildWinnerTag(context,
                        rightSide: true, winnerTag: !isRedWin),
                  ],
                ),
              // profile name both user
              if (users.length == 2)
                Container(
                  height: 60,
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      _buildStreamerInfo(context, isLeft: true, user: users[0]),
                      _buildStreamerInfo(context, isLeft: false, user: users[1])
                    ],
                  ),
                )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(AssetRes.icBattleVs, height: 80, width: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinStats(BuildContext context,
      {required bool topRight, required int coin}) {
    return Container(
      height: 26,
      constraints: const BoxConstraints(minWidth: 90, maxWidth: 150),
      decoration: ShapeDecoration(
        color: whitePure(context),
        shape: SmoothRectangleBorder(
          borderRadius: topRight
              ? const SmoothBorderRadius.only(
                  topRight: SmoothRadius(cornerRadius: 40, cornerSmoothing: 0))
              : const SmoothBorderRadius.only(
                  topLeft: SmoothRadius(cornerRadius: 40, cornerSmoothing: 0)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        mainAxisAlignment:
            topRight ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (topRight) Image.asset(AssetRes.icCoin, height: 18, width: 18),
          Text(
            coin.numberFormat,
            style: TextStyleCustom.outFitMedium500(
              fontSize: 13,
              color: textDarkGrey(context),
            ),
          ),
          if (!topRight) Image.asset(AssetRes.icCoin, height: 18, width: 18),
        ],
      ),
    );
  }

  Widget _buildWinnerTag(BuildContext context,
      {required bool rightSide, required bool winnerTag}) {
    return Expanded(
      child: Container(
        height: 31,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: rightSide
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
              winnerTag ? ColorRes.green : ColorRes.likeRed,
              Colors.transparent,
            ],
                begin: !rightSide
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                end: !rightSide
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd)),
        child: Text(
          (winnerTag ? LKey.victory.tr : LKey.defeat.tr).toUpperCase(),
          style: TextStyleCustom.unboundedBlack900(
              color: winnerTag ? ColorRes.green1 : ColorRes.likeRed,
              fontSize: 17),
        ),
      ),
    );
  }

  Widget _buildStreamerInfo(BuildContext context,
      {required bool isLeft, required AppUser user}) {
    return Expanded(
      child: Container(
        height: 43,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        color: isLeft ? ColorRes.likeRed : ColorRes.battleProgressColor,
        child: Row(
          mainAxisAlignment:
              isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (isLeft)
              CustomImage(
                size: const Size(30, 30),
                strokeColor: whitePure(context),
                strokeWidth: 1.5,
                image: user.profile?.addBaseURL(),
                fullName: user.fullname,
              ),
            SizedBox(width: !isLeft ? 30 : 5),
            Flexible(
              child: Text(user.username ?? '',
                  style: TextStyleCustom.unboundedMedium500(
                      color: whitePure(context), fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            SizedBox(width: isLeft ? 30 : 5),
            if (!isLeft)
              CustomImage(
                size: const Size(30, 30),
                strokeColor: whitePure(context),
                strokeWidth: 1.5,
                image: user.profile?.addBaseURL(),
                fullName: user.fullname,
              ),
          ],
        ),
      ),
    );
  }
}

class BuildLastTenSecondView extends StatefulWidget {
  final LivestreamScreenController controller;

  const BuildLastTenSecondView({super.key, required this.controller});

  @override
  State<BuildLastTenSecondView> createState() => _BuildLastTenSecondViewState();
}

class _BuildLastTenSecondViewState extends State<BuildLastTenSecondView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    Loggers.error('Dispose');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Livestream stream = widget.controller.liveData.value;
      bool isBattleEnd = stream.battleType == BattleType.end;
      int leftSecond = widget.controller.remainingBattleSeconds.value;

      if (leftSecond == 0 || isBattleEnd) {
        return const SizedBox();
      }
      if (leftSecond <= 10) {
        return Align(
          alignment: const Alignment(0, -0.2),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => Container(
              height: 150,
              width: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                    colors: <Color>[
                      whitePure(context).withValues(alpha: 0),
                      whitePure(context).withValues(alpha: .5)
                    ],
                    transform:
                        GradientRotation(2 * pi * _animationController.value)),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Text('$leftSecond',
                    style: TextStyleCustom.unboundedBlack900(
                        color: whitePure(context), fontSize: 100),
                    key: ValueKey<int>(leftSecond)),
              ),
            ),
          ),
        );
      }
      return const SizedBox();
    });
  }
}

class BattleTimer extends StatefulWidget {
  final LivestreamScreenController controller;
  final Livestream livestream;

  const BattleTimer(
      {super.key, required this.controller, required this.livestream});

  @override
  State<BattleTimer> createState() => _BattleTimerState();
}

class _BattleTimerState extends State<BattleTimer> {
  @override
  void initState() {
    super.initState();
    widget.controller.battleRunning();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int leftSecond = widget.controller.remainingBattleSeconds.value;
      Duration duration = Duration(seconds: leftSecond);
      Livestream stream = widget.controller.liveData.value;
      bool isBattleEnd = stream.battleType == BattleType.end;

      return AnimatedOpacity(
        opacity: isBattleEnd
            ? 0
            : leftSecond <= 0
                ? 0
                : 1,
        duration: const Duration(milliseconds: 250),
        child: FittedBox(
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: whitePure(context),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text(
              duration.printDuration,
              style: TextStyleCustom.unboundedMedium500(
                  color: isBattleEnd
                      ? ColorRes.likeRed
                      : themeAccentSolid(context),
                  fontSize: 18),
            ),
          ),
        ),
      );
    });
  }
}
