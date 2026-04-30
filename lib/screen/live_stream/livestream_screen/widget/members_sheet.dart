import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/list_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/custom_search_text_field.dart';
import 'package:shortzz/common/widget/custom_tab_switcher.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/livestream/livestream_user_state.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/livestream_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class MembersSheet extends StatefulWidget {
  final bool isHost;

  const MembersSheet({super.key, required this.isHost});

  @override
  State<MembersSheet> createState() => _MembersSheetState();
}

class _MembersSheetState extends State<MembersSheet> {
  final controller = Get.find<LivestreamScreenController>();
  final PageController pageController = PageController(initialPage: 0);
  final RxInt selectedTab = 0.obs;

  void onSelectedTab(int index) {
    selectedTab.value = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2),
      decoration: ShapeDecoration(
        color: whitePure(context),
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.vertical(
              top: SmoothRadius(cornerRadius: 30, cornerSmoothing: 1)),
        ),
      ),
      child: Obx(() {
        return Column(
          children: [
            BottomSheetTopView(
                title: LKey.members.tr, sideBtnVisibility: false),
            if (widget.isHost)
              CustomTabSwitcher(
                items: [
                  LKey.requests.tr,
                  LKey.audience.tr,
                  LKey.invited.tr,
                  LKey.coHosts.tr
                ],
                onTap: onSelectedTab,
                selectedIndex: selectedTab,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                backgroundColor: bgLightGrey(context),
                selectedFontColor: themeAccentSolid(context),
              ),
            Obx(() => (selectedTab.value == 2 || selectedTab.value == 3)
                ? const SizedBox()
                : CustomSearchTextField(
                    backgroundColor: bgLightGrey(context),
                    onChanged: (value) {
                      DebounceAction.shared.call(() {
                        List<LivestreamUserState> itemList = [];
                        itemList =
                            controller.liveUsersStates.search(value, (p0) {
                          AppUser? data =
                              p0.getUser(controller.firestoreController.users);
                          return data?.username ?? '';
                        }, (p1) {
                          AppUser? data =
                              p1.getUser(controller.firestoreController.users);
                          return data?.fullname ?? '';
                        });
                        if (widget.isHost) {
                          if (selectedTab.value == 0) {
                            controller.requestList.value = itemList
                                .where((element) =>
                                    element.type ==
                                    LivestreamUserType.requested)
                                .toList();
                          } else if (selectedTab.value == 1) {
                            controller.audienceList.value = itemList
                                .where((element) =>
                                    element.type != LivestreamUserType.host &&
                                    element.type != LivestreamUserType.left)
                                .toList();
                          }
                        } else {
                          controller.audienceMemberList.value = itemList
                              .where((element) =>
                                  element.type != LivestreamUserType.left)
                              .toList();
                        }
                      }, milliseconds: 500);
                    },
                  )),
            Expanded(
              child: !widget.isHost
                  ? NoDataView(
                      showShow: controller.audienceMemberList.isEmpty,
                      title: LKey.userListEmptyTitle.tr,
                      description: LKey.userListEmptyDescription.tr,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller.audienceMemberList.length,
                        itemBuilder: (context, index) {
                          final state = controller.audienceMemberList[index];
                          final user = controller.firestoreController.users
                              .firstWhereOrNull(
                                  (element) => element.userId == state.userId);
                          final bool isInvited =
                              state.type == LivestreamUserType.invited;
                          return MemberProfileCard(
                              user: user,
                              widget:
                                  _buildActionWidget(state, user, isInvited));
                        },
                      ),
                    )
                  : PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        selectedTab.value = value;
                      },
                      children: [
                        NoDataView(
                          showShow: controller.requestList.isEmpty,
                          title: LKey.requestTitle.tr,
                          description: LKey.requestDescription.tr,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: controller.requestList.length,
                            itemBuilder: (context, index) {
                              final state = controller.requestList[index];
                              final user = controller.firestoreController.users
                                  .firstWhereOrNull((element) =>
                                      element.userId == state.userId);
                              final bool isInvited =
                                  state.type == LivestreamUserType.invited;
                              return MemberProfileCard(
                                user: user,
                                widget:
                                    _buildActionWidget(state, user, isInvited),
                              );
                            },
                          ),
                        ),
                        NoDataView(
                          showShow: controller.audienceList.isEmpty,
                          title: LKey.audienceListEmptyTitle.tr,
                          description: LKey.audienceListEmptyDescription.tr,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: controller.audienceList.length,
                            itemBuilder: (context, index) {
                              final state = controller.audienceList[index];
                              final user = controller.firestoreController.users
                                  .firstWhereOrNull((element) =>
                                      element.userId == state.userId);
                              final bool isInvited =
                                  state.type == LivestreamUserType.invited;
                              return MemberProfileCard(
                                user: user,
                                widget:
                                    _buildActionWidget(state, user, isInvited),
                              );
                            },
                          ),
                        ),
                        NoDataView(
                          showShow: controller.invitedList.isEmpty,
                          title: LKey.invitedListEmptyTitle.tr,
                          description: LKey.invitedListEmptyDescription.tr,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: controller.invitedList.length,
                            itemBuilder: (context, index) {
                              final state = controller.invitedList[index];
                              final user = controller.firestoreController.users
                                  .firstWhereOrNull((element) =>
                                      element.userId == state.userId);
                              final bool isInvited =
                                  state.type == LivestreamUserType.invited;
                              return MemberProfileCard(
                                user: user,
                                widget:
                                    _buildActionWidget(state, user, isInvited),
                              );
                            },
                          ),
                        ),
                        NoDataView(
                          showShow: controller.coHostList.isEmpty,
                          title: LKey.coHostListEmptyTitle.tr,
                          description: LKey.coHostListEmptyDescription.tr,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: controller.coHostList.length,
                            itemBuilder: (context, index) {
                              final state = controller.coHostList[index];
                              final user = controller.firestoreController.users
                                  .firstWhereOrNull((element) =>
                                      element.userId == state.userId);
                              final bool isInvited =
                                  state.type == LivestreamUserType.invited;
                              return MemberProfileCard(
                                user: user,
                                widget:
                                    _buildActionWidget(state, user, isInvited),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionWidget(
      LivestreamUserState state, AppUser? user, bool isInvited) {
    if (!widget.isHost) return const SizedBox();
    switch (state.type) {
      case LivestreamUserType.requested:
        return Row(
          children: [
            _buildActionBtn(AssetRes.icCheck, ColorRes.green, () {
              Get.back();
              controller.handleRequestResponse(user: user, isRefused: false);
            }),
            _buildActionBtn(AssetRes.icClose1, ColorRes.likeRed, () {
              controller.handleRequestResponse(user: user, isRefused: true);
            }),
          ],
        );
      case LivestreamUserType.audience:
        return TextBorderButton(
          text: isInvited ? LKey.invited.tr : LKey.invite.tr,
          textOpacity: isInvited ? .2 : 1,
          onTap: () => controller.onInvite(user, isInvited: isInvited),
        );
      case LivestreamUserType.invited:
        return TextBorderButton(
          text: LKey.cancel.tr,
          onTap: () => controller.onInvite(user, isInvited: isInvited),
        );
      case LivestreamUserType.coHost:
        return Row(
          children: [
            _buildActionBtn(
              state.videoStatus == VideoAudioStatus.on
                  ? AssetRes.icVideoCamera
                  : AssetRes.icVideoOff,
              textLightGrey(context),
              () => controller.coHostVideoToggle(state),
            ),
            _buildActionBtn(
              state.audioStatus == VideoAudioStatus.on
                  ? AssetRes.icMicrophone
                  : AssetRes.icMicOff,
              textLightGrey(context),
              () => controller.coHostAudioToggle(state),
            ),
            _buildActionBtn(AssetRes.icDelete1, ColorRes.likeRed,
                () => controller.coHostDelete(state)),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildActionBtn(String asset, Color color, [VoidCallback? onTap]) {
    return BorderRoundedButton(
      image: asset,
      color: color,
      onTap: onTap,
      padding: 5,
    );
  }
}

class MemberProfileCard extends StatelessWidget {
  final Widget widget;
  final AppUser? user;

  const MemberProfileCard(
      {super.key, required this.widget, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              CustomImage(
                  size: const Size(40, 40),
                  image: user?.profile?.addBaseURL(),
                  fullName: user?.fullname),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FullNameWithBlueTick(
                      username: user?.username,
                      isVerify: user?.isVerify,
                      fontSize: 13,
                      iconSize: 18,
                    ),
                    Text(user?.fullname ?? '',
                        style: TextStyleCustom.outFitLight300(
                            color: textLightGrey(context)))
                  ],
                ),
              ),
              widget
            ],
          ),
          const SizedBox(height: 10),
          const CustomDivider()
        ],
      ),
    );
  }
}

class BorderRoundedButton extends StatelessWidget {
  final String image;
  final Color color;
  final VoidCallback? onTap;
  final double? padding;
  final double? width;
  final double? height;
  final Color? bgColor;

  const BorderRoundedButton(
      {super.key,
      required this.image,
      required this.color,
      this.onTap,
      this.padding,
      this.width,
      this.height,
      this.bgColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 34,
        width: width ?? 34,
        padding: EdgeInsets.all(padding ?? 0),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: color)),
        alignment: Alignment.center,
        child: Image.asset(image, color: color, width: 24, height: 24),
      ),
    );
  }
}

class TextBorderButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? textOpacity;

  const TextBorderButton(
      {super.key, required this.text, this.onTap, this.textOpacity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 100,
        decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1),
                side: BorderSide(color: bgGrey(context)))),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyleCustom.outFitRegular400(
              color: textLightGrey(context),
              fontSize: 15,
              opacity: textOpacity),
        ),
      ),
    );
  }
}

class Values {
  String image;
  Color color;
  double padding;

  Values(this.image, this.color, {this.padding = 0});
}
