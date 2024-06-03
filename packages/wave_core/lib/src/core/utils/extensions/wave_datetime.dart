import 'package:intl/intl.dart';

// Create a static extension to datetime named waveParse
extension WaveDateTime on DateTime {
  /// Parse a string to a DateTime object
  static DateTime parse(String date) {
    DateFormat dateFormat = DateFormat("E, dd MMM yyyy HH:mm:ss 'GMT'", "en_US");
    return dateFormat.parse(date);
  }
}