import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/model/giphy/giphy_model.dart';

// https://developers.giphy.com/docs/optional-settings/#rating
enum GiphyRating {
  g,
  pg,
  pg_13,
  r;

  String get title {
    switch (this) {
      case GiphyRating.g:
        return 'g';
      case GiphyRating.pg:
        return 'pg';
      case GiphyRating.pg_13:
        return 'pg-13';
      case GiphyRating.r:
        return 'r';
    }
  }
}

class GiphyService {
  GiphyService._();

  static final GiphyService instance = GiphyService._();

  int paginationLimit = 30;

  Future<List<GiphyData>> search({
    required String apiKey,
    required String keyWord,
    required int startCount,
    GiphyRating giphyRating = GiphyRating.g,
  }) async {
    String url =
        'https://api.giphy.com/v1/stickers/search?api_key=$apiKey&q=$keyWord&limit=$paginationLimit&offset=$startCount&rating=${giphyRating.title}';
    http.Response response = await http.get(Uri.parse(url));
    Loggers.info(url);
    if (response.statusCode == 200) {
      return GiphyModel.fromJson(jsonDecode(response.body)).data ?? [];
    }
    return [];
  }

  Future<List<GiphyData>> trending(
      {required String apiKey,
      GiphyRating giphyRating = GiphyRating.g,
      required int startCount}) async {
    String url =
        'https://api.giphy.com/v1/stickers/trending?api_key=$apiKey&limit=$paginationLimit&offset=$startCount&rating=${giphyRating.title}';
    Loggers.info(url);
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return GiphyModel.fromJson(jsonDecode(response.body)).data ?? [];
    }
    return [];
  }
}
