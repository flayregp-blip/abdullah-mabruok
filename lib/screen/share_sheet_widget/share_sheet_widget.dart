import 'dart:io';

import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/manager/share_manager.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/chat/chat_thread.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/screen/share_sheet_widget/share_sheet_widget_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ShareSheetWidget extends StatelessWidget {
  final VoidCallback onMoreTap;
  final String link;
  final bool isDownloadShow;
  final Post? post;
  final ShareKeys keys;
  final Function()? onCallBack;

  const ShareSheetWidget(
      {super.key,
      required this.onMoreTap,
      required this.link,
      this.isDownloadShow = false,
      this.post,
      required this.keys,
      this.onCallBack});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShareSheetWidgetController(post, onCallBack));

    return Wrap(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            RepaintBoundary(
              key: controller.screenShotKey,
              child: Column(
                children: [
                  Obx(
                    () => controller.waterMarkPath.value.isEmpty
                        ? const SizedBox()
                        : Image.file(File(controller.waterMarkPath.value), fit: BoxFit.contain, height: 50, width: 100),
                  ),
                  Text(
                    '@${post?.user?.username ?? AppRes.appName}',
                    style: TextStyleCustom.unboundedBold700(color: whitePure(context), fontSize: 15)
                        .copyWith(shadows: [const Shadow(color: Colors.black, blurRadius: 20)]),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2.5),
              decoration: ShapeDecoration(
                  shape: const SmoothRectangleBorder(
                      borderRadius:
                          SmoothBorderRadius.vertical(top: SmoothRadius(cornerRadius: 40, cornerSmoothing: 1))),
                  color: scaffoldBackgroundColor(context)),
              child: Column(
                children: [
                  BottomSheetTopView(
                      title:
                          keys == ShareKeys.reel || keys == ShareKeys.post ? LKey.sharePost.tr : LKey.shareProfile.tr),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(link,
                                style: TextStyleCustom.outFitRegular400(color: textDarkGrey(context), fontSize: 16))),
                        const SizedBox(width: 20),
                        CustomAssetWithBgButton(
                            image: AssetRes.icCopy,
                            boxSize: 46,
                            iconSize: 22,
                            radius: 10,
                            onTap: () async {
                              Get.back();
                              await link.copyText;

                              DebounceAction.shared.call(() {
                                controller.increaseShareCount(post?.id);
                              }, milliseconds: 1000);
                            })
                      ],
                    ),
                  ),
                  const CustomDivider(),
                  if (keys == ShareKeys.post || keys == ShareKeys.reel)
                    Obx(() {
                      List<ChatThread> users = controller.chatsUsers;
                      bool isSelectedListEmpty = controller.selectedConversation.isEmpty;
                      if (users.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Center(
                                child: Wrap(
                                  spacing: 20,
                                  runSpacing: 10,
                                  direction: Axis.horizontal,
                                  children: List.generate(
                                    users.take(8).length,
                                    (index) {
                                      ChatThread chatConversation = users[index];
                                      chatConversation.bindChatUser();
                                      bool isSelected = controller.selectedConversation.contains(chatConversation);
                                      if (index == 7) {
                                        return InkWell(
                                            onTap: controller.onMoreTap,
                                            child: Container(
                                              height: 62,
                                              width: 75,
                                              decoration: BoxDecoration(color: bgGrey(context), shape: BoxShape.circle),
                                              alignment: const Alignment(.05, 0),
                                              child:
                                                  Icon(Icons.arrow_forward_ios_rounded, color: textDarkGrey(context)),
                                            ));
                                      }
                                      return Obx(() {
                                        AppUser? chatUser = chatConversation.chatUserRx.value;

                                        return InkWell(
                                          onTap: () => controller.onUserTap(chatConversation),
                                          child: SizedBox(
                                            width: 74,
                                            height: 84,
                                            child: Column(
                                              children: [
                                                Stack(
                                                  alignment: AlignmentDirectional.bottomEnd,
                                                  children: [
                                                    Align(
                                                        alignment: Alignment.center,
                                                        child: CustomImage(
                                                            size: const Size(62, 62),
                                                            image: chatUser?.profile?.addBaseURL(),
                                                            fullName: chatUser?.fullname)),
                                                    if (isSelected)
                                                      Positioned(
                                                        right: 5,
                                                        child: Align(
                                                          alignment: AlignmentDirectional.bottomEnd,
                                                          child: Container(
                                                            height: 21,
                                                            width: 21,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: whitePure(context),
                                                                border:
                                                                    Border.all(color: whitePure(context), width: 1)),
                                                            alignment: Alignment.center,
                                                            child: Image.asset(AssetRes.icCheckCircle,
                                                                color: themeAccentSolid(context)),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child: Text(chatUser?.username ?? '',
                                                      style: TextStyleCustom.outFitRegular400(
                                                          color: textDarkGrey(context), fontSize: 14),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                ),
                              )),
                          TextButtonCustom(
                            onTap: isSelectedListEmpty ? () {} : () => controller.onSendChat(post),
                            title: LKey.send.tr,
                            backgroundColor: textDarkGrey(context).withValues(alpha: isSelectedListEmpty ? .4 : 1),
                            titleColor: whitePure(context),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                          )
                        ],
                      );
                    }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 23.0, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (isDownloadShow)
                          CustomAssetWithBgButton(
                            image: AssetRes.icDownload,
                            boxSize: 58,
                            iconSize: 30,
                            onTap: () => controller.onShareSheetBottomBtnTap(ShareOption.download, link, post: post),
                          ),
                        CustomAssetWithBgButton(
                          image: AssetRes.icWhatsapp,
                          boxSize: 58,
                          iconSize: 30,
                          onTap: () => controller.onShareSheetBottomBtnTap(ShareOption.whatsapp, link, post: post),
                        ),
                        CustomAssetWithBgButton(
                          image: AssetRes.icInstagram,
                          boxSize: 58,
                          iconSize: 30,
                          onTap: () => controller.onShareSheetBottomBtnTap(ShareOption.instagram, link, post: post),
                        ),
                        CustomAssetWithBgButton(
                          image: AssetRes.icTelegram,
                          boxSize: 58,
                          iconSize: 30,
                          onTap: () => controller.onShareSheetBottomBtnTap(ShareOption.telegram, link, post: post),
                        ),
                        CustomAssetWithBgButton(
                          image: AssetRes.icMore,
                          boxSize: 58,
                          iconSize: 30,
                          onTap: onMoreTap,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomAssetWithBgButton extends StatelessWidget {
  final String image;
  final double boxSize;
  final double iconSize;
  final double radius;
  final VoidCallback? onTap;

  const CustomAssetWithBgButton(
      {super.key, required this.image, required this.boxSize, required this.iconSize, this.radius = 15, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: boxSize,
        width: boxSize,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
            color: bgGrey(context),
            shape: SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1))),
        child: Image.asset(image, height: iconSize, width: iconSize, color: textDarkGrey(context)),
      ),
    );
  }
}

enum ShareOption {
  download,
  whatsapp,
  share,
  instagram,
  telegram,
  more,
  copy;

  String value(String link) {
    switch (this) {
      case ShareOption.whatsapp:
        return "whatsapp://send?text=$link";
      case ShareOption.instagram:
        return "instagram://sharesheet?text=$link";
      case ShareOption.telegram:
        return "https://t.me/share/url?url=${Uri.encodeComponent(link)}";
      case ShareOption.download:
      case ShareOption.share:
      case ShareOption.more:
      case ShareOption.copy:
        return '';
    }
  }
}

enum ShareType { videoPost, imagePost, textPost, reelPost }
