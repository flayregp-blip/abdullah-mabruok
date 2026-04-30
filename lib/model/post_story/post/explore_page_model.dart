import 'package:shortzz/model/post_story/hashtag_model.dart';
import 'package:shortzz/model/post_story/post_model.dart';

class ExplorePageModel {
  ExplorePageModel({
    this.status,
    this.message,
    this.data,
  });

  ExplorePageModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ExplorePageData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  ExplorePageData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class ExplorePageData {
  ExplorePageData({
    this.hashtags,
    this.highPostHashtags,
  });

  ExplorePageData.fromJson(dynamic json) {
    if (json['hashtags'] != null) {
      hashtags = [];
      json['hashtags'].forEach((v) {
        hashtags?.add(Hashtag.fromJson(v));
      });
    }
    if (json['highPostHashtags'] != null) {
      highPostHashtags = [];
      json['highPostHashtags'].forEach((v) {
        highPostHashtags?.add(HighPostHashtags.fromJson(v));
      });
    }
  }

  List<Hashtag>? hashtags;
  List<HighPostHashtags>? highPostHashtags;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (hashtags != null) {
      map['hashtags'] = hashtags?.map((v) => v.toJson()).toList();
    }
    if (highPostHashtags != null) {
      map['highPostHashtags'] = highPostHashtags?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class HighPostHashtags {
  HighPostHashtags({
    this.id,
    this.hashtag,
    this.postCount,
    this.onExplore,
    this.createdAt,
    this.updatedAt,
    this.postList,
  });

  HighPostHashtags.fromJson(dynamic json) {
    id = json['id'];
    hashtag = json['hashtag'];
    postCount = json['post_count'];
    onExplore = json['on_explore'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['postList'] != null) {
      postList = [];
      json['postList'].forEach((v) {
        postList?.add(Post.fromJson(v));
      });
    }
  }

  num? id;
  String? hashtag;
  num? postCount;
  num? onExplore;
  String? createdAt;
  String? updatedAt;
  List<Post>? postList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['hashtag'] = hashtag;
    map['post_count'] = postCount;
    map['on_explore'] = onExplore;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (postList != null) {
      map['postList'] = postList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
