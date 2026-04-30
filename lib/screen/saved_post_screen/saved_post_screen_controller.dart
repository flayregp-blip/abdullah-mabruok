import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/post_model.dart';

class SavedPostScreenController extends BaseController {
  RxInt selectedTabIndex = 0.obs;
  PageController pageController = PageController();
  var items = [LKey.reels.tr, LKey.feed.tr];
  List<int> unsavedIds = [];

  RxList<Post> posts = <Post>[].obs;
  RxList<Post> reels = <Post>[].obs;

  RxBool isReelLoading = false.obs;
  RxBool isPostLoading = false.obs;

  void onChangeTab(int value) {
    selectedTabIndex.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() async {
    final result = await Future.wait({fetchReel(), fetchPost()});
    print(result[0]);
    print(result[1]);
    List<Post> reels = result[0];
    List<Post> posts = result[1];

    if (reels.isEmpty && posts.isNotEmpty) {
      pageController.animateToPage(1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  Future<List<Post>> fetchPost() async {
    if (isPostLoading.value) return posts;
    isPostLoading.value = true;
    List<Post> _post = await PostService.instance.fetchSavedPosts(
        type: PostType.posts, lastItemId: posts.lastOrNull?.postSaveId);
    if (_post.isNotEmpty) {
      posts.addAll(_post);
    }

    isPostLoading.value = false;
    return posts;
  }

  Future<List<Post>> fetchReel() async {
    if (isReelLoading.value) return reels;
    isReelLoading.value = true;
    List<Post> _post = await PostService.instance.fetchSavedPosts(
        type: PostType.reels, lastItemId: reels.lastOrNull?.postSaveId);
    if (_post.isNotEmpty) {
      reels.addAll(_post);
    }
    isReelLoading.value = false;
    return reels;
  }

  void onBackResponse(dynamic value) async {
    Future.delayed(const Duration(milliseconds: 500), () {
      reels.removeWhere((element) => unsavedIds.contains(element.id));
      unsavedIds.clear();
    });
  }
}
