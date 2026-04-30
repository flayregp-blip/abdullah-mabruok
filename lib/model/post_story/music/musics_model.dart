import 'package:shortzz/model/post_story/music/music_model.dart';

class MusicsModel {
  MusicsModel({
    this.status,
    this.message,
    this.data,
  });

  MusicsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Music.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<Music>? data;

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
