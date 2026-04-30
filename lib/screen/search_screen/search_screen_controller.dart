import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/service/api/common_service.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/service/api/search_service.dart';
import 'package:shortzz/common/service/location/location_service.dart';
import 'package:shortzz/common/service/navigation/navigate_with_controller.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/location_place_model.dart';
import 'package:shortzz/model/post_story/hashtag_model.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/hashtag_screen/hashtag_screen.dart';
import 'package:shortzz/screen/location_screen/location_screen.dart';

class SearchScreenController extends BaseController {
  List<SearchTabs> searchTabs = SearchTabs.values;
  Rx<SearchTabs> selectedTabIndex = SearchTabs.values.first.obs;
  RxList<Hashtag> hashtags = <Hashtag>[].obs;
  RxList<Places> places = <Places>[].obs;
  RxList<Post> posts = <Post>[].obs;
  RxList<Post> reels = <Post>[].obs;
  RxList<User> users = <User>[].obs;

  RxBool isFeedLoading = false.obs;
  RxBool isReelsLoading = false.obs;
  RxBool isUsersLoading = false.obs;
  RxBool isHashTagsLoading = false.obs;
  RxBool isPlacesLoading = false.obs;
  RxBool isLocationLoading = true.obs;
  RxBool isLocationError = false.obs;

  TextEditingController searchKeyword = TextEditingController();

  PageController pageController = PageController(initialPage: 0);

  RxBool isTextEmpty = true.obs;

  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    onSearchTabTap(0);
  }

  void onSearchTabTap(int index) {
    selectedTabIndex.value = searchTabs[index];
    onChanged(0);
  }

  onChanged(int milliSecond) {
    if (searchKeyword.text.trim().isEmpty) {
      isTextEmpty.value = true;
    } else {
      isTextEmpty.value = false;
    }
    DebounceAction.shared.call(() {
      switch (selectedTabIndex.value) {
        case SearchTabs.feed:
          searchPosts(reset: true);
          break;
        case SearchTabs.reels:
          searchReels(reset: true);
          break;
        case SearchTabs.users:
          searchUsers(reset: true);
          break;
        case SearchTabs.hashtags:
          searchHashTags(reset: true);
          break;
        case SearchTabs.places:
          if (searchKeyword.text.trim().isEmpty) {
            fetchNearByLocation();
          } else {
            searchPlace(reset: true);
          }
          break;
      }
    }, milliseconds: milliSecond);
  }

  Future<void> searchPosts({bool reset = false}) async {
    if (isFeedLoading.value) return;
    isFeedLoading.value = true;
    final items = await SearchService.instance.searchPost(
        type: PostType.posts,
        lastItemId: reset ? null : posts.lastOrNull?.id,
        keyword: searchKeyword.text);

    if (reset) {
      posts.clear();
    }
    posts.addAll(items);
    isFeedLoading.value = false;
  }

  Future<void> searchReels({bool reset = false}) async {
    if (isReelsLoading.value) return;
    isReelsLoading.value = true;
    final items = await SearchService.instance.searchPost(
        type: PostType.reels,
        lastItemId: reset ? null : reels.lastOrNull?.id,
        keyword: searchKeyword.text);

    if (reset) {
      reels.clear();
    }
    reels.addAll(items);
    isReelsLoading.value = false;
  }

  Future<void> searchUsers({bool reset = false}) async {
    isUsersLoading.value = true;
    List<User> items = await SearchService.instance.searchUsers(
        lastItemId: reset ? null : users.lastOrNull?.id,
        keyword: searchKeyword.text);
    if (reset) {
      users.clear();
    }
    if (items.isNotEmpty) {
      users.addAll(items);
    }
    isUsersLoading.value = false;
  }

  Future<void> searchHashTags({bool reset = false}) async {
    isHashTagsLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    List<Hashtag> items = await SearchService.instance.searchHashtags(
        keyword: searchKeyword.text.trim(),
        lastItemId: reset ? null : hashtags.lastOrNull?.id);
    if (reset) {
      hashtags.clear();
    }
    if (items.isNotEmpty) {
      hashtags.addAll(items);
    }
    isHashTagsLoading.value = false;
  }

  Future<void> searchPlace({bool reset = false}) async {
    isPlacesLoading.value = true;
    List<Places> items = await CommonService.instance
        .searchPlace(title: searchKeyword.text.trim());

    if (reset) {
      places.clear();
    }
    if (items.isNotEmpty) {
      places.addAll(items);
    }
    isPlacesLoading.value = false;
  }

  Future<void> fetchNearByLocation({Position? pos}) async {
    if (places.isNotEmpty) return;
    Position? position = pos;
    isPlacesLoading.value = true;
    isLocationError.value = false;
    if (position == null) {
      try {
        position = await LocationService.instance.getCurrentLocation();
        print('ABC $position');
        isLocationError.value = false;
      } catch (e) {
        Loggers.error(e);
        isLocationError.value = true;
        isPlacesLoading.value = false;
      }
    }

    if (position != null) {
      List<Places> _place = await CommonService.instance
          .searchNearBy(lat: position.latitude, lon: position.longitude);
      places.addAll(_place);
      isPlacesLoading.value = false;
    }
  }

  onUserTap(User user) {
    NavigationService.shared.openProfileScreen(user);
  }

  void onHashTagTap(Hashtag hashTag) {
    Get.to(HashtagScreen(hashtag: hashTag.hashtag ?? ''),
        preventDuplicates: false);
  }

  void onLocationTap(Places place) {
    double latitude = place.location?.latitude?.toDouble() ?? 0.0;
    double longitude = place.location?.longitude?.toDouble() ?? 0.0;
    LatLng latLng = LatLng(latitude, longitude);
    Get.to(LocationScreen(latLng: latLng, placeTitle: place.title),
        preventDuplicates: false);
  }
}

enum SearchTabs {
  feed,
  reels,
  users,
  hashtags,
  places;

  String get title {
    switch (this) {
      case SearchTabs.feed:
        return LKey.feed;
      case SearchTabs.reels:
        return LKey.reels;
      case SearchTabs.users:
        return LKey.users;
      case SearchTabs.hashtags:
        return LKey.hashtags;
      case SearchTabs.places:
        return LKey.places;
    }
  }
}
