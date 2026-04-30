import 'dart:convert';

import 'package:get/get.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/service/url_extractor/parsers/base_parser.dart';
import 'package:shortzz/model/post_story/music/music_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';

class PostModel {
  PostModel({
    bool? status,
    String? message,
    Post? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  PostModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Post.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  Post? _data;

  bool? get status => _status;

  String? get message => _message;

  Post? get data => _data;

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

class Post {
  Post({
    this.id,
    this.postSaveId,
    this.postType = PostType.none,
    this.userId,
    this.soundId,
    this.metadata,
    this.description,
    this.hashtags,
    this.video,
    this.thumbnail,
    this.views,
    this.likes,
    this.comments,
    this.saves,
    this.shares,
    this.mentionedUserIds,
    this.isTrending,
    this.canComment,
    this.placeTitle,
    this.placeLat,
    this.placeLon,
    this.state,
    this.country,
    this.isPinned,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
    this.isSaved,
    this.mentionedUsers,
    this.images,
    this.music,
    this.user,
  });

  Post.fromJson(dynamic json) {
    id = json['id'];
    postSaveId = json['post_save_id'];
    postType = json['post_type'] != null
        ? PostType.fromString(json['post_type'])
        : PostType.none;
    userId = json['user_id'];
    metadata = json['metadata'];
    soundId = json['sound_id'];
    description = json['description'];
    hashtags = json['hashtags'];
    video = json['video'];
    thumbnail = json['thumbnail'];
    views = json['views'];
    likes = json['likes'];
    comments = json['comments'];
    saves = json['saves'];
    shares = json['shares'];
    mentionedUserIds = json['mentioned_user_ids'];
    isTrending = json['is_trending'];
    canComment = json['can_comment'];
    placeTitle = json['place_title'];
    placeLat = json['place_lat'];
    placeLon = json['place_lon'];
    state = json['state'];
    country = json['country'];
    isPinned = json['is_pinned'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isLiked = json['is_liked'];
    isSaved = json['is_saved'];
    if (json['mentioned_users'] != null) {
      mentionedUsers = [];
      json['mentioned_users'].forEach((v) {
        mentionedUsers?.add(User.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
    music = json['music'] != null ? Music.fromJson(json['music']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  int? id;
  int? postSaveId;
  PostType postType = PostType.none;
  int? userId;
  int? soundId;
  String? metadata;
  String? description;
  String? hashtags;
  String? video;
  String? thumbnail;
  num? views;
  num? likes;
  num? comments;
  num? saves;
  num? shares;
  String? mentionedUserIds;
  num? isTrending;
  num? canComment;
  String? placeTitle;
  num? placeLat;
  num? placeLon;
  String? state;
  String? country;
  int? isPinned;
  String? createdAt;
  String? updatedAt;
  bool? isLiked;
  bool? isSaved;
  List<User>? mentionedUsers;
  List<Images>? images;
  Music? music;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['post_save_id'] = postSaveId;
    map['post_type'] = postType.type;
    map['user_id'] = userId;
    map['sound_id'] = soundId;
    map['metadata'] = metadata;
    map['description'] = description;
    map['hashtags'] = hashtags;
    map['video'] = video;
    map['thumbnail'] = thumbnail;
    map['views'] = views;
    map['likes'] = likes;
    map['comments'] = comments;
    map['saves'] = saves;
    map['shares'] = shares;
    map['mentioned_user_ids'] = mentionedUserIds;
    map['is_trending'] = isTrending;
    map['can_comment'] = canComment;
    map['place_title'] = placeTitle;
    map['place_lat'] = placeLat;
    map['place_lon'] = placeLon;
    map['state'] = state;
    map['country'] = country;
    map['is_pinned'] = isPinned;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_liked'] = isLiked;
    map['is_saved'] = isSaved;
    if (mentionedUsers != null) {
      map['mentioned_users'] = mentionedUsers?.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      map['images'] = images?.map((v) => v.toJson()).toList();
    }

    if (music != null) {
      map['music'] = music?.toJson();
    }

    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

  Map<String, dynamic> toJsonForChat() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['post_save_id'] = postSaveId;
    map['post_type'] = postType.type;
    map['user_id'] = userId;
    map['sound_id'] = soundId;
    map['metadata'] = metadata;
    map['description'] = description;
    map['hashtags'] = hashtags;
    map['video'] = video;
    map['thumbnail'] = thumbnail;
    // map['views'] = views;
    // map['likes'] = likes;
    // map['comments'] = comments;
    // map['saves'] = saves;
    map['shares'] = shares;
    map['mentioned_user_ids'] = mentionedUserIds;
    map['is_trending'] = isTrending;
    map['can_comment'] = canComment;
    map['place_title'] = placeTitle;
    map['place_lat'] = placeLat;
    map['place_lon'] = placeLon;
    map['state'] = state;
    map['country'] = country;
    map['is_pinned'] = isPinned;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    // map['is_liked'] = isLiked;
    // map['is_saved'] = isSaved;
    if (mentionedUsers != null) {
      map['mentioned_users'] = mentionedUsers?.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      map['images'] = images?.map((v) => v.toJson()).toList();
    }

    if (music != null) {
      map['music'] = music?.toJson();
    }

    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

  String get descriptionWithUserName {
    List<String> mentionIds = (mentionedUserIds ?? '').split(',');
    String updatedDescription = description ?? '';

    for (var element in mentionIds) {
      User? user =
          mentionedUsers?.firstWhereOrNull((u) => u.id == int.parse(element));
      if (user != null) {
        updatedDescription =
            updatedDescription.replaceAll('@$element', '@${user.username}');
      }
    }
    return updatedDescription;
  }

  void likeToggle(bool isLike) {
    isLiked = isLike;
    int i = isLike ? 1 : -1;
    likes = ((likes ?? 0) + i).clamp(0, double.infinity).toInt();
    user?.totalPostLikesCount = ((user?.totalPostLikesCount ?? 0) + i)
        .clamp(0, double.infinity)
        .toInt();
  }

  void saveToggle(bool isSave) {
    isSaved = isSave;
    int i = isSave ? 1 : -1;
    saves = ((saves ?? 0) + i).clamp(0, double.infinity).toInt();
  }

  void increaseShares(int count) {
    shares = (shares ?? 0) + count;
  }

  void increaseViews() {
    views = (views ?? 0) + 1;
  }

  void updateCommentCount(int i) {
    comments = (comments ?? 0) + i;
  }

  String get getThumbnail {
    return (postType == PostType.image
        ? (images?.first.image ?? '')
        : (thumbnail ?? ''));
  }

  UrlMetadata? get metaData {
    if (metadata == null || metadata?.isEmpty == true) {
      return null;
    } else {
      Map<String, dynamic>? valueMap = jsonDecode(metadata ?? '');
      if (valueMap != null) return UrlMetadata.fromJson(valueMap);
    }
    return null;
  }
}

class Images {
  Images({
    num? id,
    num? postId,
    String? image,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _postId = postId;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Images.fromJson(dynamic json) {
    _id = json['id'];
    _postId = json['post_id'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  num? _id;
  num? _postId;
  String? _image;
  String? _createdAt;
  String? _updatedAt;

  num? get id => _id;

  num? get postId => _postId;

  String? get image => _image;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['post_id'] = _postId;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
