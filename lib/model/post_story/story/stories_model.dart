import 'package:shortzz/model/user_model/user_model.dart';

class StoriesModel {
  StoriesModel({
    this.status,
    this.message,
    this.data,
  });

  StoriesModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(User.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<User>? data;

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
