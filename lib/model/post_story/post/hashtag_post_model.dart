import 'package:shortzz/model/post_story/hashtag_model.dart';
import 'package:shortzz/model/post_story/post_model.dart';

class HashtagPostModel {
  HashtagPostModel({
    this.status,
    this.message,
    this.data,
  });

  HashtagPostModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? HashtagPostData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  HashtagPostData? data;

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

class HashtagPostData {
  HashtagPostData({
    this.posts,
    this.hashtag,
  });

  HashtagPostData.fromJson(dynamic json) {
    if (json['posts'] != null) {
      posts = [];
      json['posts'].forEach((v) {
        posts?.add(Post.fromJson(v));
      });
    }
    hashtag =
        json['hashtag'] != null ? Hashtag.fromJson(json['hashtag']) : null;
  }

  List<Post>? posts;
  Hashtag? hashtag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (posts != null) {
      map['posts'] = posts?.map((v) => v.toJson()).toList();
    }
    if (hashtag != null) {
      map['hashtag'] = hashtag?.toJson();
    }
    return map;
  }
}
