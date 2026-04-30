import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/follow_controller.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/service/navigation/navigate_with_controller.dart';
import 'package:shortzz/common/widget/confirmation_dialog.dart';
import 'package:shortzz/common/widget/custom_back_button.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/livestream/livestream_user_state.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/host/widget/live_stream_host_top_view.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/livestream_screen_controller.dart';
import 'package:shortzz/screen/profile_screen/widget/profile_user_header.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LiveStreamUserInfoSheet extends StatefulWidget {
  final bool isAudience;
  final AppUser? liveUser;
  final LivestreamScreenController controller;

  const LiveStreamUserInfoSheet(
      {super.key,
      required this.isAudience,
      this.liveUser,
      required this.controller});

  @override
  State<LiveStreamUserInfoSheet> createState() =>
      _LiveStreamUserInfoSheetState();
}

class _LiveStreamUserInfoSheetState extends State<LiveStreamUserInfoSheet> {
  Rx<User?> user = Rx(null);
  RxBool isLoading = true.obs;
  RxBool isFollowUnFollowInProcess = false.obs;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  _fetchUserProfile() async {
    isLoading.value = true;
    user.value = widget.controller.usersList
        .firstWhereOrNull((element) => element.id == widget.liveUser?.userId);
    if (user.value != null) {
      isLoading.value = false;
    }
    user.value = await UserService.instance
        .fetchUserDetails(userId: widget.liveUser?.userId);
    isLoading.value = false;
    if (user.value != null) {
      bool isExist = widget.controller.usersList
          .any((element) => element.id == widget.liveUser?.userId);
      if (isExist) {
        int index = widget.controller.usersList
            .indexWhere((element) => element.id == widget.liveUser?.userId);
        if (index != -1) {
          widget.controller.usersList[index] = user.value!;
        }
      } else {
        widget.controller.usersList.add(user.value!);
      }
    }
  }

