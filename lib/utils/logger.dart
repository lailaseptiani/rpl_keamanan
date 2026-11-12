import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  Logger._(); // Tidak perlu di-instansiasi.

  static LogLevel minLevel = LogLevel.debug;

  static final RegExp _sensitivePattern = RegExp(
    r'(x-api-key|api[_-]?key|token|password|passwd|secret|authorization)'
    r'("?\s*[:=]\s*"?)([^\s",}]+)',
    caseSensitive: false,
  );

  static void debug(String message, {String? tag}) =>
      _log(LogLevel.debug, message, tag: tag);

  static void info(String message, {String? tag}) =>
      _log(LogLevel.info, message, tag: tag);

  static void warning(String message, {String? tag}) =>
      _log(LogLevel.warning, message, tag: tag);

  static void error(
    String message, {
    Object? error,
    Object? cause,
    String? tag,
  }) {
    final source = error ?? cause;
    final suffix = source != null ? ' (${source.runtimeType})' : '';
    _log(LogLevel.error, '$message$suffix', tag: tag);
  }

  static String mask(String input) {
    return input.replaceAllMapped(
      _sensitivePattern,
      (m) => '${m[1]}${m[2]}***',
    );
  }

  static void _log(LogLevel level, String message, {String? tag}) {
    if (!kDebugMode) return;
    if (level.index < minLevel.index) return;

    final time = DateTime.now().toIso8601String().substring(11, 23);
    final label = level.name.toUpperCase().padRight(7);
    final tagText = tag != null ? '[$tag] ' : '';
    debugPrint('$time $label $tagText${mask(message)}');
  }
}
