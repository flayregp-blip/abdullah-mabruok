import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/block_user_model.dart';
import 'package:shortzz/screen/blocked_user_screen/blocked_user_screen_controller.dart';
import 'package:shortzz/screen/follow_following_screen/follow_following_screen.dart';

class BlockedUserScreen extends StatelessWidget {
  const BlockedUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BlockedUserScreenController());
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: LKey.blockedUsers.tr),
          Expanded(
            child: Obx(
              () =>
                  controller.isLoading.value && controller.blockedUsers.isEmpty
                      ? const LoaderWidget()
                      : NoDataView(
                          showShow: !controller.isLoading.value &&
                              controller.blockedUsers.isEmpty,
                          title: LKey.blockListEmptyTitle,
                          description: LKey.blockListEmptyDescription,
                          child: ListView.builder(
                              itemCount: controller.blockedUsers.length,
                              padding: const EdgeInsets.only(top: 10),
                              itemBuilder: (context, index) {
                                BlockUsers user =
                                    controller.blockedUsers[index];
                                return UserProfileTile(
                                    actionName: ActionName.block,
                                    onTap: () =>
                                        controller.unblockUser(user.toUser, () {
                                          controller.blockedUsers.removeWhere(
                                              (element) =>
                                                  element.toUserId ==
                                                  user.toUserId);
                                        }),
                                    isFollowOrIsBlock: true,
                                    user: user.toUser);
                              }),
                        ),
            ),
          )
        ],
      ),
    );
  }
}
