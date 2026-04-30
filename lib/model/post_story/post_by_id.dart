// To parse this JSON data, do
//
//     final postByIdModel = postByIdModelFromJson(jsonString);

import 'dart:convert';

import 'package:shortzz/model/post_story/post_model.dart';

import 'comment/fetch_comment_model.dart';

PostByIdModel postByIdModelFromJson(String str) =>
    PostByIdModel.fromJson(json.decode(str));

String postByIdModelToJson(PostByIdModel data) => json.encode(data.toJson());

class PostByIdModel {
  bool? status;
  String? message;
  PostByIdData? data;

  PostByIdModel({
    this.status,
    this.message,
    this.data,
  });

  factory PostByIdModel.fromJson(Map<String, dynamic> json) => PostByIdModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : PostByIdData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class PostByIdData {
  Post? post;
  Comment? comment;
  Comment? reply;

  PostByIdData({
    this.post,
    this.comment,
    this.reply,
  });

  factory PostByIdData.fromJson(Map<String, dynamic> json) => PostByIdData(
        post: json["post"] == null ? null : Post.fromJson(json["post"]),
        comment:
            json["comment"] == null ? null : Comment.fromJson(json["comment"]),
        reply: json["reply"] == null ? null : Comment.fromJson(json["reply"]),
      );

  Map<String, dynamic> toJson() => {
        "post": post?.toJson(),
        "comment": comment?.toJson(),
        "reply": reply?.toJson(),
      };
}
