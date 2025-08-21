import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cnh_n/models/booking.dart';

class StorageService {
  static const String _bookingsKey = 'bookings';

  static Future<List<Booking>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getStringList(_bookingsKey) ?? [];
    return bookingsJson
        .map((json) => Booking.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveBooking(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    final bookings = await getBookings();
    bookings.add(booking);
    final bookingsJson =
        bookings.map((booking) => jsonEncode(booking.toJson())).toList();
    await prefs.setStringList(_bookingsKey, bookingsJson);
  }

  static Future<void> removeBooking(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookings = await getBookings();
    bookings.removeWhere((booking) => booking.bookingId == bookingId);
    final bookingsJson =
        bookings.map((booking) => jsonEncode(booking.toJson())).toList();
    await prefs.setStringList(_bookingsKey, bookingsJson);
  }

  static Future<void> clearBookings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookingsKey);
  }
}
