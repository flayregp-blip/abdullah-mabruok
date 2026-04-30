import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/model/user_model/user_model.dart';

class MusicModel {
  MusicModel({
    this.status,
    this.message,
    this.data,
  });

  MusicModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Music.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  Music? data;

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

class Music {
  Music({
    this.id,
    this.categoryId,
    this.postCount,
    this.addedBy,
    this.userId,
    this.title,
    this.sound,
    this.duration,
    this.artist,
    this.image,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  Music.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    postCount = json['post_count'];
    addedBy = json['added_by'];
    userId = json['user_id'];
    title = json['title'];
    sound = json['sound'];
    duration = json['duration'];
    artist = json['artist'];
    image = json['image'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user'])
        : null;
  }

  int? id;
  int? categoryId;
  int? postCount;
  int? addedBy;
  int? userId;
  String? title;
  String? sound;
  String? duration;
  String? artist;
  String? image;
  num? isDeleted;
  String? createdAt;
  String? updatedAt;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['post_count'] = postCount;
    map['added_by'] = addedBy;
    map['user_id'] = userId;
    map['title'] = title;
    map['sound'] = sound;
    map['duration'] = duration;
    map['artist'] = artist;
    map['image'] = image;
    map['is_deleted'] = isDeleted;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null && addedBy == 0) {
      map['user'] = user?.toJson();
    }
    return map;
  }

  /// Private field to store isSaved value
  bool _isSaved = false;

  /// Getter for isSaved
  bool get isSaved {
    final user = SessionManager.instance.getUser();
    return user?.savedMusicIds?.split(',').contains(id.toString()) ?? _isSaved;
  }

  /// Setter for isSaved
  set isSaved(bool value) {
    final user = SessionManager.instance.getUser();
    if (user == null || id == null) return;

    List<String> savedIds = user.savedMusicIds?.split(',') ?? [];

    if (value) {
      if (!savedIds.contains(id.toString())) {
        savedIds.add(id.toString()); // Add to saved list
      }
    } else {
      savedIds.remove(id.toString()); // Remove from saved list
    }

    // Update user's savedMusicIds in SessionManager
    user.savedMusicIds = savedIds.join(',');

    // Persist the change (Assuming SessionManager has a method to update the user)
    SessionManager.instance.setUser(user);

    // Update the local variable
    _isSaved = value;
  }
}
