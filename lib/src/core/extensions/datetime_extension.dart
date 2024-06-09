import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (isAtSameMomentAs(today)) {
      return 'Today';
    } else if (isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('d MMM yyyy').format(this);
    }
  }
}