  Future<void> followUnFollowUser() async {
    int userId = user.value?.id ?? -1;
    if (isFollowUnFollowInProcess.value) return;
    isFollowUnFollowInProcess.value = true;
    FollowController followController;
    if (Get.isRegistered<FollowController>(tag: userId.toString())) {
      followController = Get.find<FollowController>(tag: userId.toString());
      followController.updateUser(user.value);
    } else {
      followController =
          Get.put(FollowController(user), tag: userId.toString());
    }

    User? updateUser = await followController.followUnFollowUser();
    widget.controller
        .updateUserStateToFirestore(userId, isFollow: updateUser?.isFollowing);
    isFollowUnFollowInProcess.value = false;
    user.update((val) {
      val?.isFollowing = updateUser?.isFollowing;
      val?.followerCount = updateUser?.followerCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: ShapeDecoration(
            shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.vertical(
                  top: SmoothRadius(cornerRadius: 40, cornerSmoothing: 1)),
            ),
            color: scaffoldBackgroundColor(context),
          ),
          child: SafeArea(
            top: false,
            child: Obx(() {
              User? user = this.user.value;
              bool isFollow = user?.isFollowing ?? false;
              List<StatItem> statItems = [
                StatItem(
                    value: user?.totalPostLikesCount ?? 0,
                    label: LKey.likes.tr),
                StatItem(
                    value: user?.followerCount ?? 0, label: LKey.followers.tr),
                StatItem(
                    value: user?.followingCount ?? 0, label: LKey.following.tr),
              ];

              return isLoading.value
                  ? const LoaderWidget()
                  : Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Column(
                            children: [
                              const CustomDivider(width: 100),
                              const SizedBox(height: 10),
                              CustomImage(
                                  size: const Size(93, 93),
                                  image: user?.profilePhoto?.addBaseURL(),
                                  fullName: user?.fullname),
                              const SizedBox(height: 10),
                              FullNameWithBlueTick(
                                  username: user?.username,
                                  isVerify: user?.isVerify,
                                  fontSize: 14,
                                  iconSize: 18),
                              Text(
                                user?.fullname ?? '',
                                style: TextStyleCustom.outFitRegular400(
                                    fontSize: 16,
                                    color: textLightGrey(context)),
                              ),
                              if ((user?.bio ?? '').isNotEmpty)
                                const SizedBox(height: 18),
                              if ((user?.bio ?? '').isNotEmpty)
                                Text(
                                  user?.bio ?? '',
                                  style: TextStyleCustom.outFitLight300(
                                      fontSize: 15,
                                      color: textLightGrey(context)),
                                  textAlign: TextAlign.center,
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children:
                                      List.generate(statItems.length, (index) {
                                    StatItem item = statItems[index];
                                    return Expanded(
                                      child: StatColumn(
                                        value: item.value,
                                        label: item.label,
                                        valueStyle: TextStyleCustom
                                            .unboundedSemiBold600(
                                          color: textDarkGrey(context),
                                          fontSize: 16,
                                        ),
                                        labelStyle:
                                            TextStyleCustom.outFitRegular400(
                                                color: textLightGrey(context),
                                                fontSize: 15),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              if (widget.liveUser?.userId !=
                                  SessionManager.instance.getUserID())
                                Row(
                                  spacing: 10,
                                  children: [
                                    if (widget.isAudience)
                                      Expanded(
                                        child: TextButtonCustom(
                                          onTap: () {
                                            Get.back();
                                            Get.bottomSheet(ConfirmationSheet(
                                                title: LKey.exitLiveStream.tr,
                                                description: LKey
                                                    .ifYouCheckThisProfileEtc
                                                    .tr,
                                                onTap: () {
                                                  Get.back();

                                                  NavigationService.shared
                                                      .openProfileScreen(user);
                                                }));
                                          },
                                          title: LKey.checkProfile.tr,
                                          titleColor: textLightGrey(context),
                                          backgroundColor:
                                              bgMediumGrey(context),
                                          horizontalMargin: 0,
                                        ),
                                      ),
                                    Expanded(
                                      child: isFollowUnFollowInProcess.value
                                          ? const LoaderWidget()
                                          : TextButtonCustom(
                                              onTap: followUnFollowUser,
                                              title: isFollow
                                                  ? LKey.unFollow.tr
                                                  : LKey.follow.tr,
                                              titleColor: isFollow
                                                  ? textLightGrey(context)
                                                  : whitePure(context),
                                              backgroundColor: isFollow
                                                  ? bgGrey(context)
                                                  : blueFollow(context),
                                              horizontalMargin: 0),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 10),
                              if (!widget.isAudience)
                                Obx(() {
                                  LivestreamUserState? state = widget
                                      .controller.liveUsersStates
                                      .firstWhere(
                                    (element) {
                                      return element.userId ==
                                          widget.liveUser?.userId;
                                    },
                                  );

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      LiveStreamCircleBorderButton(
                                        image: state.audioStatus !=
                                                VideoAudioStatus.on
                                            ? AssetRes.icMicOff
                                            : AssetRes.icMicrophone,
                                        iconColor: textLightGrey(context),
                                        borderColor: bgGrey(context),
                                        size: const Size(40, 40),
                                        onTap: () => widget.controller
                                            .coHostAudioToggle(state),
                                      ),
                                      LiveStreamCircleBorderButton(
                                        image: state.videoStatus !=
                                                VideoAudioStatus.on
                                            ? AssetRes.icVideoOff
                                            : AssetRes.icVideoCamera,
                                        iconColor: textLightGrey(context),
                                        borderColor: bgGrey(context),
                                        size: const Size(40, 40),
                                        onTap: () => widget.controller
                                            .coHostVideoToggle(state),
                                      ),
                                      LiveStreamCircleBorderButton(
                                        image: AssetRes.icDelete1,
                                        iconColor: ColorRes.likeRed,
                                        borderColor: ColorRes.likeRed,
                                        size: const Size(40, 40),
                                        onTap: () {
                                          Get.back();
                                          widget.controller.coHostDelete(state);
                                        },
                                      ),
                                    ],
                                  );
                                })
                            ],
                          ),
                        ),
                        const CustomBackButton(
                            image: AssetRes.icClose,
                            width: 23,
                            height: 23,
                            padding: EdgeInsets.all(10))
                      ],
                    );
            }),
          ),
        ),
      ],
    );
  }
}
