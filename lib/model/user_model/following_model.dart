import 'package:shortzz/model/user_model/user_model.dart';

class FollowingModel {
  FollowingModel({
    bool? status,
    String? message,
    List<Following>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  FollowingModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Following.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Following>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<Following>? get data => _data;

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

class Following {
  Following({
    int? id,
    int? fromUserId,
    int? toUserId,
    String? createdAt,
    String? updatedAt,
    User? toUser,
  }) {
    _id = id;
    _fromUserId = fromUserId;
    _toUserId = toUserId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _toUser = toUser;
  }

  Following.fromJson(dynamic json) {
    _id = json['id'];
    _fromUserId = json['from_user_id'];
    _toUserId = json['to_user_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _toUser = json['to_user'] != null ? User.fromJson(json['to_user']) : null;
  }

  int? _id;
  int? _fromUserId;
  int? _toUserId;
  String? _createdAt;
  String? _updatedAt;
  User? _toUser;

  int? get id => _id;

  int? get fromUserId => _fromUserId;

  int? get toUserId => _toUserId;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  User? get toUser => _toUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['from_user_id'] = _fromUserId;
    map['to_user_id'] = _toUserId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_toUser != null) {
      map['to_user'] = _toUser?.toJson();
    }
    return map;
  }
}
