import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/custom_search_text_field.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/chat/chat_thread.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/screen/share_sheet_widget/share_sheet_widget_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class MoreUserSheet extends StatelessWidget {
  const MoreUserSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShareSheetWidgetController>();
    return Container(
        margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2),
        decoration: ShapeDecoration(
            color: whitePure(context),
            shape: const SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius.vertical(
                    top: SmoothRadius(cornerRadius: 30, cornerSmoothing: 1)))),
        child: Column(
          children: [
            BottomSheetTopView(title: LKey.users.tr, sideBtnVisibility: false),
            CustomSearchTextField(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                onChanged: controller.onSearchUser),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                return GridView.builder(
                  itemCount: controller.filterChatsUsers.length,
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    ChatThread chatConversation =
                        controller.filterChatsUsers[index];
                    AppUser? chatUser = chatConversation.chatUser;
                    return Obx(() {
                      bool isSelected = controller.selectedConversation
                          .contains(chatConversation);
                      return InkWell(
                        onTap: () => controller.onUserTap(chatConversation),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 62,
                              width: 80,
                              child: Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: CustomImage(
                                        size: const Size(62, 62),
                                        image: chatUser?.profile?.addBaseURL(),
                                        fullName: chatUser?.fullname,
                                      )),
                                  if (isSelected)
                                    Positioned(
                                      right: 5,
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.bottomEnd,
                                        child: Container(
                                          height: 21,
                                          width: 21,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: whitePure(context),
                                              border: Border.all(
                                                  color: whitePure(context),
                                                  width: 1)),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                              AssetRes.icCheckCircle,
                                              color: themeAccentSolid(context)),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(chatUser?.username ?? '',
                                    style: TextStyleCustom.outFitRegular400(
                                        color: textDarkGrey(context),
                                        fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    maxLines: 2),
                              ),
                            )
                          ],
                        ),
                      );
                    });
                  },
                );
              }),
            )
          ],
        ));
  }
}
