import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/giphy_service.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/giphy/giphy_model.dart';

class GifSheetController extends BaseController {
  RxList<GiphyData> trendingList = <GiphyData>[].obs;
  RxList<GiphyData> searchingGiphyList = <GiphyData>[].obs;
  final Setting? setting = SessionManager.instance.getSettings();
  RxBool isTrendingLoading = false.obs;
  RxBool isSearchLoading = false.obs;
  TextEditingController searchTextController = TextEditingController();
  RxBool isTextEmpty = true.obs;

  @override
  void onInit() {
    super.onInit();

    fetchTrendingGiphy();
  }

  Future<void> fetchTrendingGiphy({bool isEmpty = false}) async {
    if (isTrendingLoading.value || trendingList.length > 89) return;
    isTrendingLoading.value = true;
    String apiKey = setting?.giphyKey ?? '';
    List<GiphyData> items = await GiphyService.instance.trending(
        apiKey: apiKey,
        startCount:
            isEmpty ? 0 : (trendingList.isEmpty ? 0 : trendingList.length));
    if (isEmpty) trendingList.clear();
    if (items.isNotEmpty) {
      trendingList.addAll(items);
    }
    isTrendingLoading.value = false;
  }

  Future<void> fetchSearchGiphy({bool isEmpty = false}) async {
    if (isSearchLoading.value) return;
    if (!isEmpty && searchingGiphyList.length > 89) return;
    isSearchLoading.value = true;
    String apiKey = setting?.giphyKey ?? '';
    List<GiphyData> items = await GiphyService.instance.search(
        apiKey: apiKey,
        keyWord: searchTextController.text.trim(),
        startCount: isEmpty
            ? 0
            : (searchingGiphyList.isEmpty ? 0 : searchingGiphyList.length));
    if (isEmpty) searchingGiphyList.clear();
    if (items.isNotEmpty) {
      searchingGiphyList.addAll(items);
    }
    isSearchLoading.value = false;
  }

  onChanged(String value) async {
    isTextEmpty.value = value.trim().isEmpty;
    DebounceAction.shared.call(() {
      if (value.isEmpty) {
        fetchTrendingGiphy(isEmpty: true);
      } else {
        fetchSearchGiphy(isEmpty: true);
      }
    });
  }
}
