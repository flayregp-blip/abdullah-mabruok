import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_app_bar.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/search_result_tile.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/common/widget/user_list.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/hashtag_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/camera_screen/camera_screen_controller.dart';
import 'package:shortzz/screen/create_feed_screen/create_feed_screen_controller.dart';
import 'package:shortzz/screen/create_feed_screen/widget/create_feed_location_bar.dart';
import 'package:shortzz/screen/create_feed_screen/widget/feed_comment_toggle.dart';
import 'package:shortzz/screen/create_feed_screen/widget/feed_image_view.dart';
import 'package:shortzz/screen/create_feed_screen/widget/feed_text_field_view.dart';
import 'package:shortzz/screen/create_feed_screen/widget/feed_video_view.dart';
import 'package:shortzz/screen/create_feed_screen/widget/reel_preview_card.dart';
import 'package:shortzz/screen/create_feed_screen/widget/url_meta_data_card.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

enum CreateFeedType { feed, reel }

class CreateFeedScreen extends StatelessWidget {
  final CreateFeedType createType;
  final PostStoryContent? content;

  const CreateFeedScreen({super.key, required this.createType, this.content});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateFeedScreenController(createType, content.obs));

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: LKey.createFeed.tr),
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  controller.commentHelper.detectableTextFocusNode.unfocus(),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ReelPreviewCard(controller: controller),
                        CreateFeedLocationBar(controller: controller),
                        const FeedTextFieldView(),
                        UrlMetaDataCard(controller: controller),
                        if (createType == CreateFeedType.feed)
                          mediaSelectionView(controller),
                        const SizedBox(height: 5),
                        Obx(
                          () => switch (controller.feedPostType.value) {
                            FeedPostType.text => const SizedBox(),
                            FeedPostType.image => FeedImageView(
                                files: controller.images,
                                controller: controller),
                            FeedPostType.video =>
                              FeedVideoView(controller: controller),
                          },
                        ),
                        const FeedCommentToggle(),
                        _uploadButton(controller, context),
                      ],
                    ),
                  ),
                  Obx(() => mentionOrHashtagView(controller, context))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget mediaSelectionView(CreateFeedScreenController controller) {
    return Obx(
        () => controller.images.isNotEmpty || controller.video.value != null
            ? const SizedBox()
            : Row(
                children: [
                  BuildImageContainer(
                      image: AssetRes.icImage,
                      onTap: () => controller.onMediaTap(FeedPostType.image)),
                  const SizedBox(width: 5),
                  BuildImageContainer(
                      image: AssetRes.icVideo,
                      onTap: () => controller.onMediaTap(FeedPostType.video)),
                ],
              ));
  }

  Widget _uploadButton(
      CreateFeedScreenController controller, BuildContext context) {
    return Obx(() {
      RxBool isEmpty = (createType == CreateFeedType.feed &&
              controller.commentHelper.isDetectableTextEmpty.value &&
              controller.feedPostType.value == FeedPostType.text)
          .obs;

      return TextButtonCustom(
        onTap: controller.handleUpload,
        title: LKey.uploadNow.tr,
        backgroundColor:
            textDarkGrey(context).withValues(alpha: isEmpty.value ? .5 : 1),
        titleColor:
            whitePure(context).withValues(alpha: isEmpty.value ? .5 : 1),
        margin: EdgeInsets.symmetric(
            vertical: AppBar().preferredSize.height, horizontal: 20),
      );
    });
  }

  Widget mentionOrHashtagView(
      CreateFeedScreenController controller, BuildContext context) {
    if (!controller.commentHelper.isMentionUserView.value &&
        !controller.commentHelper.isHashTagView.value) {
      return const SizedBox();
    }
    final bool isMentionView = controller.commentHelper.isMentionUserView.value;
    final items = isMentionView
        ? controller.commentHelper.searchUsers
        : controller.commentHelper.hashTags;

    itemBuilder(context, index) {
      final item = items[index];
      if (isMentionView) {
        User user = item as User;
        return UserCard(
          onTap: () => controller.commentHelper
              .appendDetection(user, DetectType.atSign, type: 1),
          fullName: user.fullname,
          profilePhoto: user.profilePhoto,
          userName: user.username,
        );
      }
      Hashtag hashtag = item as Hashtag;
      return SearchResultTile(
        description: '${hashtag.postCount} ${LKey.posts.tr}',
        title: '${AppRes.hash}${hashtag.hashtag ?? ' '}',
        onTap: () => controller.commentHelper
            .appendDetection(hashtag, DetectType.hashTag, type: 1),
        image: AssetRes.icHashtag,
      );
    }

    return Container(
      color: (!controller.commentHelper.isLoading.value && items.isEmpty)
          ? null
          : bgLightGrey(context),
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 180),
      child: controller.commentHelper.isLoading.value
          ? const LoaderWidget()
          : items.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  itemCount: items.length,
                  padding: const EdgeInsets.only(top: 5, left: 13, right: 13),
                  itemBuilder: itemBuilder),
    );
  }
}

class BuildImageContainer extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  const BuildImageContainer(
      {super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 59,
          decoration: BoxDecoration(color: bgLightGrey(context)),
          child: Center(
            child: Image.asset(image,
                color: textDarkGrey(context), height: 29, width: 29),
          ),
        ),
      ),
    );
  }
}
