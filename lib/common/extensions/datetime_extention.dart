import 'package:intl/intl.dart';

extension FormateTime on DateTime {
  String get formatTime {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(this);
  }
}
