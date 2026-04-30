class SightEngineMediaModel {
  SightEngineMediaModel({
    this.status,
    this.request,
    this.summary,
    this.workflow,
    this.error,
  });

  SightEngineMediaModel.fromJson(dynamic json) {
    status = json['status'];
    request = json['request'] != null ? Request.fromJson(json['request']) : null;
    summary = json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    workflow = json['workflow'] != null ? Workflow.fromJson(json['workflow']) : null;
    error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }

  String? status;
  Request? request;
  Summary? summary;
  Workflow? workflow;
  Error? error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (request != null) {
      map['request'] = request?.toJson();
    }
    if (summary != null) {
      map['summary'] = summary?.toJson();
    }
    if (workflow != null) {
      map['workflow'] = workflow?.toJson();
    }
    if (error != null) {
      map['error'] = error?.toJson();
    }
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

class Workflow {
  Workflow({
    this.id,
  });

  Workflow.fromJson(dynamic json) {
    id = json['id'];
  }

  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }
}

class Summary {
  Summary({
    this.action,
    this.rejectProb,
    this.rejectReason,
  });

  Summary.fromJson(dynamic json) {
    action = json['action'];
    rejectProb = json['reject_prob'];
    if (json['reject_reason'] != null) {
      rejectReason = [];
      json['reject_reason'].forEach((v) {
        rejectReason?.add(RejectReason.fromJson(v));
      });
    }
  }

  String? action;
  num? rejectProb;
  List<RejectReason>? rejectReason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['action'] = action;
    map['reject_prob'] = rejectProb;
    if (rejectReason != null) {
      map['reject_reason'] = rejectReason?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RejectReason {
  RejectReason({
    this.id,
    this.text,
  });

  RejectReason.fromJson(dynamic json) {
    id = json['id'];
    text = json['text'];
  }

  String? id;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['text'] = text;
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
