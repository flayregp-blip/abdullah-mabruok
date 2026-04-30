import 'package:flutter/material.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/manager/story_view/story_view.dart';
import 'package:shortzz/model/post_story/music/music_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/utilities/app_res.dart';

class StoryModel {
  StoryModel({
    this.status,
    this.message,
    this.data,
  });

  StoryModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Story.fromJson(json['data']) : null;
  }

  StoryModel.fromJsonWithUser(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Story.fromJsonWithUser(json['data']) : null;
  }

  bool? status;
  String? message;
  Story? data;

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

class Story {
  Story({
    this.id,
    this.userId,
    this.type,
    this.content,
    this.thumbnail,
    this.soundId,
    this.duration,
    this.viewByUserIds,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.music,
  });

  Story.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    content = json['content'];
    thumbnail = json['thumbnail'];
    soundId = json['sound_id'];
    duration = json['duration'];
    viewByUserIds = json['view_by_user_ids'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // user = json['user'] != null ? User.fromJson(json['user']) : null;
    music = json['music'] != null ? Music.fromJson(json['music']) : null;
  }

  Story.fromJsonWithUser(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    content = json['content'];
    thumbnail = json['thumbnail'];
    soundId = json['sound_id'];
    duration = json['duration'];
    viewByUserIds = json['view_by_user_ids'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    music = json['music'] != null ? Music.fromJson(json['music']) : null;
  }

  int? id;
  int? userId;
  int? type;
  String? content;
  String? thumbnail;
  num? soundId;
  String? duration;
  String? viewByUserIds;
  String? createdAt;
  String? updatedAt;
  User? user;
  Music? music;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['type'] = type;
    map['content'] = content;
    map['thumbnail'] = thumbnail;
    map['sound_id'] = soundId;
    map['duration'] = duration;
    map['view_by_user_ids'] = viewByUserIds;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    // if (user != null) {
    //   map['user'] = user?.toJson();
    // }
    if (music != null) {
      map['music'] = music?.toJson();
    }
    return map;
  }

  Map<String, dynamic> toJsonWithUser() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['type'] = type;
    map['content'] = content;
    map['thumbnail'] = thumbnail;
    map['sound_id'] = soundId;
    map['duration'] = duration;
    map['view_by_user_ids'] = viewByUserIds;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (music != null) {
      map['music'] = music?.toJson();
    }
    return map;
  }

  bool isWatchedByMe() {
    var arr = viewByUserIds?.split(',') ?? [];
    return arr.contains(SessionManager.instance.getUserID().toString());
  }

  List<String> viewedByUsersIds() {
    return viewByUserIds?.split(',') ?? [];
  }

  StoryItem toStoryItem(StoryController controller) {
    if (type == 1) {
      return StoryItem.pageVideo(
        '${content?.addBaseURL()}',
        story: this,
        controller: controller,
        duration: Duration(seconds: int.parse(duration ?? AppRes.storyVideoDuration.toString())),
        shown: isWatchedByMe(),
        id: id ?? 0,
        viewedByUsersIds: viewedByUsersIds(),
      );
    } else if (type == 0) {
      return StoryItem.pageImage(
        story: this,
        url: '${content?.addBaseURL()}',
        controller: controller,
        imageFit: BoxFit.fitWidth,
        duration:
            Duration(seconds: int.parse(duration ?? AppRes.storyImageAndTextDuration.toString())),
        shown: isWatchedByMe(),
        id: id ?? 0,
        viewedByUsersIds: viewedByUsersIds(),
      );
    } else {
      return StoryItem.text(
        story: this,
        title: '${content?.addBaseURL()}',
        backgroundColor: Colors.black,
        shown: isWatchedByMe(),
        id: id ?? 0,
        duration:
            Duration(seconds: int.parse(duration ?? AppRes.storyImageAndTextDuration.toString())),
        viewedByUsersIds: viewedByUsersIds(),
      );
    }
  }

  String get date => createdAt?.timeAgo ?? '';
}
