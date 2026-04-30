// To parse this JSON data, do
//
//     final settingModel = settingModelFromJson(jsonString);

import 'dart:convert';

import 'package:shortzz/model/user_model/user_model.dart';

SettingModel settingModelFromJson(String str) =>
    SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
  bool? status;
  String? message;
  Setting? data;

  SettingModel({
    this.status,
    this.message,
    this.data,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Setting.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Setting {
  int? id;
  String? appName;
  String? currency;
  double? coinValue;
  int? minRedeemCoins;
  int? registrationBonusStatus;
  int? registrationBonusAmount;
  int? minFollowersForLive;
  String? admobBanner;
  String? admobInt;
  String? admobBannerIos;
  String? admobIntIos;
  int? admobAndroidStatus;
  int? admobIosStatus;
  int? maxUploadDaily;
  int? maxStoryDaily;
  int? maxCommentDaily;
  int? maxCommentReplyDaily;
  int? maxPostPins;
  int? maxCommentPins;
  int? maxImagesPerPost;
  int? maxUserLinks;
  int? liveMinViewers;
  int? liveTimeout;
  int? liveBattle;
  int? liveDummyShow;
  String? zegoAppId;
  String? zegoAppSign;
  int? isCompress;
  int? isDeepAr;
  int? isWithdrawalOn;
  String? helpMail;
  int? isContentModeration;
  String? sightEngineApiUser;
  String? sightEngineApiSecret;
  String? sightEngineImageWorkflowId;
  String? sightEngineVideoWorkflowId;
  int? gifSupport;
  String? giphyKey;
  int? watermarkStatus;
  String? watermarkImage;
  String? privacyPolicy;
  String? termsOfUses;
  String? placeApiAccessToken;
  String? deeparAndroidKey;
  String? deeparIOSKey;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? itemBaseUrl;
  List<Language>? languages;
  List<OnBoarding>? onBoarding;
  List<CoinPackage>? coinPackages;
  List<RedeemGateway>? redeemGateways;
  List<Gift>? gifts;
  List<MusicCategory>? musicCategories;
  List<UserLevel>? userLevels;
  List<DummyLive>? dummyLives;
  List<ReportReason>? reportReason;
  List<DeepARFilters>? deepARFilters;

  Setting({
    this.id,
    this.appName,
    this.currency,
    this.coinValue,
    this.minRedeemCoins,
    this.minFollowersForLive,
    this.registrationBonusStatus,
    this.registrationBonusAmount,
    this.admobBanner,
    this.admobInt,
    this.admobBannerIos,
    this.admobIntIos,
    this.admobAndroidStatus,
    this.admobIosStatus,
    this.maxUploadDaily,
    this.maxStoryDaily,
    this.maxCommentDaily,
    this.maxCommentReplyDaily,
    this.maxPostPins,
    this.maxCommentPins,
    this.maxImagesPerPost,
    this.maxUserLinks,
    this.liveMinViewers,
    this.liveTimeout,
    this.liveBattle,
    this.liveDummyShow,
    this.zegoAppId,
    this.zegoAppSign,
    this.isCompress,
    this.isDeepAr,
    this.isWithdrawalOn,
    this.helpMail,
    this.isContentModeration,
    this.sightEngineApiUser,
    this.sightEngineApiSecret,
    this.sightEngineImageWorkflowId,
    this.sightEngineVideoWorkflowId,
    this.gifSupport,
    this.giphyKey,
    this.watermarkStatus,
    this.watermarkImage,
    this.privacyPolicy,
    this.termsOfUses,
    this.placeApiAccessToken,
    this.deeparAndroidKey,
    this.deeparIOSKey,
    this.createdAt,
    this.updatedAt,
    this.itemBaseUrl,
    this.languages,
    this.onBoarding,
    this.coinPackages,
    this.redeemGateways,
    this.gifts,
    this.musicCategories,
    this.userLevels,
    this.dummyLives,
    this.reportReason,
    this.deepARFilters,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        id: json["id"],
        appName: json["app_name"],
        currency: json["currency"],
        registrationBonusStatus: json["registration_bonus_status"],
        registrationBonusAmount: json["registration_bonus_amount"],
        coinValue: json["coin_value"]?.toDouble(),
        minRedeemCoins: json["min_redeem_coins"],
        minFollowersForLive: json["min_followers_for_live"],
        admobBanner: json["admob_banner"],
        admobInt: json["admob_int"],
        admobBannerIos: json["admob_banner_ios"],
        admobIntIos: json["admob_int_ios"],
        admobAndroidStatus: json["admob_android_status"],
        admobIosStatus: json["admob_ios_status"],
        maxUploadDaily: json["max_upload_daily"],
        maxStoryDaily: json["max_story_daily"],
        maxCommentDaily: json["max_comment_daily"],
        maxCommentReplyDaily: json["max_comment_reply_daily"],
        maxPostPins: json["max_post_pins"],
        maxCommentPins: json["max_comment_pins"],
        maxImagesPerPost: json["max_images_per_post"],
        maxUserLinks: json["max_user_links"],
        liveMinViewers: json["live_min_viewers"],
        liveTimeout: json["live_timeout"],
        liveBattle: json["live_battle"],
        liveDummyShow: json["live_dummy_show"],
        zegoAppId: json["zego_app_id"],
        zegoAppSign: json["zego_app_sign"],
        isCompress: json["is_compress"],
        isDeepAr: json["is_deepAR"],
        isWithdrawalOn: json["is_withdrawal_on"],
        helpMail: json["help_mail"],
        isContentModeration: json["is_content_moderation"],
        sightEngineApiUser: json["sight_engine_api_user"],
        sightEngineApiSecret: json["sight_engine_api_secret"],
        sightEngineImageWorkflowId: json["sight_engine_image_workflow_id"],
        sightEngineVideoWorkflowId: json["sight_engine_video_workflow_id"],
        gifSupport: json["gif_support"],
        giphyKey: json["giphy_key"],
        watermarkStatus: json["watermark_status"],
        watermarkImage: json["watermark_image"],
        privacyPolicy: json["privacy_policy"],
        termsOfUses: json["terms_of_uses"],
        placeApiAccessToken: json["place_api_access_token"],
        itemBaseUrl: json["itemBaseUrl"],
        deeparAndroidKey: json["deepar_android_key"],
        deeparIOSKey: json["deepar_iOS_key"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        languages: json["languages"] == null
            ? []
            : List<Language>.from(
                json["languages"]?.map((x) => Language.fromJson(x))),
        onBoarding: json["onBoarding"] == null
            ? []
            : List<OnBoarding>.from(
                json["onBoarding"]?.map((x) => OnBoarding.fromJson(x))),
        coinPackages: json["coinPackages"] == null
            ? []
            : List<CoinPackage>.from(
                json["coinPackages"]?.map((x) => CoinPackage.fromJson(x))),
        redeemGateways: json["redeemGateways"] == null
            ? []
            : List<RedeemGateway>.from(
                json["redeemGateways"]?.map((x) => RedeemGateway.fromJson(x))),
        gifts: json["gifts"] == null
            ? []
            : List<Gift>.from(json["gifts"]?.map((x) => Gift.fromJson(x))),
        musicCategories: json["musicCategories"] == null
            ? []
            : List<MusicCategory>.from(
                json["musicCategories"]?.map((x) => MusicCategory.fromJson(x))),
        userLevels: json["userLevels"] == null
            ? []
            : List<UserLevel>.from(
                json["userLevels"]?.map((x) => UserLevel.fromJson(x))),
        dummyLives: json["dummyLives"] == null
            ? []
            : List<DummyLive>.from(
                json["dummyLives"]?.map((x) => DummyLive.fromJson(x))),
        reportReason: json["reportReasons"] == null
            ? []
            : List<ReportReason>.from(
                json["reportReasons"]?.map((x) => ReportReason.fromJson(x))),
        deepARFilters: json["deepARFilters"] == null
            ? []
            : List<DeepARFilters>.from(
                json["deepARFilters"]?.map((x) => DeepARFilters.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_name": appName,
        "currency": currency,
        "registration_bonus_status": registrationBonusStatus,
        "registration_bonus_amount": registrationBonusAmount,
        "coin_value": coinValue,
        "min_redeem_coins": minRedeemCoins,
        "min_followers_for_live": minFollowersForLive,
        "admob_banner": admobBanner,
        "admob_int": admobInt,
        "admob_banner_ios": admobBannerIos,
        "admob_int_ios": admobIntIos,
        "admob_android_status": admobAndroidStatus,
        "admob_ios_status": admobIosStatus,
        "max_upload_daily": maxUploadDaily,
        "max_story_daily": maxStoryDaily,
        "max_comment_daily": maxCommentDaily,
        "max_comment_reply_daily": maxCommentReplyDaily,
        "max_post_pins": maxPostPins,
        "max_comment_pins": maxCommentPins,
        "max_images_per_post": maxImagesPerPost,
        "max_user_links": maxUserLinks,
        "live_min_viewers": liveMinViewers,
        "live_timeout": liveTimeout,
        "live_battle": liveBattle,
        "live_dummy_show": liveDummyShow,
        "zego_app_id": zegoAppId,
        "zego_app_sign": zegoAppSign,
        "is_compress": isCompress,
        "is_deepAR": isDeepAr,
        "is_withdrawal_on": isWithdrawalOn,
        "help_mail": helpMail,
        "is_content_moderation": isContentModeration,
        "sight_engine_api_user": sightEngineApiUser,
        "sight_engine_api_secret": sightEngineApiSecret,
        "sight_engine_image_workflow_id": sightEngineImageWorkflowId,
        "sight_engine_video_workflow_id": sightEngineVideoWorkflowId,
        "gif_support": gifSupport,
        "giphy_key": giphyKey,
        "watermark_status": watermarkStatus,
        "watermark_image": watermarkImage,
        "privacy_policy": privacyPolicy,
        "terms_of_uses": termsOfUses,
        "place_api_access_token": placeApiAccessToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "itemBaseUrl": itemBaseUrl,
        "deepar_android_key": deeparAndroidKey,
        "deepar_iOS_key": deeparIOSKey,
        "languages": languages == null
            ? []
            : List<dynamic>.from(languages!.map((x) => x.toJson())),
        "onBoarding": onBoarding == null
            ? []
            : List<dynamic>.from(onBoarding!.map((x) => x.toJson())),
        "coinPackages": coinPackages == null
            ? []
            : List<dynamic>.from(coinPackages!.map((x) => x.toJson())),
        "redeemGateways": redeemGateways == null
            ? []
            : List<dynamic>.from(redeemGateways!.map((x) => x.toJson())),
        "gifts": gifts == null
            ? []
            : List<dynamic>.from(gifts!.map((x) => x.toJson())),
        "musicCategories": musicCategories == null
            ? []
            : List<dynamic>.from(musicCategories!.map((x) => x.toJson())),
        "userLevels": userLevels == null
            ? []
            : List<dynamic>.from(userLevels!.map((x) => x.toJson())),
        "dummyLives": dummyLives == null
            ? []
            : List<dynamic>.from(dummyLives!.map((x) => x.toJson())),
        "reportReasons": reportReason == null
            ? []
            : List<dynamic>.from(reportReason!.map((x) => x.toJson())),
        "deepARFilters": deepARFilters == null
            ? []
            : List<dynamic>.from(deepARFilters!.map((x) => x.toJson())),
      };
}

class CoinPackage {
  int? id;
  String? image;
  int? status;
  int? coinAmount;
  int? coinPlanPrice;
  String? playStoreProductId;
  String? appstoreProductId;
  DateTime? createdAt;
  DateTime? updatedAt;

  CoinPackage({
    this.id,
    this.image,
    this.status,
    this.coinAmount,
    this.coinPlanPrice,
    this.playStoreProductId,
    this.appstoreProductId,
    this.createdAt,
    this.updatedAt,
  });

  factory CoinPackage.fromJson(Map<String, dynamic> json) => CoinPackage(
        id: json["id"],
        image: json["image"],
        status: json["status"],
        coinAmount: json["coin_amount"],
        coinPlanPrice: json["coin_plan_price"],
        playStoreProductId: json["playstore_product_id"],
        appstoreProductId: json["appstore_product_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "status": status,
        "coin_amount": coinAmount,
        "coin_plan_price": coinPlanPrice,
        "playstore_product_id": playStoreProductId,
        "appstore_product_id": appstoreProductId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class DummyLive {
  int? id;
  int? status;
  String? title;
  int? userId;
  String? link;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  DummyLive({
    this.id,
    this.status,
    this.title,
    this.userId,
    this.link,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory DummyLive.fromJson(Map<String, dynamic> json) => DummyLive(
        id: json["id"],
        status: json["status"],
        title: json["title"],
        userId: json["user_id"],
        link: json["link"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "title": title,
        "user_id": userId,
        "link": link,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class Gift {
  int? id;
  int? coinPrice;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  Gift({
    this.id,
    this.coinPrice,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
        id: json["id"],
        coinPrice: json["coin_price"],
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coin_price": coinPrice,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Language {
  int? id;
  String? code;
  String? title;
  String? localizedTitle;
  String? csvFile;
  int? status;
  int? isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;

  Language({
    this.id,
    this.code,
    this.title,
    this.localizedTitle,
    this.csvFile,
    this.status,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["id"],
        code: json["code"],
        title: json["title"],
        localizedTitle: json["localized_title"],
        csvFile: json["csv_file"],
        status: json["status"],
        isDefault: json["is_default"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "title": title,
        "localized_title": localizedTitle,
        "csv_file": csvFile,
        "status": status,
        "is_default": isDefault,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class MusicCategory {
  int? id;
  String? name;
  String? image;
  int? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? musicsCount;

  MusicCategory({
    this.id,
    this.name,
    this.image,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.musicsCount,
  });

  factory MusicCategory.fromJson(Map<String, dynamic> json) => MusicCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        musicsCount: json["musics_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "musics_count": musicsCount,
      };
}

class OnBoarding {
  int? id;
  int? position;
  String? image;
  String? title;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  OnBoarding({
    this.id,
    this.position,
    this.image,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory OnBoarding.fromJson(Map<String, dynamic> json) => OnBoarding(
        id: json["id"],
        position: json["position"],
        image: json["image"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
        "image": image,
        "title": title,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class RedeemGateway {
  int? id;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;

  RedeemGateway({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory RedeemGateway.fromJson(Map<String, dynamic> json) => RedeemGateway(
        id: json["id"],
        title: json["title"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class UserLevel {
  int? id;
  int? level;
  int coinsCollection;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserLevel({
    this.id,
    this.level,
    this.coinsCollection = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory UserLevel.fromJson(Map<String, dynamic> json) => UserLevel(
        id: json["id"],
        level: json["level"],
        coinsCollection: json["coins_collection"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "level": level,
        "coins_collection": coinsCollection,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class ReportReason {
  int? id;
  String? title;
  String? createdAt;
  String? updatedAt;

  ReportReason({this.id, this.title, this.createdAt, this.updatedAt});

  ReportReason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class DeepARFilters {
  DeepARFilters({
    this.id,
    this.title,
    this.image,
    this.filterFile,
    this.createdAt,
    this.updatedAt,
  });

  DeepARFilters.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    filterFile = json['filter_file'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  int? id;
  String? title;
  String? image;
  String? filterFile;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['image'] = image;
    map['filter_file'] = filterFile;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
