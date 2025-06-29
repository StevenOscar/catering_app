import 'package:intl/intl.dart';

class MoneyFormatter {
  static String toIdr(int price) {
    return "Rp. ${NumberFormat('###,###,###', 'id_ID').format(price).toString()}";
  }
}
