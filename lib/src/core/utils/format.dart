import 'package:intl/intl.dart';

final _vnd = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

String formatVND(num value) => _vnd.format(value);

String formatTime(DateTime t) => DateFormat('HH:mm', 'vi_VN').format(t);

String formatDateShort(DateTime d) => DateFormat('EEE, dd MMM', 'vi_VN').format(d);

String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  if (h == 0) return '${m}m';
  if (m == 0) return '${h}h';
  return '${h}h ${m}m';
}
