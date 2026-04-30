import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/manager/share_manager.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/custom_popup_menu_button.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/common/widget/gradient_border.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/follow_following_screen/follow_following_screen.dart';
import 'package:shortzz/screen/level_screen/level_screen.dart';
import 'package:shortzz/screen/profile_screen/profile_screen_controller.dart';
import 'package:shortzz/screen/profile_screen/widget/profile_preview_interactive_screen.dart';
import 'package:shortzz/screen/profile_screen/widget/user_link_sheet.dart';
import 'package:shortzz/screen/settings_screen/settings_screen.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ProfileUserHeader extends StatelessWidget {
  final ProfileScreenController controller;

  const ProfileUserHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        User? user = controller.userData.value;
        bool isUserNotFound = controller.isUserNotFound.value;

        return Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              ProfileStatsRow(
                userNotFound: isUserNotFound,
                controller: controller,
                user: user,
                stats: [
                  StatItem(value: user?.totalPostLikesCount ?? 0, label: LKey.likes.tr),
                  StatItem(value: user?.followerCount ?? 0, label: LKey.followers.tr),
                  StatItem(value: user?.followingCount ?? 0, label: LKey.following.tr),
                ],
                onTap: (value) {
                  if (isUserNotFound) {
                    return;
                  }
                  switch (value) {
                    case 0:
                      break;
                    case 1:
                      user?.checkIsBlocked(() {
                        // Followers
                        Get.to(() => FollowFollowingScreen(type: FollowFollowingType.follower, user: user));
                      });
                      break;
                    case 2:
                      user?.checkIsBlocked(() {
                        // Following
                        Get.to(() => FollowFollowingScreen(type: FollowFollowingType.following, user: user));
                      });
                      break;
                  }
                },
              ),
              if (!isUserNotFound) UserNameView(user: user),
              if (!isUserNotFound) UserLinkView(user: user),
              if (!isUserNotFound) UserBioView(user: user),
              isUserNotFound ? const NoUserFoundButton() : UserButtonView(user: user, controller: controller)
            ],
          ),
        );
      },
    );
  }
}

class ProfileStatsRow extends StatelessWidget {
  final User? user;
  final List<StatItem> stats;
  final Function(int value) onTap;
  final ProfileScreenController controller;
  final bool userNotFound;

  const ProfileStatsRow({
    super.key,
    required this.user,
    required this.stats,
    required this.onTap,
    required this.controller,
    required this.userNotFound,
  });

