import 'package:cnh_n/models/flight.dart';
import 'package:cnh_n/models/passenger.dart';

enum BookingStatus { confirmed, cancelled, completed }

class Booking {
  final String bookingId;
  final Flight flight;
  final Flight? returnFlight;
  final List<Passenger> passengers;
  final DateTime bookingDate;
  final double totalPrice;
  final BookingStatus status;
  final String contactEmail;
  final String contactPhone;

  const Booking({
    required this.bookingId,
    required this.flight,
    this.returnFlight,
    required this.passengers,
    required this.bookingDate,
    required this.totalPrice,
    required this.status,
    required this.contactEmail,
    required this.contactPhone,
  });

  bool get isRoundTrip => returnFlight != null;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        bookingId: json['bookingId'],
        flight: Flight.fromJson(json['flight']),
        returnFlight: json['returnFlight'] != null
            ? Flight.fromJson(json['returnFlight'])
            : null,
        passengers: (json['passengers'] as List)
            .map((p) => Passenger.fromJson(p))
            .toList(),
        bookingDate: DateTime.parse(json['bookingDate']),
        totalPrice: json['totalPrice'].toDouble(),
        status: BookingStatus.values.firstWhere(
          (s) => s.name == json['status'],
        ),
        contactEmail: json['contactEmail'],
        contactPhone: json['contactPhone'],
      );

  Map<String, dynamic> toJson() => {
        'bookingId': bookingId,
        'flight': flight.toJson(),
        'returnFlight': returnFlight?.toJson(),
        'passengers': passengers.map((p) => p.toJson()).toList(),
        'bookingDate': bookingDate.toIso8601String(),
        'totalPrice': totalPrice,
        'status': status.name,
        'contactEmail': contactEmail,
        'contactPhone': contactPhone,
      };
}
