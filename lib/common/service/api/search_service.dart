import 'package:shortzz/common/service/api/api_service.dart';
import 'package:shortzz/common/service/utils/params.dart';
import 'package:shortzz/common/service/utils/web_service.dart';
import 'package:shortzz/model/post_story/hashtag_model.dart';
import 'package:shortzz/model/post_story/post/posts_model.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/model/user_model/users_model.dart';
import 'package:shortzz/utilities/app_res.dart';

class SearchService {
  SearchService._();

  static final SearchService instance = SearchService._();

  Future<List<Post>> searchPost({String? keyword, required String type, num? lastItemId}) async {
    PostsModel response = await ApiService.instance.call(
        url: WebService.search.searchPosts,
        param: ({
          Params.types: type,
          Params.limit: AppRes.paginationLimit,
          if ((keyword ?? '').isNotEmpty) Params.keyword: keyword,
          if (lastItemId != null) Params.lastItemId: lastItemId
        }),
        fromJson: PostsModel.fromJson);
    if (response.status == true) {
      return response.data ?? [];
    }

    return [];
  }

  Future<List<User>> searchUsers({String? keyword, num? lastItemId}) async {
    UsersModel response = await ApiService.instance.call(
        url: WebService.user.searchUsers,
        param: ({
          Params.limit: AppRes.paginationLimit,
          if ((keyword ?? '').isNotEmpty) Params.keyword: keyword,
          if (lastItemId != null) Params.lastItemId: lastItemId
        }),
        fromJson: UsersModel.fromJson);
    if (response.status == true) {
      return response.data ?? [];
    }
    return [];
  }

  Future<List<Hashtag>> searchHashtags({required String keyword, int? lastItemId}) async {
    HashtagModel model = await ApiService.instance.call(url: WebService.addPostStory.searchHashtags, fromJson: HashtagModel.fromJson, param: {
      Params.limit: AppRes.paginationLimit,
      if (lastItemId != 0) Params.lastItemId: lastItemId,
      if (keyword.isNotEmpty) Params.keyword: keyword
    });

    return model.data ?? [];
  }
}
