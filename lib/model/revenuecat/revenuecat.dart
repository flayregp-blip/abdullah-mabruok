class RevenueCatResponse {
  List<RevCatPurchase>? items;
  String? object;
  String? url;

  RevenueCatResponse({this.items, this.object, this.url});

  RevenueCatResponse.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <RevCatPurchase>[];
      json['items'].forEach((v) {
        items!.add(RevCatPurchase.fromJson(v));
      });
    }
    object = json['object'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['object'] = object;
    data['url'] = url;
    return data;
  }
}

class RevCatPurchase {
  String? country;
  String? customerId;
  String? environment;
  String? id;
  String? object;
  String? originalCustomerId;
  String? ownership;
  String? presentedOfferingId;
  String? productId;
  int? purchasedAt;
  int? quantity;
  RevenueInUsd? revenueInUsd;
  String? status;
  String? store;
  String? storePurchaseIdentifier;

  RevCatPurchase(
      {this.country,
      this.customerId,
      this.environment,
      this.id,
      this.object,
      this.originalCustomerId,
      this.ownership,
      this.presentedOfferingId,
      this.productId,
      this.purchasedAt,
      this.quantity,
      this.revenueInUsd,
      this.status,
      this.store,
      this.storePurchaseIdentifier});

  RevCatPurchase.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    customerId = json['customer_id'];
    environment = json['environment'];
    id = json['id'];
    object = json['object'];
    originalCustomerId = json['original_customer_id'];
    ownership = json['ownership'];
    presentedOfferingId = json['presented_offering_id'];
    productId = json['product_id'];
    purchasedAt = json['purchased_at'];
    quantity = json['quantity'];
    revenueInUsd = json['revenue_in_usd'] != null
        ? RevenueInUsd.fromJson(json['revenue_in_usd'])
        : null;
    status = json['status'];
    store = json['store'];
    storePurchaseIdentifier = json['store_purchase_identifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['customer_id'] = customerId;
    data['environment'] = environment;
    data['id'] = id;
    data['object'] = object;
    data['original_customer_id'] = originalCustomerId;
    data['ownership'] = ownership;
    data['presented_offering_id'] = presentedOfferingId;
    data['product_id'] = productId;
    data['purchased_at'] = purchasedAt;
    data['quantity'] = quantity;
    if (revenueInUsd != null) {
      data['revenue_in_usd'] = revenueInUsd!.toJson();
    }
    data['status'] = status;
    data['store'] = store;
    data['store_purchase_identifier'] = storePurchaseIdentifier;
    return data;
  }
}

class RevenueInUsd {
  double? commission;
  String? currency;
  double? gross;
  double? proceeds;
  double? tax;

  RevenueInUsd(
      {this.commission, this.currency, this.gross, this.proceeds, this.tax});

  RevenueInUsd.fromJson(Map<String, dynamic> json) {
    commission = json['commission'];
    currency = json['currency'];
    gross = json['gross'];
    proceeds = json['proceeds'];
    tax = json['tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commission'] = commission;
    data['currency'] = currency;
    data['gross'] = gross;
    data['proceeds'] = proceeds;
    data['tax'] = tax;
    return data;
  }
}
