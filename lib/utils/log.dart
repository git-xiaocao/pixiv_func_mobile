import 'package:flutter/foundation.dart';

class Log {
  static void e(dynamic message, [dynamic error]) {
    _output('[ERROR]', message, _AnsiColor.fg(180), error);
  }

  static void d(
    String message,
  ) {
    _output('[DEBUG]', message, _AnsiColor.none());
  }

  static void i(dynamic message) {
    _output('[INFO]', message, _AnsiColor.fg(12));
  }

  static void w(dynamic message) {
    _output('[WARN]', message, _AnsiColor.fg(208));
  }

  static void v(dynamic message) {
    _output('[VERBOSE]', message, _AnsiColor.fg(196));
  }

  static void wtf(dynamic message) {
    _output('[WTF]', message, _AnsiColor.fg(199));
  }

  static void _output(String label, dynamic content, _AnsiColor color, [dynamic error]) {
    if (kDebugMode) {
      print(color('$label ${_formatStackTrace(StackTrace.current)}'));
      print(color(content.toString()));
      if (error != null) {
        print(color(error.toString()));
      }
    }
  }

  static String _formatStackTrace(StackTrace stackTrace) {
    final line = stackTrace.toString().split('\n').last;
    return line;
  }
}

class _AnsiColor {
  /// ANSI Control Sequence Introducer，向终端发出新设置的信号。
  static const ansiEsc = '\x1B[';

  /// 将当前 SGR 的所有颜色和选项重置为终端默认值。
  static const ansiDefault = '${ansiEsc}0m';

  final int? fg;
  final int? bg;
  final bool color;

  _AnsiColor.none()
      : fg = null,
        bg = null,
        color = false;

  _AnsiColor.fg(this.fg)
      : bg = null,
        color = true;

  _AnsiColor.bg(this.bg)
      : fg = null,
        color = true;

  @override
  String toString() {
    if (fg != null) {
      return '${ansiEsc}38;5;${fg}m';
    } else if (bg != null) {
      return '${ansiEsc}48;5;${bg}m';
    } else {
      return '';
    }
  }

  String call(String msg) {
    if (color) {
      return '${this}$msg$ansiDefault';
    } else {
      return msg;
    }
  }

  _AnsiColor toFg() => _AnsiColor.fg(bg);

  _AnsiColor toBg() => _AnsiColor.bg(fg);

  /// 在不改变背景的情况下默认终端的前景色。
  String get resetForeground => color ? '${ansiEsc}39m' : '';

  /// 在不改变前景的情况下默认终端的背景颜色。
  String get resetBackground => color ? '${ansiEsc}49m' : '';

  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();
}
