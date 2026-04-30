import 'dart:async';

import 'package:flutter/material.dart';

class DebounceAction {
  Timer? _debounce;

  static DebounceAction shared = DebounceAction();

  void call(VoidCallback action, {int? milliseconds}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: milliseconds ?? 500), action);
  }
}
