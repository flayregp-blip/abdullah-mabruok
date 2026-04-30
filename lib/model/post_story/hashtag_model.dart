class HashtagModel {
  HashtagModel({
    bool? status,
    String? message,
    List<Hashtag>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  HashtagModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Hashtag.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Hashtag>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<Hashtag>? get data => _data;

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

class Hashtag {
  Hashtag({
    int? id,
    String? hashtag,
    num? postCount,
    num? onExplore,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _hashtag = hashtag;
    _postCount = postCount;
    _onExplore = onExplore;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Hashtag.fromJson(dynamic json) {
    _id = json['id'];
    _hashtag = json['hashtag'];
    _postCount = json['post_count'];
    _onExplore = json['on_explore'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  int? _id;
  String? _hashtag;
  num? _postCount;
  num? _onExplore;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  String? get hashtag => _hashtag;

  num? get postCount => _postCount;

  num? get onExplore => _onExplore;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['hashtag'] = _hashtag;
    map['post_count'] = _postCount;
    map['on_explore'] = _onExplore;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
