import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/load_more_widget.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/screen/post_screen/post_card.dart';

class PostList extends StatelessWidget {
  final RxList<Post> posts;
  final RxBool isLoading;
  final Future<void> Function()? onFetchMoreData;
  final bool shrinkWrap;
  final bool shouldShowPinOption;
  final bool isMe;
  final bool showNoData;

  const PostList({
    super.key,
    required this.posts,
    required this.isLoading,
    this.onFetchMoreData,
    this.shrinkWrap = false,
    this.shouldShowPinOption = false,
    this.isMe = false,
    this.showNoData = true,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value && posts.isEmpty) {
        return const LoaderWidget();
      }

      if (!isLoading.value && posts.isEmpty) {
        return showNoData ? _buildNoDataView() : const SizedBox();
      }

      return LoadMoreWidget(
        loadMore: onFetchMoreData ?? () async {},
        child: ListView.builder(
          itemCount: posts.length,
          primary: !shrinkWrap,
          shrinkWrap: shrinkWrap,
          padding: EdgeInsets.only(bottom: AppBar().preferredSize.height / 2),
          itemBuilder: (context, index) {
            final post = posts[index];
            return _buildPostCard(post);
          },
        ),
      );
    });
  }

  Widget _buildNoDataView() {
    return Stack(
      children: [
        NoDataView(
          title: isMe ? LKey.noMyPostsTitle.tr : LKey.noUserPostsTitle.tr,
          description: isMe
              ? LKey.noMyPostsDescription.tr
              : LKey.noUserPostsDescription.tr,
          showShow: !isLoading.value && posts.isEmpty,
        ),
        SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(Get.context!).size.height,
                width: MediaQuery.of(Get.context!).size.width,
                color: Colors.transparent)),
      ],
    );
  }

  Widget _buildPostCard(Post post) {
    return PostCard(
        post: post,
        shouldShowPinOption: shouldShowPinOption,
        likeKey: GlobalKey());
  }
}
