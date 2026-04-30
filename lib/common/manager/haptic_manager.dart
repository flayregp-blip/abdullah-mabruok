import 'package:flutter/services.dart';

class HapticManager {
  static final shared = HapticManager();

  void light() {
    HapticFeedback.lightImpact();
  }

  void medium() {
    HapticFeedback.mediumImpact();
  }
}
