import 'package:shortzz/model/user_model/user_model.dart';

class LinksModel {
  LinksModel({
    bool? status,
    String? message,
    List<Link>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  LinksModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Link.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Link>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<Link>? get data => _data;

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
