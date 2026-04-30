import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/manager/haptic_manager.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/utilities/asset_res.dart';

class LocationScreenController extends BaseController {
  Rx<LatLng> latLng;
  RxString placeTitle;
  RxList<Post> reels = <Post>[].obs;
  RxList<Post> posts = <Post>[].obs;
  RxBool isReelLoading = false.obs;
  RxBool isPostLoading = false.obs;
  RxInt selectedTabIndex = 0.obs;
  RxMap<MarkerId, Marker> marker = <MarkerId, Marker>{}.obs;
  PageController pageController = PageController(initialPage: 0);
  Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  LocationScreenController(this.latLng, this.placeTitle);

  @override
  void onReady() {
    super.onReady();
    initData();
  }

  Future<void> initData() async {
    final result = await Future.wait({
      fetchReels(),
      fetchPosts(),
    });
    List<Post> reels = result[0];
    List<Post> posts = result[1];

    if (reels.isEmpty && posts.isNotEmpty) {
      pageController.animateToPage(1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }

  int? _getMinPostId(List<Post> items) {
    return items.isEmpty
        ? null
        : items.map((p) => p.id ?? 0).reduce((a, b) => a < b ? a : b);
  }

  Future<List<Post>> fetchReels({bool reset = false}) async {
    isReelLoading.value = true;

    final lastItemId = reset ? null : _getMinPostId(reels);
    final items = await PostService.instance.fetchPostsByLocation(
      type: PostType.reels,
      placeLat: latLng.value.latitude,
      placeLon: latLng.value.longitude,
      lastItemId: lastItemId,
    );

    if (reset) reels.clear();
    if (items.isNotEmpty) reels.addAll(items);

    isReelLoading.value = false;
    return reels;
  }

  Future<List<Post>> fetchPosts({bool reset = false}) async {
    isPostLoading.value = true;

    final lastItemId = reset ? null : _getMinPostId(posts);
    final items = await PostService.instance.fetchPostsByLocation(
      type: PostType.posts,
      placeLat: latLng.value.latitude,
      placeLon: latLng.value.longitude,
      lastItemId: lastItemId,
    );

    if (reset) posts.clear();
    if (items.isNotEmpty) posts.addAll(items);

    isPostLoading.value = false;
    return posts;
  }

  void onPageChanged(int value) {
    selectedTabIndex.value = value;
  }

  Future<void> fetchMoreData({bool reset = false}) async {
    Future.wait({fetchReels(reset: reset), fetchPosts(reset: reset)});
  }

  void onMapCreated(GoogleMapController controller) async {
    googleMapController.complete(controller);
    _createMarker(latLng.value);
  }

  Future<void> onMapTap(LatLng latLng) async {
    this.latLng.value = latLng;
    HapticManager.shared.light();
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      Loggers.success(placeMarks.first.toJson());
      placeTitle.value = placeMarks.first.name ?? '';
    } catch (e) {
      Loggers.error(e);
    }

    googleMapController.future.then((value) {
      value.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 14.4746)));
    });

    DebounceAction.shared.call(() {
      fetchMoreData(reset: true);
    });

    _createMarker(latLng);
  }

  Future<void> _createMarker(LatLng latLng) async {
    MarkerId markerId = const MarkerId('1');
    // Load custom icon correctly
    BitmapDescriptor customIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(35, 50)), // Adjust size if needed
        AssetRes.icMarkerPin);

    // Update the marker
    marker[markerId] = Marker(
        markerId: markerId,
        position: LatLng(latLng.latitude, latLng.longitude),
        icon: customIcon);
  }
}
