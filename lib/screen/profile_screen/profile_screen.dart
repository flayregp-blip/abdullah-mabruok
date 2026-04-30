import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/widget/custom_back_button.dart';
import 'package:shortzz/common/widget/my_refresh_indicator.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/profile_screen/profile_screen_controller.dart';
import 'package:shortzz/screen/profile_screen/widget/profile_page_view.dart';
import 'package:shortzz/screen/profile_screen/widget/profile_tab_bar_view.dart';
import 'package:shortzz/screen/profile_screen/widget/profile_user_header.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ProfileScreen extends StatelessWidget {
  final User? user;
  final bool isTopBarVisible;
  final bool isDashBoard;
  final Function(User? user)? onUserUpdate;

  const ProfileScreen(
      {super.key,
      this.user,
      this.isTopBarVisible = true,
      this.isDashBoard = false,
      this.onUserUpdate});

  @override
  Widget build(BuildContext context) {
    ProfileScreenController controller = Get.put(
        ProfileScreenController(
          user.obs,
          onUserUpdate,
        ),
        tag: isDashBoard
            ? ProfileScreenController.tag
            : "${DateTime.now().millisecondsSinceEpoch}");

    return Scaffold(
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          controller.adsController
              .showInterstitialAdIfAvailable(isPopScope: true);
        },
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Obx(() => _TopViewForOtherUser(
                  user: controller.userData.value,
                  isTopBarVisible: isTopBarVisible,
                  controller: controller)),
              Expanded(
                child: Stack(
                  children: [
                    DefaultTabController(
                      length: 2,
                      child: MyRefreshIndicator(
                        depth: 2,
                        onRefresh: controller.onRefresh,
                        child: NestedScrollView(
                          headerSliverBuilder: (context, _) {
                            return [
                              SliverList(
                                delegate: SliverChildListDelegate([
                                  ProfileUserHeader(controller: controller)
                                ]),
                              ),
                            ];
                          },
                          body: Column(
                            children: [
                              ProfileTabs(controller: controller),
                              ProfilePageView(controller: controller)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      User? user = controller.userData.value;
                      if (user?.isFreez != 1) {
                        return const SizedBox();
                      }
                      return Container(
                        color: scaffoldBackgroundColor(context)
                            .withValues(alpha: 0.4),
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_person_rounded,
                                    size: 80, color: textLightGrey(context)),
                                const SizedBox(height: 20),
                                Text(
                                  LKey.profileUnavailable.tr,
                                  style: TextStyleCustom.unboundedSemiBold600(
                                      color: textLightGrey(context),
                                      fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: Text(
                                    LKey.profileTemporarilyFrozen.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyleCustom.outFitMedium500(
                                        color: textLightGrey(context),
                                        fontSize: 16),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Obx(() {
                                  bool isModerator = SessionManager
                                          .instance.isModerator.value ==
                                      1;
                                  if (!isModerator) {
                                    return const SizedBox();
                                  }
                                  return TextButtonCustom(
                                    onTap: () =>
                                        controller.freezeUnfreezeUser(true),
                                    title: LKey.unFreeze.tr,
                                    titleColor: whitePure(context),
                                    backgroundColor: textDarkGrey(context),
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopViewForOtherUser extends StatelessWidget {
  final User? user;
  final bool isTopBarVisible;
  final ProfileScreenController controller;

  const _TopViewForOtherUser(
      {this.user, required this.isTopBarVisible, required this.controller});

  @override
  Widget build(BuildContext context) {
    return isTopBarVisible
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomBackButton(
                onTap: () {
                  controller.adsController.showInterstitialAdIfAvailable();
                },
                padding: const EdgeInsets.all(15),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    user?.username ?? '',
                    style: TextStyleCustom.unboundedMedium500(
                        color: textDarkGrey(context)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 18 + 30),
            ],
          )
        : const SizedBox();
  }
}
