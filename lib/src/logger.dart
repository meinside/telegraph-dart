/// Logger class

import 'package:intl/intl.dart';

class Logger {
  /// Log verbose logs or not.
  static bool verbose;

  // Datetime format for logging
  static DateFormat _dtFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  /// Log verbose message if [verbose] is true.
  static void v(String log) {
    if (verbose) {
      print("${_dtFormat.format(DateTime.now())} [VERBOSE] ${log}");
    }
  }

  /// Log error message.
  static void e(String log) {
    print("${_dtFormat.format(DateTime.now())} [ERROR] ${log}");
  }
}
