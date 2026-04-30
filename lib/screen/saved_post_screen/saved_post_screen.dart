import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/custom_tab_switcher.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/post_list.dart';
import 'package:shortzz/common/widget/reel_list.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/screen/saved_post_screen/saved_post_screen_controller.dart';

class SavedPostScreen extends StatelessWidget {
  const SavedPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavedPostScreenController());
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: LKey.savedPosts.tr,
            widget: CustomTabSwitcher(
                onTap: (index) {
                  controller.onChangeTab(index);
                  controller.pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.linear);
                },
                selectedIndex: controller.selectedTabIndex,
                items: controller.items,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10)),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Obx(
              () => controller.isLoading.value &&
                      (controller.selectedTabIndex.value == 0
                          ? controller.posts.isEmpty
                          : controller.reels.isEmpty)
                  ? const LoaderWidget()
                  : PageView(
                      controller: controller.pageController,
                      onPageChanged: controller.onChangeTab,
                      children: [
                        ReelList(
                          pageType: ReelPageType.saved,
                          reels: controller.reels,
                          isLoading: controller.isReelLoading,
                          onFetchMoreData: controller.fetchReel,
                          onBackResponse: controller.onBackResponse,
                        ),
                        PostList(
                          posts: controller.posts,
                          isLoading: controller.isPostLoading,
                          onFetchMoreData: controller.fetchPost,
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}
