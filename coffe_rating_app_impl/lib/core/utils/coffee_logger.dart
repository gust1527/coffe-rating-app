import 'package:flutter/foundation.dart';

/// Production-safe logging utility for the Coffee Rating App
/// 
/// This class ensures that log statements are completely stripped out
/// in release builds, preventing any accidental logging in production.
class CoffeeLogger {
  static const String _prefix = '☕️ CoffeeLog';
  
  /// Log debug information - only prints in debug mode
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('$_prefix DEBUG: $message');
      if (error != null) {
        debugPrint('$_prefix ERROR: $error');
      }
      if (stackTrace != null) {
        debugPrint('$_prefix STACK: $stackTrace');
      }
    }
  }
  
  /// Log information - only prints in debug mode
  static void info(String message) {
    if (kDebugMode) {
      debugPrint('$_prefix INFO: $message');
    }
  }
  
  /// Log warnings - only prints in debug mode
  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('$_prefix WARNING: $message');
    }
  }
  
  /// Log errors - only prints in debug mode
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('$_prefix ERROR: $message');
      if (error != null) {
        debugPrint('$_prefix ERROR DETAILS: $error');
      }
      if (stackTrace != null) {
        debugPrint('$_prefix STACK TRACE: $stackTrace');
      }
    }
  }
  
  /// Database operation logs - only prints in debug mode
  static void database(String message, [Object? error]) {
    if (kDebugMode) {
      debugPrint('$_prefix DB: $message');
      if (error != null) {
        debugPrint('$_prefix DB ERROR: $error');
      }
    }
  }
  
  /// Rating operation logs - only prints in debug mode
  static void rating(String message) {
    if (kDebugMode) {
      debugPrint('$_prefix RATING: $message');
    }
  }
  
  /// Bean operation logs - only prints in debug mode
  static void bean(String message) {
    if (kDebugMode) {
      debugPrint('$_prefix BEAN: $message');
    }
  }
  
  /// UI interaction logs - only prints in debug mode
  static void ui(String message) {
    if (kDebugMode) {
      debugPrint('$_prefix UI: $message');
    }
  }
  
  /// Firebase operation logs - only prints in debug mode
  static void firebase(String message, [Object? error]) {
    if (kDebugMode) {
      debugPrint('$_prefix FIREBASE: $message');
      if (error != null) {
        debugPrint('$_prefix FIREBASE ERROR: $error');
      }
    }
  }
} 