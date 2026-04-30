import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/post_story/story/story_model.dart';

class UserModel {
  UserModel({
    bool? status,
    String? message,
    User? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  UserModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? User.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  User? _data;

  bool? get status => _status;

  String? get message => _message;

  User? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class User {
  User(
      {this.id,
      this.identity,
      this.isDummy,
      this.fullname,
      this.username,
      this.userEmail,
      this.mobileCountryCode,
      this.userMobileNo,
      this.profilePhoto,
      this.loginMethod,
      this.device,
      this.deviceToken,
      this.notifyPostLike,
      this.notifyPostComment,
      this.notifyFollow,
      this.notifyMention,
      this.notifyGiftReceived,
      this.notifyChat,
      this.isVerify,
      this.whoCanViewPost,
      this.showMyFollowing,
      this.receiveMessage,
      this.coinWallet,
      this.coinCollectedLifetime,
      this.coinGiftedLifetime,
      this.coinPurchasedLifetime,
      this.bio,
      this.followerCount,
      this.followingCount,
      this.totalPostLikesCount,
      this.isFreez,
      this.country,
      this.countryCode,
      this.region,
      this.regionName,
      this.city,
      this.lat,
      this.lon,
      this.timezone,
      this.appLastUsedAt,
      this.savedMusicIds,
      this.isModerator,
      this.createdAt,
      this.updatedAt,
      this.isFollowing,
      this.followStatus,
      this.isBlock,
      this.links,
      this.stories,
      this.appLanguage,
      this.newRegister,
      this.followingIds});

  User copyWith({
    int? id,
    int? isDummy,
    String? identity,
    String? fullname,
    String? username,
    String? userEmail,
    int? mobileCountryCode,
    String? userMobileNo,
    String? profilePhoto,
    String? loginMethod,
    int? device,
    String? deviceToken,
    int? notifyPostLike,
    int? notifyPostComment,
    int? notifyFollow,
    int? notifyMention,
    int? notifyGiftReceived,
    int? notifyChat,
    int? isVerify,
    int? whoCanViewPost,
    int? showMyFollowing,
    int? receiveMessage,
    int? coinWallet,
    int? coinCollectedLifetime,
    int? coinGiftedLifetime,
    int? coinPurchasedLifetime,
    String? bio,
    int? followerCount,
    int? followingCount,
    int? totalPostLikesCount,
    int? isFreez,
    String? country,
    String? countryCode,
    dynamic region,
    dynamic regionName,
    dynamic city,
    double? lat,
    double? lon,
    String? timezone,
    dynamic appLastUsedAt,
    String? savedMusicIds,
    int? isModerator,
    String? appLanguage,
    dynamic password,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFollowing,
    int? followStatus,
    bool? isBlock,
    bool? newRegister,
    List<Link>? links,
    List<Story>? stories,
    List<int>? followingIds,
  }) =>
      User(
        id: id ?? this.id,
        isDummy: isDummy ?? this.isDummy,
        identity: identity ?? this.identity,
        fullname: fullname ?? this.fullname,
        username: username ?? this.username,
        userEmail: userEmail ?? this.userEmail,
        mobileCountryCode: mobileCountryCode ?? this.mobileCountryCode,
        userMobileNo: userMobileNo ?? this.userMobileNo,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        loginMethod: loginMethod ?? this.loginMethod,
        device: device ?? this.device,
        deviceToken: deviceToken ?? this.deviceToken,
        notifyPostLike: notifyPostLike ?? this.notifyPostLike,
        notifyPostComment: notifyPostComment ?? this.notifyPostComment,
        notifyFollow: notifyFollow ?? this.notifyFollow,
        notifyMention: notifyMention ?? this.notifyMention,
        notifyGiftReceived: notifyGiftReceived ?? this.notifyGiftReceived,
        notifyChat: notifyChat ?? this.notifyChat,
        isVerify: isVerify ?? this.isVerify,
        whoCanViewPost: whoCanViewPost ?? this.whoCanViewPost,
        showMyFollowing: showMyFollowing ?? this.showMyFollowing,
        receiveMessage: receiveMessage ?? this.receiveMessage,
        coinWallet: coinWallet ?? this.coinWallet,
        coinCollectedLifetime:
            coinCollectedLifetime ?? this.coinCollectedLifetime,
        coinGiftedLifetime: coinGiftedLifetime ?? this.coinGiftedLifetime,
        coinPurchasedLifetime:
            coinPurchasedLifetime ?? this.coinPurchasedLifetime,
        bio: bio ?? this.bio,
        followerCount: followerCount ?? this.followerCount,
        followingCount: followingCount ?? this.followingCount,
        totalPostLikesCount: totalPostLikesCount ?? this.totalPostLikesCount,
        isFreez: isFreez ?? this.isFreez,
        country: country ?? this.country,
        countryCode: countryCode ?? this.countryCode,
        region: region ?? this.region,
        regionName: regionName ?? this.regionName,
        city: city ?? this.city,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        timezone: timezone ?? this.timezone,
        appLastUsedAt: appLastUsedAt ?? this.appLastUsedAt,
        savedMusicIds: savedMusicIds ?? this.savedMusicIds,
        isModerator: isModerator ?? this.isModerator,
        appLanguage: appLanguage ?? this.appLanguage,
        isFollowing: isFollowing ?? this.isFollowing,
        followStatus: followStatus ?? this.followStatus,
        isBlock: isBlock ?? this.isBlock,
        links: links ?? this.links,
        stories: stories ?? this.stories,
        newRegister: newRegister ?? this.newRegister,
        followingIds: followingIds ?? this.followingIds,
      );

  User.fromJson(dynamic json) {
    id = json['id'];
    identity = json['identity'];
    isDummy = json['is_dummy'];
    fullname = json['fullname'];
    username = json['username'];
    userEmail = json['user_email'];
    mobileCountryCode = json['mobile_country_code'];
    userMobileNo = json['user_mobile_no'];
    profilePhoto = json['profile_photo'];
    loginMethod = json['login_method'];
    device = json['device'];
    deviceToken = json['device_token'];
    notifyPostLike = json['notify_post_like'];
    notifyPostComment = json['notify_post_comment'];
    notifyFollow = json['notify_follow'];
    notifyMention = json['notify_mention'];
    notifyGiftReceived = json['notify_gift_received'];
    notifyChat = json['notify_chat'];
    isVerify = json['is_verify'];
    whoCanViewPost = json['who_can_view_post'];
    showMyFollowing = json['show_my_following'];
    receiveMessage = json['receive_message'];
    coinWallet = json['coin_wallet'];
    coinCollectedLifetime = json['coin_collected_lifetime'];
    coinGiftedLifetime = json['coin_gifted_lifetime'];
    coinPurchasedLifetime = json['coin_purchased_lifetime'];
    bio = json['bio'];
    followerCount = json['follower_count'];
    followingCount = json['following_count'];
    totalPostLikesCount = json['total_post_likes_count'];
    isFreez = json['is_freez'];
    country = json['country'];
    countryCode = json['countryCode'];
    region = json['region'];
    regionName = json['regionName'];
    city = json['city'];
    lat = json['lat'];
    lon = json['lon'];
    timezone = json['timezone'];
    appLastUsedAt = json['app_last_used_at'];
    savedMusicIds = json['saved_music_ids'];
    isModerator = json['is_moderator'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isFollowing = json['is_following'];
    followStatus = json['follow_status'];
    isBlock = json['is_block'];
    appLanguage = json['app_language'];
    newRegister = json['new_register'];
    token = json['token'] != null ? Token.fromJson(json['token']) : null;
    followingIds = json["following_ids"] != null
        ? List<int>.from(json["following_ids"].map((x) => x))
        : null;
    if (json['links'] != null) {
      links = [];
      json['links'].forEach((v) {
        links?.add(Link.fromJson(v));
      });
    }
    if (json['stories'] != null) {
      stories = [];
      json['stories'].forEach((v) {
        var s = Story.fromJson(v);
        s.user = this;
        stories?.add(s);
      });
    }
  }

  int? id;
  String? identity;
  int? isDummy;
  String? fullname;
  String? username;
  String? userEmail;
  int? mobileCountryCode;
  String? userMobileNo;
  String? profilePhoto;
  String? loginMethod;
  int? device;
  String? deviceToken;
  num? notifyPostLike;
  num? notifyPostComment;
  num? notifyFollow;
  num? notifyMention;
  num? notifyGiftReceived;
  num? notifyChat;
  int? isVerify;
  num? whoCanViewPost;
  num? showMyFollowing;
  num? receiveMessage;
  num? coinWallet;
  num? coinCollectedLifetime;
  num? coinGiftedLifetime;
  num? coinPurchasedLifetime;
  String? bio;
  num? followerCount;
  num? followingCount;
  int? totalPostLikesCount;
  num? isFreez;
  String? country;
  String? countryCode;
  String? region;
  String? regionName;
  String? city;
  num? lat;
  num? lon;
  String? timezone;
  String? appLastUsedAt;
  String? savedMusicIds;
  int? isModerator;
  String? createdAt;
  String? updatedAt;
  String? appLanguage;
  bool? isFollowing;
  int? followStatus;
  bool? isBlock;
  bool? newRegister;
  Token? token;
  List<Link>? links;
  List<int>? followingIds;
  List<Story>? stories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['is_dummy'] = isDummy;
    map['identity'] = identity;
    map['fullname'] = fullname;
    map['username'] = username;
    map['user_email'] = userEmail;
    map['mobile_country_code'] = mobileCountryCode;
    map['user_mobile_no'] = userMobileNo;
    map['profile_photo'] = profilePhoto;
    map['login_method'] = loginMethod;
    map['device'] = device;
    map['device_token'] = deviceToken;
    map['notify_post_like'] = notifyPostLike;
    map['notify_post_comment'] = notifyPostComment;
    map['notify_follow'] = notifyFollow;
    map['notify_mention'] = notifyMention;
    map['notify_gift_received'] = notifyGiftReceived;
    map['notify_chat'] = notifyChat;
    map['is_verify'] = isVerify;
    map['who_can_view_post'] = whoCanViewPost;
    map['show_my_following'] = showMyFollowing;
    map['receive_message'] = receiveMessage;
    map['coin_wallet'] = coinWallet;
    map['coin_collected_lifetime'] = coinCollectedLifetime;
    map['coin_gifted_lifetime'] = coinGiftedLifetime;
    map['coin_purchased_lifetime'] = coinPurchasedLifetime;
    map['bio'] = bio;
    map['follower_count'] = followerCount;
    map['following_count'] = followingCount;
    map['total_post_likes_count'] = totalPostLikesCount;
    map['is_freez'] = isFreez;
    map['country'] = country;
    map['countryCode'] = countryCode;
    map['region'] = region;
    map['regionName'] = regionName;
    map['city'] = city;
    map['lat'] = lat;
    map['lon'] = lon;
    map['timezone'] = timezone;
    map['app_last_used_at'] = appLastUsedAt;
    map['saved_music_ids'] = savedMusicIds;
    map['is_moderator'] = isModerator;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_following'] = isFollowing;
    map['follow_status'] = followStatus;
    map['is_block'] = isBlock;
    map['new_register'] = newRegister;
    map['app_language'] = appLanguage;
    map["following_ids"] = followingIds;
    if (token != null) {
      map['token'] = token?.toJson();
    }
    if (links != null) {
      map['links'] = links?.map((v) => v.toJson()).toList();
    }
    if (stories != null) {
      map['stories'] = stories?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  void checkIsBlocked(Function completion) {
    if (isBlock == false || id == SessionManager.instance.getUserID()) {
      completion();
    }
  }

  void updateFollowerCount(bool isFollowing) {
    int i = isFollowing ? 1 : -1;
    followerCount = ((followerCount ?? 0) + i)
        .clamp(0, double.infinity)
        .toInt(); // followerCount not less then 0
  }

  void updateBlockStatus(bool isBlock) {
    this.isBlock = isBlock;
  }

  double coinEstimatedValue(double? coinValue) {
    return (coinWallet?.toInt() ?? 0) * (coinValue ?? 0);
  }

  num removeCoinFromWallet(num amount) {
    return coinWallet = (coinWallet ?? 0) - amount;
  }

  UserLevel get getLevel {
    return (coinCollectedLifetime ?? 0).getUserLevelByTotalCoins;
  }
}

class Link {
  Link({
    this.id,
    this.userId,
    this.title,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  Link.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  num? id;
  num? userId;
  String? title;
  String? url;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['title'] = title;
    map['url'] = url;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}

class Token {
  Token({
    this.userId,
    this.authToken,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  Token.fromJson(dynamic json) {
    userId = json['user_id'];
    authToken = json['auth_token'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  num? userId;
  String? authToken;
  String? updatedAt;
  String? createdAt;
  num? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['auth_token'] = authToken;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['id'] = id;
    return map;
  }
}
