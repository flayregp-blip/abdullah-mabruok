import 'package:shortzz/model/user_model/user_model.dart';

class UsersModel {
  UsersModel({bool? status, String? message, List<User>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  UsersModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(User.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<User>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<User>? get data => _data;

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
