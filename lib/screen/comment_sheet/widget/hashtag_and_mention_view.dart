import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/search_result_tile.dart';
import 'package:shortzz/common/widget/user_list.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/hashtag_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/comment_sheet/helper/comment_helper.dart';
import 'package:shortzz/screen/create_feed_screen/create_feed_screen_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

class HashTagAndMentionUserView extends StatelessWidget {
  final CommentHelper helper;
  final double? height;
  final double? bottomViewSpace;

  const HashTagAndMentionUserView(
      {super.key, required this.helper, this.height, this.bottomViewSpace});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (!helper.isMentionUserView.value && !helper.isHashTagView.value) {
          return const SizedBox();
        }

        final bool isMentionView = helper.isMentionUserView.value;
        final items = isMentionView ? helper.searchUsers : helper.hashTags;
        final itemBuilder = isMentionView
            ? (context, index) {
                final user = items[index] as User;
                return UserCard(
                    onTap: () {
                      return helper.appendDetection(user, DetectType.atSign, type: 1);
                    },
                    userName: user.username,
                    profilePhoto: user.profilePhoto,
                    fullName: user.fullname);
              }
            : (context, index) {
                final hashtag = items[index] as Hashtag;
                return SearchResultTile(
                  description: '${hashtag.postCount} ${LKey.posts.tr}',
                  title: '${AppRes.hash}${hashtag.hashtag ?? ' '}',
                  onTap: () => helper.appendDetection(hashtag, DetectType.hashTag, type: 1),
                  image: AssetRes.icHashtag,
                );
              };

        return Wrap(
          children: [
            helper.isLoading.value
                ? Container(
                    decoration: ShapeDecoration(
                        color: !helper.isLoading.value && items.isEmpty ? null : whitePure(context),
                        shape: SmoothRectangleBorder(
                            borderRadius:
                                SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1))),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const LoaderWidget(),
                  )
                : items.isEmpty
                    ? const SizedBox()
                    : Container(
                        height: height,
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(
                            maxHeight: height ?? 200,
                            minWidth: MediaQuery.of(context).size.width,
                            maxWidth: MediaQuery.of(context).size.width),
                        decoration: ShapeDecoration(
                            color: !helper.isLoading.value && items.isEmpty
                                ? null
                                : whitePure(context),
                            shape: SmoothRectangleBorder(
                                borderRadius:
                                    SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1))),
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ListView.builder(
                            itemCount: items.length,
                            shrinkWrap: true,
                            primary: false,
                            padding: EdgeInsets.only(
                                top: 5, left: 13, right: 13, bottom: bottomViewSpace ?? 0.0),
                            itemBuilder: itemBuilder)),
          ],
        );
      },
    );
  }
}
