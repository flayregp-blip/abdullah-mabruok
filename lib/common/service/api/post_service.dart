import 'package:image_picker/image_picker.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/service/api/api_service.dart';
import 'package:shortzz/common/service/utils/params.dart';
import 'package:shortzz/common/service/utils/web_service.dart';
import 'package:shortzz/model/general/status_model.dart';
import 'package:shortzz/model/post_story/comment/add_comment_model.dart';
import 'package:shortzz/model/post_story/comment/fetch_comment_model.dart';
import 'package:shortzz/model/post_story/comment/reply_comment_model.dart';
import 'package:shortzz/model/post_story/music/music_model.dart';
import 'package:shortzz/model/post_story/music/musics_model.dart';
import 'package:shortzz/model/post_story/post/explore_page_model.dart';
import 'package:shortzz/model/post_story/post/hashtag_post_model.dart';
import 'package:shortzz/model/post_story/post/posts_model.dart';
import 'package:shortzz/model/post_story/post_by_id.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/post_story/story/stories_model.dart';
import 'package:shortzz/model/post_story/story/story_model.dart';
import 'package:shortzz/model/post_story/user_post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/utilities/app_res.dart';

enum PostType {
  reel,
  image,
  video,
  text,
  none;

  int get type {
    switch (this) {
      case PostType.reel:
        return 1;
      case PostType.image:
        return 2;
      case PostType.video:
        return 3;
      case PostType.text:
        return 4;
      case PostType.none:
        return 0;
    }
  }

  static String get posts =>
      '${PostType.image.type},${PostType.video.type},${PostType.text.type}';

  static String get reels => '${PostType.reel.type}';

  static PostType fromString(int value) {
    return PostType.values.firstWhere(
      (e) => e.type == value,
      orElse: () => throw ArgumentError('Invalid MessageType: $value'),
    );
  }
}

class PostService {
  PostService._();

  static final PostService instance = PostService._();

  Future<List<Post>> fetchPostsDiscover(
      {required String type, CancelToken? cancelToken}) async {
    PostsModel model = await ApiService.instance.call(
        url: WebService.post.fetchPostsDiscover,
        param: {Params.limit: AppRes.paginationLimit, Params.types: type},
        fromJson: PostsModel.fromJson,
        cancelToken: cancelToken);
    return model.data ?? [];
  }

  Future<PostByIdModel> fetchPostById(
      {required int postId, int? commentId, int? replyId}) async {
    if (postId == -1) {
      Loggers.error('InValid Post Id : $postId');
      return PostByIdModel();
    }
    PostByIdModel model = await ApiService.instance.call(
        url: WebService.post.fetchPostById,
        param: {
          Params.postId: postId,
          if (commentId != null) Params.commentId: commentId,
          if (replyId != null) Params.replyId: replyId
        },
        fromJson: PostByIdModel.fromJson);
    return model;
  }

  Future<List<Post>> fetchPostsNearBy(
      {required String type,
      required double placeLat,
      required double placeLon,
      CancelToken? cancelToken}) async {
    PostsModel model = await ApiService.instance.call(
        url: WebService.post.fetchPostsNearBy,
        param: {
          Params.placeLat: placeLat,
          Params.placeLon: placeLon,
          Params.types: type,
        },
        fromJson: PostsModel.fromJson,
        cancelToken: cancelToken);
    return model.data ?? [];
  }

  Future<List<Post>> fetchPostsFollowing(
      {required String type, CancelToken? cancelToken}) async {
    PostsModel model = await ApiService.instance.call(
        url: WebService.post.fetchPostsFollowing,
        param: {Params.limit: AppRes.paginationLimit, Params.types: type},
        fromJson: PostsModel.fromJson,
        cancelToken: cancelToken);
    return model.data ?? [];
  }

  Future<List<Post>> fetchReelPostsByMusic(
      {int? musicId, int? lastItemId}) async {
    PostsModel model = await ApiService.instance.call(
        url: WebService.post.fetchReelPostsByMusic,
        param: {
          Params.limit: AppRes.paginationLimit,
          Params.lastItemId: lastItemId,
          Params.musicId: musicId,
        },
        fromJson: PostsModel.fromJson);
    return model.data ?? [];
  }

  Future<List<Post>> fetchPostsByLocation(
      {required String type,
      required double placeLat,
      required double placeLon,
      int? lastItemId}) async {
    PostsModel model = await ApiService.instance.call(
        url: WebService.post.fetchPostsByLocation,
        param: {
          Params.limit: AppRes.paginationLimit,
          Params.lastItemId: lastItemId,
          Params.types: type,
          Params.placeLat: placeLat,
          Params.placeLon: placeLon
        },
        fromJson: PostsModel.fromJson);
    return model.data ?? [];
  }

