import 'package:intl/intl.dart';

class AppDateFormatter {
  static String dateMonthYear(DateTime originalDate) {
    final DateFormat formatter = DateFormat('d MMMM yyyy', "id_ID");
    return formatter.format(originalDate);
  }

  static String dayDateMonthYear(DateTime originalDate) {
    final DateFormat formatter = DateFormat('EEEE, d MMMM yyyy', "id_ID");
    return formatter.format(originalDate);
  }
}
