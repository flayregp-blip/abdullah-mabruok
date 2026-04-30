import 'package:get/get.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/comment_sheet/helper/comment_helper.dart';

class FetchCommentModel {
  FetchCommentModel({
    this.status,
    this.message,
    this.data,
  });

  FetchCommentModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CommentData.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  CommentData? data;

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

class CommentData {
  CommentData({
    this.comments,
    this.pinnedComments,
  });

  CommentData.fromJson(dynamic json) {
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(Comment.fromJson(v));
      });
    }
    if (json['pinnedComments'] != null) {
      pinnedComments = [];
      json['pinnedComments'].forEach((v) {
        pinnedComments?.add(Comment.fromJson(v));
      });
    }
  }

  List<Comment>? comments;
  List<Comment>? pinnedComments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (comments != null) {
      map['comments'] = comments?.map((v) => v.toJson()).toList();
    }
    if (pinnedComments != null) {
      map['pinnedComments'] = pinnedComments?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Comment {
  Comment({
    this.id,
    this.commentId,
    this.postId,
    this.userId,
    this.comment,
    this.reply,
    this.mentionedUserIds,
    this.likes,
    this.repliesCount,
    this.isPinned,
    this.type = CommentType.text,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
    this.mentionedUsers,
    this.user,
  });

  Comment.fromJson(dynamic json) {
    id = json['id'];
    commentId = json['comment_id'];
    postId = json['post_id'];
    userId = json['user_id'];
    comment = json['comment'];
    reply = json['reply'];
    mentionedUserIds = json['mentioned_user_ids'];
    likes = json['likes'];
    repliesCount = json['replies_count'];
    isPinned = json['is_pinned'];
    type = json['type'] == null
        ? CommentType.text
        : CommentType.values
            .firstWhere((element) => element.value == json['type']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isLiked = json['is_liked'];
    if (json['mentionedUsers'] != null) {
      mentionedUsers = [];
      json['mentionedUsers'].forEach((v) {
        mentionedUsers?.add(User.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  int? id;
  int? postId;
  int? commentId;
  num? userId;
  String? comment;
  String? reply;
  String? mentionedUserIds;
  num? likes;
  num? repliesCount;
  num? isPinned;
  CommentType type = CommentType.text;
  String? createdAt;
  String? updatedAt;
  bool? isLiked;
  List<User>? mentionedUsers;
  User? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['post_id'] = postId;
    map['comment_id'] = commentId;
    map['user_id'] = userId;
    map['comment'] = comment;
    map['reply'] = reply;
    map['mentioned_user_ids'] = mentionedUserIds;
    map['likes'] = likes;
    map['replies_count'] = repliesCount;
    map['is_pinned'] = isPinned;
    map['type'] = type.value;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_liked'] = isLiked;
    if (mentionedUsers != null) {
      map['mentionedUsers'] = mentionedUsers?.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

  String get commentDescription {
    List<String> mentionIds = (mentionedUserIds ?? '').split(',');
    String updatedDescription = comment ?? reply ?? '';

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

  void updateLike(bool isLike) {
    isLiked = isLike;
    if (isLike) {
      likes = (likes ?? 0) + 1;
    } else {
      likes = (likes ?? 0) > 0 ? (likes ?? 0) - 1 : 0;
    }
  }
}
