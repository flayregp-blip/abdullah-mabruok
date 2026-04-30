import 'package:shortzz/model/user_model/user_model.dart';

class BlockUserModel {
  BlockUserModel({
    this.status,
    this.message,
    this.data,
  });

  BlockUserModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(BlockUsers.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<BlockUsers>? data;

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

class BlockUsers {
  BlockUsers({
    this.id,
    this.fromUserId,
    this.toUserId,
    this.createdAt,
    this.updatedAt,
    this.toUser,
  });

  BlockUsers.fromJson(dynamic json) {
    id = json['id'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    toUser = json['to_user'] != null ? User.fromJson(json['to_user']) : null;
  }

  num? id;
  num? fromUserId;
  num? toUserId;
  String? createdAt;
  String? updatedAt;
  User? toUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['from_user_id'] = fromUserId;
    map['to_user_id'] = toUserId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (toUser != null) {
      map['to_user'] = toUser?.toJson();
    }
    return map;
  }
}
