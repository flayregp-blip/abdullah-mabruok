import 'dart:developer' as developer;

class Loggers {
  static void info(Object? msg) {
    developer.log('$msg', name: 'INFO');
  }

  static void success(Object? msg) {
    developer.log('✅✅✅: $msg', name: 'SUCCESS');
  }

  static void warning(Object? msg) {
    developer.log('⚠️⚠️⚠️: $msg', name: 'WARNING');
  }

  static void error(Object? msg) {
    developer.log('🔴🔴🔴: $msg', name: 'ERROR');
  }
}