  @override
  Widget build(BuildContext context) {
    bool isStoryAvailable = (user?.stories ?? []).isNotEmpty;
    GlobalKey previewKey = GlobalKey();
    bool isWatch = isStoryAvailable && (user?.stories ?? []).every((element) => element.isWatchedByMe());
    RxBool isHeroEnable = false.obs;
    return Row(
      children: [
        // Profile Picture
        if (userNotFound)
          Image.asset(AssetRes.icUserPlaceholder, width: 80, height: 80, fit: BoxFit.cover)
        else
          GestureDetector(
            onTap: () => controller.onStoryTap(isStoryAvailable),
            onLongPressStart: (details) {
              isHeroEnable.value = true;
            },
            onLongPressEnd: (details) {
              isHeroEnable.value = false;
            },
            onLongPress: () {
              user?.checkIsBlocked(() {
                // _showProfilePreview(context, previewKey, user);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.transparent,
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (_, __, ___) => ProfilePreviewInteractiveScreen(user: user)),
                );
              });
            },
            child: Container(
              key: previewKey,
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(cornerRadius: 90),
                ),
                gradient: isStoryAvailable
                    ? (isWatch ? StyleRes.disabledGreyGradient(opacity: .5) : StyleRes.themeGradient)
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: whitePure(context),
                ),
                child: Obx(
                  () => HeroMode(
                    enabled: isHeroEnable.value,
                    child: Hero(
                      tag: 'profile-${user?.id}',
                      // must match the original tag
                      child: CustomImage(
                        size: !isStoryAvailable ? const Size(80, 80) : const Size(70, 70),
                        // 80 - 10 (padding accounted)
                        image: user?.isBlock == true ? '' : user?.profilePhoto?.addBaseURL(),
                        // if user is block then don't show the image
                        fullName: user?.fullname,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Stats Columns
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              stats.length,
              (index) => Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => onTap(index),
                      child: StatColumn(value: stats[index].value, label: stats[index].label),
                    ),
                    if (index != stats.length - 1) Container(height: 20, width: .5, color: textLightGrey(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Individual Stat Column Widget
class StatColumn extends StatelessWidget {
  final num value;
  final String label;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const StatColumn({super.key, required this.value, required this.label, this.labelStyle, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toInt().numberFormat,
          style: valueStyle ??
              TextStyleCustom.unboundedMedium500(
                color: textDarkGrey(context),
                fontSize: 15,
              ),
        ),
        Text(label.capitalize ?? '',
            style: labelStyle ??
                TextStyleCustom.outFitLight300(
                  color: textLightGrey(context),
                  fontSize: 15,
                )),
      ],
    );
  }
}

class UserNameView extends StatelessWidget {
  final User? user;

  const UserNameView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FullNameWithBlueTick(
          username: user?.username,
          style: TextStyleCustom.unboundedSemiBold600(color: textDarkGrey(context), fontSize: 17),
          isVerify: user?.isVerify,
          iconSize: 22,
          child: user?.getLevel.id == null
              ? const SizedBox()
              : GradientBorder(
                  onPressed: () {
                    Get.to(() => LevelScreen(userLevels: user?.getLevel));
                  },
                  strokeWidth: 1.5,
                  radius: 30,
                  gradient: StyleRes.themeGradient,
                  child: Container(
                    height: 27,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: SmoothBorderRadius(cornerRadius: 30),
                        color: themeAccentSolid(context).withValues(alpha: .1)),
                    alignment: Alignment.center,
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) =>
                          StyleRes.themeGradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                      child: RichText(
                        text: TextSpan(
                          text: LKey.lvl.tr,
                          style: TextStyleCustom.outFitLight300(fontSize: 15),
                          children: [
                            TextSpan(
                                text: ' ${user?.getLevel.level ?? 0}',
                                style: TextStyleCustom.outFitBold700(fontSize: 15))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        Text(user?.fullname ?? '', style: TextStyleCustom.outFitLight300(color: textLightGrey(context), fontSize: 16))
      ],
    );
  }
}

class UserLinkView extends StatelessWidget {
  final User? user;

  const UserLinkView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    List<Link> links = user?.links ?? [];
    if (links.isNotEmpty) {
      return InkWell(
        onTap: () {
          user?.checkIsBlocked(() {
            if (links.length > 1) {
              Get.bottomSheet(UserLinkSheet(links: links),
                  isScrollControlled: true, barrierColor: blackPure(context).withValues(alpha: .7));
            } else {
              (links.first.url ?? '').lunchUrlWithHttps;
            }
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AssetRes.icLink, height: 20, width: 20, color: themeAccentSolid(context)),
            const SizedBox(width: 3),
            Expanded(
              child: Text(shortUrl,
                  style: TextStyleCustom.outFitRegular400(fontSize: 15, color: themeAccentSolid(context))),
            )
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  String get shortUrl {
    List<Link> links = user?.links ?? [];
    String firstLink = links.first.url ?? '';
    String andMore = '';
    if (firstLink.length >= 40) {
      int endCount = links.length > 1 ? 25 : 35;
      firstLink = '${firstLink.substring(0, endCount)}...';
    }
    if (links.length > 1) {
      andMore = ' & ${links.length - 1} ${LKey.more.tr.toLowerCase()}';
    }
    return '$firstLink$andMore';
  }
}

class UserBioView extends StatelessWidget {
  final User? user;

  const UserBioView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    if ((user?.bio ?? '').isEmpty) {
      return const SizedBox();
    }
    return Text(
      user?.bio ?? '',
      style: TextStyleCustom.outFitLight300(color: textLightGrey(context), fontSize: 16),
    );
  }
}

class UserButtonView extends StatelessWidget {
  final User? user;
  final ProfileScreenController controller;

  const UserButtonView({super.key, required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    User? user = controller.profileController.user;

    bool isMe = user?.id?.toInt() == SessionManager.instance.getUserID();
    bool isBlock = (user?.isBlock == true && user?.id != SessionManager.instance.getUserID());
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, top: 10),
      child: Row(
        children: [
          Expanded(
            child: isBlock
                ? UnblockButton(onTap: () => controller.toggleBlockUnblock(true))
                : RowButton(controller: controller, isMe: isMe, user: user),
          ),
          const SizedBox(width: 8),
          if (isMe)
            InkWell(
              onTap: () {
                ShareManager.shared.showCustomShareSheet(user: user, keys: ShareKeys.user);
              },
              child: Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: ShapeDecoration(
                    shape:
                        SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1)),
                    color: bgGrey(context),
                  ),
                  child: Image.asset(isMe ? AssetRes.icShare1 : AssetRes.icMore, height: 21, width: 21)),
            )
          else
            Obx(
              () => CustomPopupMenuButton(
                  items: [
                    MenuItem(user?.isBlock == true ? LKey.unBlock.tr : LKey.block.tr, () {
                      controller.toggleBlockUnblock(user?.isBlock ?? false);
                    }),
                    MenuItem(LKey.report.tr, () => controller.reportUser(user)),
                    if (SessionManager.instance.isModerator.value == 1)
                      MenuItem(user?.isFreez == 1 ? LKey.unFreeze.tr : LKey.freeze.tr,
                          () => controller.freezeUnfreezeUser(user?.isFreez == 1))
                  ],
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: ShapeDecoration(
                      shape:
                          SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1)),
                      color: bgGrey(context),
                    ),
                    child: Image.asset(AssetRes.icMore, height: 21, width: 21),
                  )),
            )
        ],
      ),
    );
  }
}

class NoUserFoundButton extends StatelessWidget {
  const NoUserFoundButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      onTap: () {},
      title: LKey.userNotFound.tr,
      btnHeight: 40,
      backgroundColor: bgMediumGrey(context),
      fontSize: 15,
      radius: 8,
      titleColor: textLightGrey(context),
      margin: const EdgeInsets.only(bottom: 10, left: 40, right: 40, top: 20),
    );
  }
}

