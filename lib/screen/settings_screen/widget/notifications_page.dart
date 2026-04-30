import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/custom_toggle.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/settings_screen/settings_screen_controller.dart';
import 'package:shortzz/screen/settings_screen/widget/setting_icon_text_with_arrow.dart';
import 'package:shortzz/utilities/asset_res.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsScreenController>();
    return Scaffold(
      body: Obx(() {
        User? user = controller.myUser.value;
        final notificationSettings = [
          {
            'id': SettingToggle.notifyPostLike,
            'icon': AssetRes.icHeart,
            'title': LKey.postLikes.tr,
            'value': user?.notifyPostLike
          },
          {
            'id': SettingToggle.notifyPostComment,
            'icon': AssetRes.icMessage,
            'title': LKey.commentsOnPost.tr,
            'value': user?.notifyPostComment
          },
          {
            'id': SettingToggle.notifyFollow,
            'icon': AssetRes.icFollow,
            'title': LKey.follow.tr,
            'value': user?.notifyFollow
          },
          {
            'id': SettingToggle.notifyMention,
            'icon': AssetRes.icAt,
            'title': LKey.mentions.tr,
            'value': user?.notifyMention
          },
          {
            'id': SettingToggle.notifyGiftReceived,
            'icon': AssetRes.icGift_1,
            'title': LKey.giftsReceived.tr,
            'value': user?.notifyGiftReceived
          },
          {
            'id': SettingToggle.notifyChat,
            'icon': AssetRes.icChat_1,
            'title': LKey.chatMessage.tr,
            'value': user?.notifyChat
          },
        ];

        return Column(
          children: [
            CustomAppBar(title: LKey.notifications.tr),
            ...notificationSettings.map((setting) => SettingIconTextWithArrow(
                  icon: setting['icon'] as String,
                  title: setting['title'] as String,
                  widget: CustomToggle(
                    isOn: (setting['value'] == 1).obs,
                    onChanged: controller.isUpdateApiCalled.value
                        ? null
                        : (value) async {
                            controller.onChangedToggle(value, setting['id'] as SettingToggle);
                          },
                  ),
                ))
          ],
        );
      }),
    );
  }
}