  Future<UserPostData?> fetchUserPosts(
      {required String type,
      required int? userId,
      required int? lastItemId}) async {
    UserPostModel model = await ApiService.instance.call(
        url: WebService.post.fetchUserPosts,
        param: {
          Params.limit: AppRes.paginationLimit,
          Params.userId: userId,
          Params.types: type,
          Params.lastItemId: lastItemId
        },
        fromJson: UserPostModel.fromJson);
    return model.data;
  }

  Future<HashtagPostData?> fetchPostsByHashtag(
      {required String type,
      required String hashTag,
      required int? lastItemId}) async {
    HashtagPostModel model = await ApiService.instance.call(
        url: WebService.post.fetchPostsByHashtag,
        param: {
          Params.limit: AppRes.paginationLimit,
          Params.hashtag: hashTag,
          Params.types: type,
          Params.lastItemId: lastItemId
        },
        fromJson: HashtagPostModel.fromJson);
    return model.data;
  }

  Future<List<Post>> fetchSavedPosts(
      {required String type, required int? lastItemId}) async {
    PostsModel model = await ApiService.instance.call(
        url: WebService.post.fetchSavedPosts,
        param: {
          Params.types: type,
          Params.limit: AppRes.paginationLimit,
          Params.lastItemId: lastItemId
        },
        fromJson: PostsModel.fromJson);
    return model.data ?? [];
  }

