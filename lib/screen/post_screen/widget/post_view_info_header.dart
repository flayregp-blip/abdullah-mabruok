import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shortzz/common/controller/profile_controller.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/navigation/navigate_with_controller.dart';
import 'package:shortzz/common/widget/custom_popup_menu_button.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/location_screen/location_screen.dart';
import 'package:shortzz/screen/post_screen/post_screen_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class PostViewInfoHeader extends StatelessWidget {
  final Post post;
  final PostScreenController controller;
  final bool shouldShowPinOption;

  const PostViewInfoHeader(
      {super.key,
      required this.post,
      required this.controller,
      required this.shouldShowPinOption});

  @override
  Widget build(BuildContext context) {
    late ProfileController profileController;
    if (Get.isRegistered<ProfileController>(tag: '${post.userId}')) {
      profileController = Get.find<ProfileController>(tag: '${post.userId}');
    } else {
      profileController =
          Get.put(ProfileController(post.user), tag: '${post.userId}');
    }

    User? user = profileController.user;

    return Row(
      children: [
        const SizedBox(height: 38),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FullNameWithBlueTick(
                username: user?.username,
                fontSize: 12,
                iconSize: 18,
                isVerify: user?.isVerify,
                child: Text(
                    '${post.createdAt?.timeAgo ?? ''} '
                    '${(post.isPinned == 1 && shouldShowPinOption && post.userId == SessionManager.instance.getUserID()) ? AppRes.postPinIcon : ''}',
                    style: TextStyleCustom.outFitLight300(
                        color: textLightGrey(context), fontSize: 12)),
                onTap: () {
                  NavigationService.shared.openProfileScreen(user);
                },
              ),
              if ((post.placeTitle ?? '').isNotEmpty)
                InkWell(
                  onTap: () {
                    Get.to(() => LocationScreen(
                        latLng: LatLng(post.placeLat?.toDouble() ?? 0,
                            post.placeLon?.toDouble() ?? 0),
                        placeTitle: post.placeTitle ?? ''));
                  },
                  child: Text(
                    post.placeTitle ?? '',
                    style: TextStyleCustom.outFitLight300(
                        color: textLightGrey(context), fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
            ],
          ),
        ),
        Obx(() {
          bool isModerator = SessionManager.instance.isModerator.value == 1;
          return CustomPopupMenuButton(
            items: _getMenuItems(isModerator, post, controller),
            child: Image.asset(
              AssetRes.icMore1,
              height: 26,
              width: 26,
              color: textLightGrey(context),
            ),
          );
        })
      ],
    );
  }

  // Helper function to get menu items
  List<MenuItem> _getMenuItems(
      bool isModerator, Post post, PostScreenController controller) {
    final isMyPost =
        post.userId?.toInt() == SessionManager.instance.getUserID();
    if (isMyPost) {
      return [
        if (shouldShowPinOption)
          MenuItem(post.isPinned == 0 ? LKey.pin.tr : LKey.unpin.tr,
              () => controller.handlePinUnpinPost(post.isPinned ?? 0)),
        MenuItem(LKey.delete.tr,
            () => controller.handleDelete(post, isModerator: false)),
      ];
    } else {
      return [
        MenuItem(LKey.report.tr, () => controller.handleReport(post)),
        if (isModerator)
          MenuItem(LKey.delete.tr,
              () => controller.handleDelete(post, isModerator: true)),
      ];
    }
  }
}
