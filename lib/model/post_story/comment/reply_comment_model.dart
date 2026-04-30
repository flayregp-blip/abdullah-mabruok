import 'package:shortzz/model/post_story/comment/fetch_comment_model.dart';

class ReplyCommentModel {
  ReplyCommentModel({
    this.status,
    this.message,
    this.data,
  });

  ReplyCommentModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Comment.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<Comment>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
