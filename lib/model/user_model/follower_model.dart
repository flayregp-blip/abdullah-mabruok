import 'package:shortzz/model/user_model/user_model.dart';

class FollowerModel {
  FollowerModel({bool? status, String? message, List<Follower>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  FollowerModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Follower.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Follower>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<Follower>? get data => _data;

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

class Follower {
  Follower({
    int? id,
    int? fromUserId,
    int? toUserId,
    num? status,
    String? createdAt,
    String? updatedAt,
    User? fromUser,
  }) {
    _id = id;
    _fromUserId = fromUserId;
    _toUserId = toUserId;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _fromUser = fromUser;
  }

  Follower.fromJson(dynamic json) {
    _id = json['id'];
    _fromUserId = json['from_user_id'];
    _toUserId = json['to_user_id'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _fromUser =
        json['from_user'] != null ? User.fromJson(json['from_user']) : null;
  }

  int? _id;
  int? _fromUserId;
  int? _toUserId;
  num? _status;
  String? _createdAt;
  String? _updatedAt;
  User? _fromUser;

  int? get id => _id;

  int? get fromUserId => _fromUserId;

  int? get toUserId => _toUserId;

  num? get status => _status;

  set status(num? value) {
    _status = value;
  }

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  User? get fromUser => _fromUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['from_user_id'] = _fromUserId;
    map['to_user_id'] = _toUserId;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_fromUser != null) {
      map['from_user'] = _fromUser?.toJson();
    }
    return map;
  }
}