  Future<StatusModel> deletePost({int? postId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.deletePost,
        param: {Params.postId: postId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> deleteComment({int? commentId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.deleteComment,
        param: {Params.commentId: commentId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> deleteCommentReply({int? replyId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.deleteCommentReply,
        param: {Params.replyId: replyId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> increaseShareCount({int? postId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.increaseShareCount,
        param: {Params.postId: postId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> increaseViewsCount({int? postId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.increaseViewsCount,
        param: {Params.postId: postId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> likeComment({int? commentId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.likeComment,
        param: {Params.commentId: commentId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> disLikeComment({int? commentId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.disLikeComment,
        param: {Params.commentId: commentId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> likePost({required int postId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.likePost,
        param: {Params.postId: postId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> pinPost({required int postId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.pinPost,
        param: {Params.postId: postId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> unpinPost({required int postId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.unpinPost,
        param: {Params.postId: postId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> pinComment({required int commentId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.pinComment,
        param: {Params.commentId: commentId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> unPinComment({required int commentId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.unPinComment,
        param: {Params.commentId: commentId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> disLikePost({required int postId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.disLikePost,
        param: {Params.postId: postId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> savePost({required int postId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.savePost,
        param: {Params.postId: postId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<StatusModel> unSavePost({required int postId}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.unSavePost,
        param: {Params.postId: postId},
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<CommentData?> fetchPostComments(
      {required int postId, int? lastItemId}) async {
    FetchCommentModel model = await ApiService.instance.call(
        url: WebService.post.fetchPostComments,
        param: {
          Params.postId: postId,
          Params.limit: AppRes.paginationLimit,
          Params.lastItemId: lastItemId
        },
        fromJson: FetchCommentModel.fromJson);
    return model.data;
  }

  Future<List<Comment>> fetchPostCommentReplies(
      {required int commentId, int? lastItemId}) async {
    ReplyCommentModel model = await ApiService.instance.call(
        url: WebService.post.fetchPostCommentReplies,
        param: {
          Params.commentId: commentId,
          Params.limit: AppRes.paginationLimit,
          if (lastItemId != null) Params.lastItemId: lastItemId
        },
        fromJson: ReplyCommentModel.fromJson);
    return model.data ?? [];
  }

  Future<Comment?> addComment(
      {required int postId,
      int? type,
      required String comment,
      String? mentionUserIds}) async {
    AddCommentModel model = await ApiService.instance.call(
        url: WebService.post.addPostComment,
        param: {
          Params.postId: postId,
          Params.type: type,
          Params.comment: comment,
          Params.mentionedUserIds: mentionUserIds
        },
        fromJson: AddCommentModel.fromJson);
    if (model.status == false) {
      BaseController.share.showSnackBar(model.message);
    }
    return model.data;
  }

  Future<Comment?> replyToComment(
      {required int commentId,
      required String reply,
      String? mentionUserIds}) async {
    AddCommentModel model = await ApiService.instance.call(
        url: WebService.post.replyToComment,
        param: {
          Params.commentId: commentId,
          Params.reply: reply,
          Params.mentionedUserIds: mentionUserIds
        },
        fromJson: AddCommentModel.fromJson);
    if (model.status == false) {
      BaseController.share.showSnackBar(model.message);
    }

    return model.data;
  }

  Future<StatusModel> reportPost(
      {required int postId,
      required String reason,
      required String description}) async {
    StatusModel model = await ApiService.instance.call(
        url: WebService.post.reportPost,
        param: {
          Params.postId: postId,
          Params.reason: reason,
          Params.description: description,
        },
        fromJson: StatusModel.fromJson);
    return model;
  }

  Future<List<Music>> fetchMusicExplore({int? lastItemId}) async {
    MusicsModel response = await ApiService.instance.call(
        url: WebService.post.fetchMusicExplore,
        param: {
          Params.limit: AppRes.paginationLimit,
          Params.lastItemId: lastItemId
        },
        fromJson: MusicsModel.fromJson);

    if (response.status == true) {
      return response.data ?? [];
    }

    return [];
  }

  Future<List<Music>> fetchMusicByCategories(
      {int? lastItemId, required int categoryId}) async {
    MusicsModel response = await ApiService.instance.call(
        url: WebService.post.fetchMusicByCategories,
        param: {
          Params.limit: AppRes.paginationLimit,
          Params.lastItemId: lastItemId,
          Params.categoryId: categoryId
        },
        fromJson: MusicsModel.fromJson);
    if (response.status == true) {
      return response.data ?? [];
    }
    return [];
  }

  Future<List<Music>> fetchSavedMusics() async {
    MusicsModel response = await ApiService.instance.call(
        url: WebService.post.fetchSavedMusics, fromJson: MusicsModel.fromJson);

    if (response.status == true) {
      return response.data ?? [];
    }

    return [];
  }

  Future<List<Music>> searchMusic(
      {required String keyword, int? lastItemId}) async {
    MusicsModel response = await ApiService.instance.call(
        url: WebService.post.serchMusic,
        param: {
          Params.limit: AppRes.paginationLimit,
          Params.keyword: keyword,
          Params.lastItemId: lastItemId
        },
        fromJson: MusicsModel.fromJson);

    if (response.status == true) {
      return response.data ?? [];
    }

    return [];
  }

  Future<StoryModel> createStory({
    required Map<String, dynamic> param,
    required Map<String, List<XFile?>> files,
  }) async {
    StoryModel response = await ApiService.instance.multiPartCallApi(
        url: WebService.post.createStory,
        filesMap: files,
        param: param,
        fromJson: StoryModel.fromJson);
    return response;
  }

  Future<Story?> viewStory({
    required int storyId,
  }) async {
    StoryModel response = await ApiService.instance.call(
        url: WebService.post.viewStory,
        param: {Params.storyId: storyId},
        fromJson: StoryModel.fromJson);
    if (response.status == true) {
      return response.data;
    }
    return null;
  }

  Future<StatusModel> deleteStory({
    required int storyId,
  }) async {
    StatusModel response = await ApiService.instance.call(
        url: WebService.post.deleteStory,
        param: {Params.storyId: storyId},
        fromJson: StatusModel.fromJson);

    return response;
  }

  Future<Music?> addUserMusic({
    required String title,
    required String duration,
    required String artist,
    required XFile? sound,
    required XFile? image,
  }) async {
    MusicModel response = await ApiService.instance.multiPartCallApi(
        url: WebService.post.addUserMusic,
        param: {
          Params.title: title,
          Params.duration: duration,
          Params.artist: artist
        },
        fromJson: MusicModel.fromJson,
        filesMap: {
          Params.sound: [sound],
          if (image != null) Params.image: [image],
        });
    return response.data;
  }

  Future<List<User>> fetchStory() async {
    StoriesModel response = await ApiService.instance
        .call(url: WebService.post.fetchStory, fromJson: StoriesModel.fromJson);
    if (response.status == true) {
      return response.data ?? [];
    }
    return [];
  }

  Future<Story?> fetchStoryByID(int id) async {
    StoryModel response = await ApiService.instance.call(
        url: WebService.post.fetchStoryByID,
        fromJson: StoryModel.fromJsonWithUser,
        param: {Params.storyId: id});
    if (response.status == true) {
      return response.data;
    }
    return null;
  }

  Future<ExplorePageData?> fetchExplorePageData() async {
    ExplorePageModel response = await ApiService.instance.call(
        url: WebService.post.fetchExplorePageData,
        fromJson: ExplorePageModel.fromJson);
    if (response.status == true) {
      return response.data;
    } else {
      Loggers.error(response.message);
      return null;
    }
  }
}
