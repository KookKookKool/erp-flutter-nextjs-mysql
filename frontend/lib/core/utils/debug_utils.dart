import 'package:flutter/material.dart';

/// Debug utility for tracking navigation and state changes
class DebugUtils {
  static bool _debugMode = true;

  static void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  /// Log navigation events
  static void logNavigation(String from, String to, [String? reason]) {
    if (!_debugMode) return;

    final message = reason != null
        ? '[NAVIGATION] $from -> $to (Reason: $reason)'
        : '[NAVIGATION] $from -> $to';
    debugPrint(message);
  }

  /// Log state changes
  static void logStateChange(String component, String from, String to) {
    if (!_debugMode) return;

    debugPrint('[STATE_CHANGE] $component: $from -> $to');
  }

  /// Log screen size changes
  static void logScreenSizeChange(double oldWidth, double newWidth) {
    if (!_debugMode) return;

    debugPrint('[SCREEN_SIZE] Width changed: $oldWidth -> $newWidth');
  }

  /// Log drawer events
  static void logDrawerEvent(String event, {bool? isDesktop}) {
    if (!_debugMode) return;

    final mode = isDesktop != null
        ? (isDesktop ? 'Desktop' : 'Mobile')
        : 'Unknown';
    debugPrint('[DRAWER] $event (Mode: $mode)');
  }

  /// Log bloc events
  static void logBlocEvent(String blocName, String event, [dynamic data]) {
    if (!_debugMode) return;

    final message = data != null
        ? '[BLOC] $blocName: $event ($data)'
        : '[BLOC] $blocName: $event';
    debugPrint(message);
  }

  /// Log performance issues
  static void logPerformanceWarning(String component, Duration duration) {
    if (!_debugMode) return;

    if (duration.inMilliseconds > 100) {
      debugPrint(
        '[PERFORMANCE_WARNING] $component took ${duration.inMilliseconds}ms',
      );
    }
  }
}
