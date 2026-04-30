import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/utilities/app_res.dart';

class SessionManager {
  static var instance = SessionManager();
  var storage = GetStorage('shortzz');
  var conversationId = '';
  RxInt notifyCount = 0.obs;
  RxInt isModerator = 0.obs;

  SessionManager() {
    listenNotifyCount();
    listenModerator();
    listenSubscription();
  }

  void setAuthToken(Token? token) {
    storage.write(SessionKeys.authToken, token);
  }

  String getAuthToken() {
    return getToken()?.authToken ?? 'AUTH TOKEN EMPTY';
  }

  void setPassword(String? password) {
    storage.write(SessionKeys.password, password);
  }

  String? getPassword() {
    return storage.read(SessionKeys.password);
  }

  Token? getToken() {
    var token = storage.read(SessionKeys.authToken);
    if (token is Token?) {
      return token;
    } else {
      return Token.fromJson(token);
    }
  }

  void setNotifyCount(int count) {
    int oldCount = getNotifyCount;
    oldCount += count;
    storage.write(SessionKeys.notifyCount, oldCount);
  }

  int get getNotifyCount {
    return storage.read(SessionKeys.notifyCount) ?? 0;
  }

  void listenNotifyCount() {
    notifyCount.value = getNotifyCount;
    storage.listenKey(SessionKeys.notifyCount, (value) {
      notifyCount.value = value;
    });
  }

  void listenModerator() {
    isModerator.value = getUser()?.isModerator ?? 0;
    storage.listenKey(SessionKeys.user, (value) {
      User? user = value as User?;
      isModerator.value = user?.isModerator ?? 0;
    });
  }

  void listenSubscription() {
    isModerator.value = getUser()?.isVerify ?? 0;
    storage.listenKey(SessionKeys.user, (value) {
      User? user = value as User?;
      isModerator.value = user?.isModerator ?? 0;
    });
  }

  void setUser(User? user) {
    if (user != null) {
      // Convert the object to a JSON map and set 'stories' to null
      Map<String, dynamic> json = user.toJson();
      json['stories'] = null;

      // Re-create the User object from the modified JSON map
      User newUser = User.fromJson(json);

      // Log the updated user object and store it
      // Loggers.success(user.toJson());
      storage.write(SessionKeys.user, newUser);
    }
  }

  User? getUser() {
    var user = storage.read(SessionKeys.user);

    if (user == null || user is User?) {
      return user;
    } else if (user is Map<String, dynamic>) {
      return User.fromJson(user);
    } else {
      return null;
    }
  }

  int getUserID() {
    return (getUser()?.id ?? 0).toInt();
  }

  String getCurrency() {
    return getSettings()?.currency ?? AppRes.currency;
  }

  void setSettings(Setting settings) {
    storage.write(SessionKeys.setting, settings.toJson());
  }

  Setting? getSettings() {
    var data = storage.read(SessionKeys.setting);
    if (data is Map<String, dynamic>) {
      return Setting.fromJson(data);
    } else if (data is Setting) {
      return data;
    }
    return null;
  }

  void setLang(String langCode) {
    storage.write(SessionKeys.lang, langCode);
    UserService.instance.updateUserDetails(appLanguage: langCode);
  }

  String getLang() {
    return storage.read(SessionKeys.lang) ?? getFallbackLang();
  }

  void setFallbackLang(String langCode) {
    storage.write(SessionKeys.fallbackLang, langCode);
  }

  String getFallbackLang() {
    return storage.read(SessionKeys.fallbackLang) ?? 'en';
  }

  DateTime? getLastMessageReadDate({required String spaceId}) {
    var date = storage.read(spaceId);
    if (date is DateTime) {
      return date;
    } else {
      return null;
    }
  }

  void setLastMessageReadDate({required String spaceId}) {
    storage.write(spaceId, DateTime.now());
  }

  bool isLogin() {
    return storage.read(SessionKeys.isLogin) ?? false;
  }

  void setLogin(bool isLog) {
    storage.write(SessionKeys.isLogin, true);
  }

  bool get shouldOpenEULASheet {
    return storage.read(SessionKeys.shouldOpenEULA) ?? true;
  }

  Future<void> setOpenEulaSheet(bool isLog) async {
    await storage.write(SessionKeys.shouldOpenEULA, isLog);
  }

  Future<void> setBool(String key, bool value) async {
    await storage.write(key, value);
  }

  bool getBool(String key) {
    return storage.read(key) ?? false;
  }

  void clear() {
    storage.erase();
  }

  void clearSomeKey() {
    storage.remove(SessionKeys.isLogin);
    storage.remove(SessionKeys.user);
    storage.remove(SessionKeys.authToken);
    storage.remove(SessionKeys.password);
    storage.remove(SessionKeys.notifyCount);
    storage.remove(SessionKeys.fallbackLang);
    storage.remove(SessionKeys.lang);
  }
}

class SessionKeys {
  static const isLogin = "login";
  static const shouldOpenEULA = "should_open_eula";
  static const fallbackLang = "fallback_lang";
  static const lang = "lang";
  static const setting = "setting";
  static const user = "user";
  static const authToken = "authToken";
  static const password = "password";
  static const notifyCount = "notify_count";
  static const isLanguageScreenSelect = "is_language_screen_select";
  static const isOnBoardingScreenSelect = "is_on_boarding_screen_select";
}
