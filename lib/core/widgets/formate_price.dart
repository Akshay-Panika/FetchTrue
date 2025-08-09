import 'package:intl/intl.dart';

String formatPrice(num value) {
  return value.round().toString();
}

String formatDateTime(dynamic date) {
  DateTime dt;

  if (date is String) {
    dt = DateTime.parse(date);
  } else if (date is DateTime) {
    dt = date;
  } else {
    return '';
  }

  return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
}

