import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/navigation/navigate_with_controller.dart';
import 'package:shortzz/common/widget/custom_back_button.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/custom_tab_switcher.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/common/widget/load_more_widget.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/follow_following_screen/follow_following_screen_controller.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

enum FollowFollowingType { follower, following }

class FollowFollowingScreen extends StatelessWidget {
  final FollowFollowingType type;
  final User? user;

  const FollowFollowingScreen({super.key, required this.type, this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
        FollowFollowingScreenController(type, user, context),
        tag: '${user?.id}');
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: bgLightGrey(context)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SafeArea(
              bottom: false,
              minimum: EdgeInsets.only(top: AppBar().preferredSize.height),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CustomBackButton(
                          width: 35,
                          height: 18,
                          alignment: AlignmentDirectional.centerStart),
                      CustomImage(
                        size: const Size(48, 48),
                        fullName: user?.fullname,
                        image: user?.profilePhoto?.addBaseURL(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FullNameWithBlueTick(
                                username: user?.username ?? '', fontSize: 13),
                            Text(user?.fullname ?? '',
                                style: TextStyleCustom.outFitLight300(
                                    color: textLightGrey(context),
                                    fontSize: 15))
                          ],
                        ),
                      )
                    ],
                  ),
                  Obx(
                    () => CustomTabSwitcher(
                      items: [
                        '${controller.followerCount} ${LKey.followers.tr}',
                        '${controller.followingCount} ${LKey.following.tr}'
                      ],
                      selectedIndex: controller.selectedTabIndex,
                      onTap: controller.onChangeTab,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final isFollowersEmpty = controller.followers.isEmpty;
              final isFollowingsEmpty = controller.followings.isEmpty;
              final showFollowersLoader =
                  controller.isFollowers.value && isFollowersEmpty;
              final showFollowingsLoader =
                  controller.isFollowings.value && isFollowingsEmpty;
              final showFollowersNoData =
                  !controller.isFollowers.value && isFollowersEmpty;
              final showFollowingsNoData =
                  !controller.isFollowings.value && isFollowingsEmpty;

              return PageView(
                controller: controller.pageController,
                onPageChanged: (value) =>
                    controller.selectedTabIndex.value = value,
                children: [
                  // Followers Page
                  _buildUserList(
                    showLoader: showFollowersLoader,
                    showNoData: showFollowersNoData,
                    noDataTitle: null,
                    noDataDescription: null,
                    users: controller.followers,
                    userExtractor: (item) => item.fromUser,
                    onItemTap: controller.onFollowUnFollow,
                    loadMore: controller.fetchFollowers,
                      controller: controller.followerController),

                  // Followings Page
                  _buildUserList(
                    showLoader: showFollowingsLoader,
                    showNoData: showFollowingsNoData,
                    noDataTitle: user?.showMyFollowing == 1
                        ? LKey.nothingToShowHere.tr
                        : null,
                    noDataDescription: user?.showMyFollowing == 1
                        ? LKey.userHidFollowings.tr
                        : null,
                    users: controller.followings,
                    userExtractor: (item) => item.toUser,
                    onItemTap: controller.onFollowUnFollow,
                    loadMore: controller.fetchFollowings,
                      controller: controller.followingController),
                ],
              );
            }),
          )
        ],
      ),
    );
  }

  // Helper Widget
  Widget _buildUserList({
    required bool showLoader,
    required bool showNoData,
    required String? noDataTitle,
    required String? noDataDescription,
    required List<dynamic> users,
    required User? Function(dynamic) userExtractor,
    required Future Function(dynamic) onItemTap,
    required Future Function()? loadMore,
    required ScrollController controller,
  }) {
    if (showLoader) return const LoaderWidget();

    return NoDataView(
      showShow: showNoData,
      title: noDataTitle,
      description: noDataDescription,
      child: ListView.builder(
        controller: controller,
        itemCount: users.length,
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {
          final item = users[index];
          final user = userExtractor(item);
          final isFollow =
              user?.isFollowing == null ? true : user?.isFollowing ?? false;

          return UserProfileTile(
            actionName: ActionName.follow,
            onTap: () => onItemTap(item),
            isFollowOrIsBlock: isFollow,
            user: user,
            loadMore: index == users.length - 1 ? loadMore : null,
          );
        },
      ),
    );
  }
}

enum ActionName { follow, block }

class UserProfileTile extends StatefulWidget {
  final ActionName actionName;
  final bool isFollowOrIsBlock;
  final Future Function() onTap;
  final User? user;
  final Future<void> Function()? loadMore;

  const UserProfileTile(
      {super.key,
      required this.actionName,
      required this.isFollowOrIsBlock,
      required this.onTap,
      this.user,
      this.loadMore});

  @override
  State<UserProfileTile> createState() => _UserProfileTileState();
}

class _UserProfileTileState extends State<UserProfileTile> {
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return LoadMoreWidget(
      loadMore: widget.loadMore ?? () async {},
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      NavigationService.shared.openProfileScreen(widget.user);
                    },
                    child: Row(
                      children: [
                        CustomImage(
                            size: const Size(40, 40),
                            fullName: widget.user?.fullname,
                            image: widget.user?.profilePhoto?.addBaseURL()),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FullNameWithBlueTick(
                                username: widget.user?.username ?? '',
                                isVerify: widget.user?.isVerify,
                                fontSize: 13,
                                iconSize: 14,
                              ),
                              Text(
                                widget.user?.fullname ?? '',
                                style: TextStyleCustom.outFitLight300(
                                    color: textLightGrey(context)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.user?.id != SessionManager.instance.getUserID())
                  Obx(() {
                    Color textColor = widget.isFollowOrIsBlock
                        ? textLightGrey(context)
                        : whitePure(context);
                    return TextButtonCustom(
                      onTap: () async {
                        if (isLoading.value) return;
                        isLoading.value = true;
                        await widget.onTap();
                        isLoading.value = false;
                      },
                      title: widget.actionName == ActionName.follow
                          ? (widget.isFollowOrIsBlock
                              ? LKey.unFollow.tr
                              : LKey.follow.tr)
                          : (widget.isFollowOrIsBlock
                              ? LKey.unBlock.tr
                              : LKey.block.tr),
                      btnWidth: 100,
                      fontSize: 15,
                      horizontalMargin: 0,
                      btnHeight: 30,
                      titleColor: textColor,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      radius: 8,
                      backgroundColor: widget.isFollowOrIsBlock
                          ? whitePure(context)
                          : blueFollow(context),
                      borderSide: widget.isFollowOrIsBlock
                          ? BorderSide(color: bgGrey(context))
                          : BorderSide.none,
                      child: isLoading.value
                          ? CupertinoActivityIndicator(
                              radius: 8, color: textColor)
                          : null,
                    );
                  })
              ],
            ),
            const SizedBox(height: 10),
            const CustomDivider()
          ],
        ),
      ),
    );
  }
}
