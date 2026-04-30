import 'dart:io';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';

extension Number on num {
  String get numberFormat => NumberFormat.compact().format(this);

  String get currencyFormat =>
      '${SessionManager.instance.getCurrency()}${NumberFormat.compact().format(this)}';

  int get convertInt => toInt();

  UserLevel get getUserLevelByTotalCoins {
    List<UserLevel> userLevels =
        SessionManager.instance.getSettings()?.userLevels ?? [];
    if (userLevels.isEmpty) {
      return UserLevel();
    }
    userLevels.sort((a, b) => (b.coinsCollection).compareTo(a.coinsCollection));
    for (var level in userLevels) {
      if (this >= (level.coinsCollection)) {
        return level;
      }
    }
    return userLevels.last;
  }

  String get elapsedTimeFromEpoch {
    String time = '';
    final joinTime = DateTime.fromMillisecondsSinceEpoch(toInt());
    final currentTime = DateTime.now();

    final duration = currentTime.difference(joinTime);
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60);
    final seconds = (duration.inSeconds % 60);
    print('$hours $minutes $seconds');
    if (hours > 0) {
      time = '${hours}h ';
    }
    if (minutes > 0) {
      time += '${minutes}m ';
    }
    if (seconds > 0) {
      time += '${seconds}s';
    }

    return time;
  }
}

extension FormatLatLng on LatLng {
  String get getDistance {
    User? user = SessionManager.instance.getUser();
    if (user == null) return "0.0"; // Handle null user case

    const double p = 0.017453292519943295; // π / 180
    const double radiusOfEarth = 6371; // Earth's radius in km

    double lat1 = (user.lat ?? 0) * p;
    double lon1 = (user.lon ?? 0) * p;
    double lat2 = latitude * p;
    double lon2 = longitude * p;

    double a = 0.5 -
        cos(lat2 - lat1) / 2 +
        cos(lat1) * cos(lat2) * (1 - cos(lon2 - lon1)) / 2;

    return (radiusOfEarth * 2 * asin(sqrt(a))).toStringAsFixed(2);
  }
}

extension PlatformPathExtension on Platform {
  static Future<String> get localPath async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return '${directory?.path ?? ''}/';
  }
}
