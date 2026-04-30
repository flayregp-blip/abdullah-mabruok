import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/manager/story_view/widgets/story_view.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/custom_popup_menu_button.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/story/story_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/story_view_screen/story_view_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class StoryViewSheet extends StatelessWidget {
  final List<User> stories;
  final int userIndex;
  final Function(Story? story) onUpdateDeleteStory;

  const StoryViewSheet(
      {super.key,
      required this.stories,
      required this.userIndex,
      required this.onUpdateDeleteStory});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoryViewScreenController(stories, userIndex,
        PageController(initialPage: userIndex), onUpdateDeleteStory));
    return Container(
      color: blackPure(context),
      child: SafeArea(
        child: PageView.builder(
          controller: controller.pageController,
          itemCount: stories.length,
          onPageChanged: controller.onPageChange,
          itemBuilder: (context, storyIndex) {
            return StoryView(
              storyItems: controller.stories[storyIndex],
              inline: true,
              onStoryShow: controller.onStoryShow,
              onBack: controller.onPreviousUser,
              onComplete: controller.onNext,
              progressPosition: ProgressPosition.top,
              repeat: false,
              controller: controller.storyController,
              overlayWidget: (item) {
                User? myUser = SessionManager.instance.getUser();

                bool isMyStory = item.story?.userId == myUser?.id;
                User? user = item.story?.user;

                return SizedBox(
                  height: 75,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CustomImage(
                            fit: BoxFit.cover,
                            size: const Size(35, 35),
                            image: user?.profilePhoto?.addBaseURL(),
                            fullName: user?.fullname,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FullNameWithBlueTick(
                                username: user?.fullname,
                                isVerify: user?.isVerify,
                                fontColor: whitePure(context),
                                fontSize: 12,
                                iconSize: 17,
                                child: Text(
                                  item.story?.date ?? '',
                                  style: TextStyleCustom.outFitLight300(
                                    color: whitePure(context),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              if (item.story?.music != null)
                                Row(
                                  spacing: 5,
                                  children: [
                                    Image.asset(AssetRes.icMusic,
                                        width: 12, height: 12),
                                    Expanded(
                                      child: Text(
                                        '${item.story?.music?.title ?? ''}'
                                        '${item.story?.music?.title != null ? ' • ' : ''}'
                                        '${item.story?.music?.artist ?? ''}',
                                        style: TextStyleCustom.outFitLight300(
                                          color: whitePure(context),
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Obx(
                          () {
                            bool isModerator =
                                SessionManager.instance.isModerator.value == 1;
                            bool shouldDeleteStory =
                                user?.id == myUser?.id || isModerator;

                            return shouldDeleteStory
                                ? CustomPopupMenuButton(
                                    items: [
                                      MenuItem(
                                        LKey.delete.tr,
                                        () {
                                          Future.delayed(
                                              const Duration(milliseconds: 50),
                                              () {
                                            controller.storyController.pause();
                                          });
                                          controller.onStoryDelete(item.story,
                                              isModerator:
                                                  (!isMyStory && isModerator));
                                        },
                                      ),
                                    ],
                                    onCanceled: controller.storyController.play,
                                    onOpened: controller.storyController.pause,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Image.asset(AssetRes.icMore1,
                                          height: 25,
                                          width: 25,
                                          color: whitePure(context)),
                                    ),
                                  )
                                : const SizedBox();
                          },
                        ),
                        InkWell(
                          onTap: Get.back,
                          child: Image.asset(AssetRes.icClose1,
                              width: 28, height: 28, color: whitePure(context)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
