import 'package:shortzz/model/post_story/comment/fetch_comment_model.dart';

class AddCommentModel {
  AddCommentModel({
    this.status,
    this.message,
    this.data,
  });

  AddCommentModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Comment.fromJson(json['data']) : null;
  }

  bool? status;
  String? message;
  Comment? data;

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