class UnblockButton extends StatelessWidget {
  final VoidCallback onTap;

  const UnblockButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButtonCustom(
      onTap: onTap,
      title: LKey.unBlock.tr,
      fontSize: 16,
      backgroundColor: blueFollow(context),
      titleColor: whitePure(context),
      horizontalMargin: 0,
      btnHeight: 45,
    );
  }
}

class RowButton extends StatelessWidget {
  final bool isMe;
  final ProfileScreenController controller;
  final User? user;

  const RowButton({
    super.key,
    required this.isMe,
    required this.controller,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () {
              bool isFollowProgress = controller.isFollowUnFollowInProcess.value;
              Color textColor = user?.isFollowing == true ? textLightGrey(context) : whitePure(context);
              return TextButtonCustom(
                onTap: () async {
                  if (isMe) {
                    Get.to(() => SettingsScreen(onUpdateUser: controller.onUpdateUser));
                  } else {
                    if (!isFollowProgress) {
                      controller.followUnFollowUser();
                    }
                  }
                },
                title: isMe ? LKey.settings.tr : (user?.isFollowing == true ? LKey.unFollow.tr : LKey.follow.tr),
                fontSize: 16,
                backgroundColor:
                    isMe ? bgGrey(context) : (user?.isFollowing == true ? bgGrey(context) : blueFollow(context)),
                titleColor: isMe ? textLightGrey(context) : textColor,
                horizontalMargin: 0,
                btnHeight: 45,
                child: isMe
                    ? null
                    : isFollowProgress
                        ? CupertinoActivityIndicator(radius: 10, color: textColor)
                        : null,
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        if (isMe || user?.receiveMessage == 1)
          Expanded(
            child: TextButtonCustom(
                onTap: () => controller.handlePublishOrMessageBtn(isMe),
                title: isMe ? LKey.publish.tr : LKey.message.tr,
                fontSize: 16,
                backgroundColor: bgGrey(context),
                titleColor: textLightGrey(context),
                horizontalMargin: 0,
                btnHeight: 45),
          ),
      ],
    );
  }
}

// Stat Item Model
class StatItem {
  final num value;
  final String label;

  StatItem({required this.value, required this.label});
}
