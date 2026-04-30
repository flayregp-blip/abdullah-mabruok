import 'dart:async';

import 'package:get/get.dart';

class TimerManager {
  // Singleton instance
  static final TimerManager _instance = TimerManager._internal();

  factory TimerManager() => _instance;

  TimerManager._internal();

  // Reactive variable for recording duration
  final Rx<Duration> recordingDuration = Duration.zero.obs;

  // Internal variables
  Timer? _timer;
  bool _isPaused = false;

  // Listener callback for external use
  Function(Duration elapsedTime)? onSecondChanged;

  /// Starts the timer from zero or resumes if paused
  void startTimer() {
    if (_isPaused && _timer != null) {
      _isPaused = false;
      _startInternalTimer();
    } else {
      stopTimer(); // Ensure previous timer is stopped
      recordingDuration.value = Duration.zero;
      _startInternalTimer();
    }
  }

  /// Pauses the timer
  void pauseTimer() {
    if (_timer != null && !_isPaused) {
      _isPaused = true;
      _timer?.cancel();
    }
  }

  /// Resumes the timer
  void resumeTimer() {
    if (_isPaused) {
      _isPaused = false;
      _startInternalTimer();
    }
  }

  /// Stops the timer and resets the value
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isPaused = false;
    recordingDuration.value = Duration.zero;
    _notifyListener();
  }

  /// Internal method to start the timer
  void _startInternalTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      recordingDuration.value += const Duration(milliseconds: 1);
      _notifyListener();
    });
  }

  /// Adds a listener to observe timer changes
  void addListener(Function(Duration elapsedTime) callback) {
    onSecondChanged = callback;
  }

  /// Removes the listener
  void removeListener() {
    onSecondChanged = null;
    recordingDuration.value = Duration.zero;
  }

  /// Notifies listener with elapsed duration
  void _notifyListener() {
    if (onSecondChanged != null) {
      onSecondChanged!(recordingDuration.value);
    }
  }
}

