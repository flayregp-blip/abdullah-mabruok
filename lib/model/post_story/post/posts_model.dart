import 'package:shortzz/model/post_story/post_model.dart';

class PostsModel {
  PostsModel({
    bool? status,
    String? message,
    List<Post>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  PostsModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Post.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Post>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<Post>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
