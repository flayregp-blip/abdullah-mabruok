import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/custom_drop_down.dart';
import 'package:shortzz/common/widget/custom_toggle.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/blocked_user_screen/blocked_user_screen.dart';
import 'package:shortzz/screen/coin_wallet_screen/coin_wallet_screen.dart';
import 'package:shortzz/screen/edit_profile_screen/edit_profile_screen.dart';
import 'package:shortzz/screen/qr_code_screen/qr_code_screen.dart';
import 'package:shortzz/screen/saved_post_screen/saved_post_screen.dart';
import 'package:shortzz/screen/select_language_screen/select_language_screen.dart';
import 'package:shortzz/screen/settings_screen/settings_screen_controller.dart';
import 'package:shortzz/screen/settings_screen/widget/notifications_page.dart';
import 'package:shortzz/screen/settings_screen/widget/setting_icon_text_with_arrow.dart';
import 'package:shortzz/screen/subscription_screen/subscription_screen.dart';
import 'package:shortzz/screen/term_and_privacy_screen/term_and_privacy_screen.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class SettingsScreen extends StatelessWidget {
  final Function(User? user)? onUpdateUser;

  const SettingsScreen({super.key, this.onUpdateUser});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsScreenController());
    return Scaffold(
        body: Column(
      children: [
        CustomAppBar(title: LKey.settings.tr),
        Expanded(
            child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: AppBar().preferredSize.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubscriptionCard(
                  controller: controller, onUpdateUser: onUpdateUser),
              SettingLabel(title: LKey.personal.toUpperCase()),
              SettingIconTextWithArrow(
                icon: AssetRes.icEdit,
                title: LKey.editProfile,
                onTap: () {
                  Get.to(() => EditProfileScreen(onUpdateUser: onUpdateUser));
                },
              ),
              SettingIconTextWithArrow(
                icon: AssetRes.icPostBookmark,
                title: LKey.savedPosts,
                onTap: () {
                  Get.to(() => const SavedPostScreen());
                },
              ),
              SettingIconTextWithArrow(
                icon: AssetRes.icLanguage_1,
                title: LKey.languages,
                onTap: () {
                  Get.to(() => const SelectLanguageScreen(
                      languageNavigationType:
                          LanguageNavigationType.fromSetting));
                },
              ),
              SettingIconTextWithArrow(
                icon: AssetRes.icBlock,
                title: LKey.blockedUsers,
                onTap: () {
                  Get.to(() => const BlockedUserScreen());
                },
              ),
              SettingIconTextWithArrow(
                icon: AssetRes.icQrCode_1,
                title: LKey.myQrCode,
                onTap: () {
                  Get.to(() => const QrCodeScreen());
                },
              ),
              SettingIconTextWithArrow(
                icon: AssetRes.icWallet,
                title: LKey.coinWallet,
                onTap: () {
                  Get.to(() => const CoinWalletScreen());
                },
              ),
              SettingLabel(title: LKey.privacy.toUpperCase()),
              Obx(
                () => SettingIconTextWithArrow(
                  icon: AssetRes.icEye_1,
                  title: LKey.whoCanSeePosts,
                  widget: CustomDropDownBtn<WhoCanSeePost>(
                    items: WhoCanSeePost.values,
                    onChanged: controller.isUpdateApiCalled.value
                        ? null
                        : controller.onChangedWhoCanSeePost,
                    selectedValue: controller.selectedWhoCanSeePost.value,
                    style: TextStyleCustom.outFitRegular400(
                        fontSize: 15, color: textLightGrey(context)),
                    getTitle: (value) => value.title,
                  ),
                ),
              ),
              Obx(
                () {
                  return SettingIconTextWithArrow(
                    icon: AssetRes.icEye_1,
                    title: LKey.showMyFollowings,
                    widget: CustomToggle(
                      isOn: (controller.myUser.value?.showMyFollowing == 1).obs,
                      onChanged: (value) {
                        controller.onChangedToggle(
                            value, SettingToggle.showMyFollowings);
                      },
                    ),
                  );
                },
              ),
              Obx(
                () {
                  return SettingIconTextWithArrow(
                    icon: AssetRes.icMessage,
                    title: LKey.showChatBtn,
                    widget: CustomToggle(
                      isOn: (controller.myUser.value?.receiveMessage == 1).obs,
                      onChanged: (value) async {
                        controller.onChangedToggle(
                            value, SettingToggle.receiveMessage);
                      },
                    ),
                  );
                },
              ),
              SettingIconTextWithArrow(
                icon: AssetRes.icNotification_1,
                title: LKey.notifications,
                onTap: () {
                  Get.to(() => const NotificationsPage());
                },
              ),
              SettingLabel(title: LKey.general.toUpperCase()),
              SettingIconTextWithArrow(
                icon: AssetRes.icReport,
                title: LKey.termsOfUse,
                onTap: () {
                  Get.to(() => const TermAndPrivacyScreen(
                      type: TermAndPrivacyType.termAndCondition));
                },
              ),
              SettingIconTextWithArrow(
                icon: AssetRes.icReport,
                title: LKey.privacyPolicy,
                onTap: () {
                  Get.to(() => const TermAndPrivacyScreen(
                      type: TermAndPrivacyType.privacyPolicy));
                },
              ),
              SettingIconTextWithArrow(
                icon: AssetRes.icLogout,
                title: LKey.logOut,
                onTap: controller.onLogout,
                widget: const SizedBox(),
              ),
              SettingIconTextWithArrow(
                icon: AssetRes.icDelete2,
                title: LKey.deleteAccount,
                onTap: controller.onDeleteAccount,
                widget: const SizedBox(),
              ),
            ],
          ),
        ))
      ],
    ));
  }
}

