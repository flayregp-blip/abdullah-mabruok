class AppUser {
  int? userId;
  String? username;
  String? fullname;
  String? profile;
  int? isVerify;
  String? identity;

  AppUser(
      {this.userId,
      this.username,
      this.fullname,
      this.profile,
      this.isVerify,
      this.identity});

  AppUser.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    identity = json['identity'];
    username = json['username'];
    fullname = json['fullname'];
    profile = json['profile'];
    isVerify = json['is_verify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['identity'] = identity;
    data['username'] = username;
    data['fullname'] = fullname;
    data['profile'] = profile;
    data['is_verify'] = isVerify;
    return data;
  }
}


