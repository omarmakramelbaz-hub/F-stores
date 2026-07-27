import 'package:logger/logger.dart';

class PrintLog {
  static bool isDebug = true;

  static Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
      printTime: false,
      levelEmojis: {
        Level.debug: '🐛',
        Level.error: '❌',
        Level.info: '📌',
        Level.off: '🔇',
        Level.warning: '⚠️',
        Level.fatal: '🤬',
        Level.all: '📢',
        Level.trace: '🔍',
      },
    ),
  );

  static void d(dynamic message) => logger.d(message);
  static void i(dynamic message) => logger.i(message);
  static void e(dynamic message) => logger.e(message);
  static void t(dynamic message) => logger.t(message);
  static void w(dynamic message) => logger.w(message);
  static void f(dynamic message) => logger.f(message);
}