class SubscriptionCard extends StatefulWidget {
  final SettingsScreenController controller;
  final Function(User? user)? onUpdateUser;

  const SubscriptionCard(
      {super.key, required this.controller, this.onUpdateUser});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isVerify = widget.controller.myUser.value?.isVerify == 1;
      return InkWell(
        onTap: () {
          if (!isVerify) {
            Get.to<bool>(
                    () => SubscriptionScreen(onUpdateUser: widget.onUpdateUser))
                ?.then((value) {
              if (value == true) {
                widget.controller.myUser.update((val) => val?.isVerify = 1);
              }
            });
          }
        },
        child: Container(
          height: 47,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.all(5),
          decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                  borderRadius:
                      SmoothBorderRadius(cornerRadius: 7, cornerSmoothing: 1)),
              gradient: StyleRes.themeGradient),
          child: Row(
            spacing: 11,
            children: [
              Image.asset(AssetRes.icPro, width: 24, height: 24),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: isVerify ? LKey.youAre.tr : LKey.become.tr,
                      style: TextStyleCustom.outFitRegular400(
                          color: whitePure(context), fontSize: 15),
                      children: [
                        TextSpan(
                            text: ' ${LKey.plus.tr} ',
                            style: TextStyleCustom.outFitExtraBold800(
                                color: whitePure(context), fontSize: 15)),
                        TextSpan(
                            text: isVerify ? LKey.member.tr : '',
                            style: TextStyleCustom.outFitRegular400(
                                color: whitePure(context), fontSize: 15)),
                      ]),
                ),
              ),
              if (!isVerify)
                Image.asset(AssetRes.icForwardArrow,
                    width: 24, height: 20, color: whitePure(context))
            ],
          ),
        ),
      );
    });
  }
}

class SettingLabel extends StatelessWidget {
  final String title;

  const SettingLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 39,
      width: double.infinity,
      color: bgMediumGrey(context),
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Text(
        title.tr.toUpperCase(),
        style: TextStyleCustom.outFitMedium500(
                fontSize: 13, color: textLightGrey(context))
            .copyWith(letterSpacing: 2),
      ),
    );
  }
}
