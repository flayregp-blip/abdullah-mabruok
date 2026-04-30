import 'package:shortzz/model/post_story/post_model.dart';

class UserPostModel {
  UserPostModel({
    bool? status,
    String? message,
    UserPostData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  UserPostModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? UserPostData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  UserPostData? _data;

  bool? get status => _status;

  String? get message => _message;

  UserPostData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class UserPostData {
  UserPostData({
    List<Post>? posts,
    List<Post>? pinnedPostList,
  }) {
    _posts = posts;
    _pinnedPostList = pinnedPostList;
  }

  UserPostData.fromJson(dynamic json) {
    if (json['posts'] != null) {
      _posts = [];
      json['posts'].forEach((v) {
        _posts?.add(Post.fromJson(v));
      });
    }
    if (json['pinnedPostList'] != null) {
      _pinnedPostList = [];
      json['pinnedPostList'].forEach((v) {
        _pinnedPostList?.add(Post.fromJson(v));
      });
    }
  }

  List<Post>? _posts;
  List<Post>? _pinnedPostList;

  List<Post>? get posts => _posts;

  List<Post>? get pinnedPostList => _pinnedPostList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_posts != null) {
      map['posts'] = _posts?.map((v) => v.toJson()).toList();
    }
    if (_pinnedPostList != null) {
      map['pinnedPostList'] = _pinnedPostList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
