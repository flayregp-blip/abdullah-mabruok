class TextModerationModel {
  TextModerationModel({
    this.status,
    this.request,
    this.error,
    this.profanity,
  });

  TextModerationModel.fromJson(dynamic json) {
    status = json['status'];
    request = json['request'] != null ? Request.fromJson(json['request']) : null;
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
    profanity = json['profanity'] != null ? Profanity.fromJson(json['profanity']) : null;
  }

  String? status;
  Request? request;
  Error? error;
  Profanity? profanity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (request != null) {
      map['request'] = request?.toJson();
    }
    if (error != null) {
      map['error'] = error?.toJson();
    }
    if (profanity != null) {
      map['profanity'] = profanity?.toJson();
    }
    return map;
  }
}

class Profanity {
  Profanity({
    this.matches,
  });

  Profanity.fromJson(dynamic json) {
    if (json['matches'] != null) {
      matches = [];
      json['matches'].forEach((v) {
        matches?.add(Matches.fromJson(v));
      });
    }
  }

  List<Matches>? matches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (matches != null) {
      map['matches'] = matches?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Matches {
  Matches({
    this.type,
    this.intensity,
    this.match,
    this.start,
    this.end,
  });

  Matches.fromJson(dynamic json) {
    type = json['type'];
    intensity = json['intensity'];
    match = json['match'];
    start = json['start'];
    end = json['end'];
  }

  String? type;
  String? intensity;
  String? match;
  num? start;
  num? end;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['intensity'] = intensity;
    map['match'] = match;
    map['start'] = start;
    map['end'] = end;
    return map;
  }
}

class Error {
  Error({
    this.type,
    this.code,
    this.message,
  });

  Error.fromJson(dynamic json) {
    type = json['type'];
    code = json['code'];
    message = json['message'];
  }

  String? type;
  num? code;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['code'] = code;
    map['message'] = message;
    return map;
  }
}

class Request {
  Request({
    this.id,
    this.timestamp,
    this.operations,
  });

  Request.fromJson(dynamic json) {
    id = json['id'];
    timestamp = json['timestamp'];
    operations = json['operations'];
  }

  String? id;
  num? timestamp;
  num? operations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['timestamp'] = timestamp;
    map['operations'] = operations;
    return map;
  }
}
