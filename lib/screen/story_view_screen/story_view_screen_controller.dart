import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/manager/story_view/controller/story_controller.dart';
import 'package:shortzz/common/service/api/moderator_service.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/widget/confirmation_dialog.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/status_model.dart';
import 'package:shortzz/model/post_story/story/story_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';

import '../../common/manager/story_view/widgets/story_view.dart';

class StoryViewScreenController extends BaseController {
  StoryController storyController = StoryController();
  List<List<StoryItem>> stories = [];
  List<User> users = [];
  PageController pageController;
  int userIndex = 0;
  Function(Story? story) onUpdateStoryDelete;

  StoryViewScreenController(this.users, this.userIndex, this.pageController,
      this.onUpdateStoryDelete) {
    for (var user in users) {
      List<StoryItem> userStories =
          user.stories?.map((e) => e.toStoryItem(storyController)).toList() ??
              [];
      stories.add(userStories);
      update();
    }
  }

  void onStoryShow(StoryItem value) async {
    if (!value.viewedByUsersIds
        .contains('${SessionManager.instance.getUserID()}')) {
      Story? story =
          await PostService.instance.viewStory(storyId: value.id.toInt());
      if (story != null) {
        if (userIndex < users.length) {
          List<Story> stories = users[userIndex].stories ?? [];
          int storyIndex =
              stories.indexWhere((element) => element.id == story.id);
          if (storyIndex != -1) {
            story.user = value.story?.user;
            stories[storyIndex] = story;
          }
        }
      }
    }
  }

  void onStoryDelete(Story? story, {required bool isModerator}) {
    int storyID = story?.id ?? -1;

    if (storyID == -1) {
      return Loggers.error('Invalid Story ID : $storyID');
    }
    Get.bottomSheet(
      ConfirmationSheet(
        title: LKey.deleteStoryTitle.tr,
        description: LKey.deleteStoryMessage.tr,
        onTap: () async {
          showLoader();
          StatusModel status;
          if (isModerator) {
            status = await ModeratorService.instance
                .moderatorDeleteStory(storyId: story?.id ?? -1);
          } else {
            status = await PostService.instance
                .deleteStory(storyId: story?.id ?? -1);
          }
          stopLoader();
          if (status.status == true) {
            onUpdateStoryDelete.call(story);
            Get.back();
          } else {
            showSnackBar(status.message);
          }
        },
      ),
    );
  }

  void onPreviousUser() {
    if (userIndex == 0) {
      return;
    }
    pageController.animateToPage(userIndex - 1,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
    update();
  }

  void onNext() {
    if (userIndex == (stories.length - 1)) {
      Get.back(result: users[userIndex]);
      return;
    }
    pageController.animateToPage(userIndex + 1,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
    update();
  }

  void onPageChange(int value) {
    userIndex = value;
    update();
  }

  @override
  void onClose() {
    super.onClose();
    storyController.dispose();
  }
}
