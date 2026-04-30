// To parse this JSON data, do
//
//     final placeDetail = placeDetailFromJson(jsonString);

import 'dart:convert';

PlaceDetail placeDetailFromJson(String str) =>
    PlaceDetail.fromJson(json.decode(str));

String placeDetailToJson(PlaceDetail data) => json.encode(data.toJson());

class PlaceDetail {
  String? status;
  String? country;
  String? countryCode;
  String? region;
  String? regionName;
  String? city;
  String? zip;
  double? lat;
  double? lon;
  String? timezone;
  String? isp;
  String? org;
  String? placeDetailAs;
  String? query;

  PlaceDetail({
    this.status,
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.city,
    this.zip,
    this.lat,
    this.lon,
    this.timezone,
    this.isp,
    this.org,
    this.placeDetailAs,
    this.query,
  });

  factory PlaceDetail.fromJson(Map<String, dynamic> json) => PlaceDetail(
        status: json["status"],
        country: json["country"],
        countryCode: json["countryCode"],
        region: json["region"],
        regionName: json["regionName"],
        city: json["city"],
        zip: json["zip"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        timezone: json["timezone"],
        isp: json["isp"],
        org: json["org"],
        placeDetailAs: json["as"],
        query: json["query"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "country": country,
        "countryCode": countryCode,
        "region": region,
        "regionName": regionName,
        "city": city,
        "zip": zip,
        "lat": lat,
        "lon": lon,
        "timezone": timezone,
        "isp": isp,
        "org": org,
        "as": placeDetailAs,
        "query": query,
      };
}
