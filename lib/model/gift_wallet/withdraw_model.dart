class WithdrawModel {
  WithdrawModel({
    this.status,
    this.message,
    this.data,
  });

  WithdrawModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Withdraw.fromJson(v));
      });
    }
  }

  bool? status;
  String? message;
  List<Withdraw>? data;

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

class Withdraw {
  Withdraw({
    this.id,
    this.userId,
    this.requestNumber,
    this.gateway,
    this.account,
    this.amount,
    this.coins,
    this.coinValue,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Withdraw.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    requestNumber = json['request_number'];
    gateway = json['gateway'];
    account = json['account'];
    amount = json['amount'];
    coins = json['coins'];
    coinValue = json['coin_value'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  num? id;
  num? userId;
  String? requestNumber;
  String? gateway;
  String? account;
  String? amount;
  num? coins;
  num? coinValue;
  num? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['request_number'] = requestNumber;
    map['gateway'] = gateway;
    map['account'] = account;
    map['amount'] = amount;
    map['coins'] = coins;
    map['coin_value'] = coinValue;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
