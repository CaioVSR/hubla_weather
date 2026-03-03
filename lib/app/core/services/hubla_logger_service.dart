import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A wrapper around the [Logger] package that only logs in debug mode.
///
/// All methods are guarded by [kDebugMode] to ensure no logging
/// occurs in release or profile builds.
class HublaLoggerService {
  HublaLoggerService() : _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  final Logger _logger;

  /// Logs a debug-level message.
  void debug(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  /// Logs an info-level message.
  void info(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  /// Logs a warning-level message.
  void warning(String message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  /// Logs an error-level message with optional [error] and [stackTrace].
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
}
