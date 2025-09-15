import 'package:fly_journey/src/features/search/domain/models/airport.dart';
import 'package:fly_journey/src/features/search/domain/models/fare_class_details.dart';
import 'package:fly_journey/src/features/search/domain/models/pricing.dart';

class Flight {
  final int? flightId;
  final int? flightClassId;
  final String flightNumber;
  final int? airlineId;
  final String airline;
  final String airlineLogo;
  final Airport departure;
  final Airport arrival;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price; // For backward compatibility
  final String aircraft;
  final int availableSeats;
  final String duration;
  
  // New fields from API
  final int durationMinutes;
  final int stopsCount;
  final double distance;
  final String flightClass;
  final int totalSeats;
  final FareClassDetails? fareClassDetails;
  final Pricing? pricing;
  final double taxAndFees;

  const Flight({
    this.flightId,
    this.flightClassId,
    required this.flightNumber,
    this.airlineId,
    required this.airline,
    required this.airlineLogo,
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.aircraft,
    required this.availableSeats,
    required this.duration,
    this.durationMinutes = 0,
    this.stopsCount = 0,
    this.distance = 0.0,
    this.flightClass = 'economy',
    this.totalSeats = 0,
    this.fareClassDetails,
    this.pricing,
    this.taxAndFees = 0.0,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    final int durationMins = (json['duration_minutes'] is int)
        ? json['duration_minutes'] as int
        : (json['duration'] is int)
            ? json['duration'] as int
            : 0;

    final String durationStr = (json['duration'] is String)
        ? json['duration'] as String
        : _formatDuration(durationMins);

    return Flight(
      flightId: json['flight_id'],
      flightClassId: json['flight_class_id'],
      flightNumber: (json['flight_number'] ?? json['flightNumber'] ?? '').toString(),
      airlineId: json['airline_id'],
      airline: (json['airline_name'] ?? json['airline'] ?? '').toString(),
      airlineLogo: (json['logo_url'] ?? json['airlineLogo'] ?? '').toString(),
      departure: json['departure'] != null
          ? Airport.fromJson(json['departure'])
          : Airport(
              code: (json['departure_airport_code'] ?? '').toString(),
              name: (json['departure_airport'] ?? '').toString(),
              city: (json['departure_airport'] ?? '').toString(),
              country: 'Việt Nam',
            ),
      arrival: json['arrival'] != null
          ? Airport.fromJson(json['arrival'])
          : Airport(
              code: (json['arrival_airport_code'] ?? '').toString(),
              name: (json['arrival_airport'] ?? '').toString(),
              city: (json['arrival_airport'] ?? '').toString(),
              country: 'Việt Nam',
            ),
      departureTime: DateTime.tryParse((json['departure_time'] ?? json['departureTime'] ?? '').toString()) ??
          DateTime.now(),
      arrivalTime: DateTime.tryParse((json['arrival_time'] ?? json['arrivalTime'] ?? '').toString()) ??
          DateTime.now(),
      price: _toDouble(json['pricing']?['grand_total'] ?? json['price'] ?? 0),
      aircraft: (json['aircraft'] ?? 'Aircraft').toString(),
      availableSeats: json['availableSeats'] is int
          ? json['availableSeats'] as int
          : (json['total_seats'] is int ? json['total_seats'] as int : 0),
      duration: durationStr,
      durationMinutes: durationMins,
      stopsCount: json['stops_count'] is int ? json['stops_count'] as int : 0,
      distance: _toDouble(json['distance'] ?? 0),
      flightClass: (json['flight_class'] ?? 'economy').toString(),
      totalSeats: json['total_seats'] is int ? json['total_seats'] as int : 0,
      fareClassDetails:
          json['fare_class_details'] != null ? FareClassDetails.fromJson(json['fare_class_details']) : null,
      pricing: json['pricing'] != null ? Pricing.fromJson(json['pricing']) : null,
      taxAndFees: _toDouble(json['tax_and_fees'] ?? 0),
    );
  }

  static String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  Map<String, dynamic> toJson() => {
        'flight_id': flightId,
        'flight_class_id': flightClassId,
        'flight_number': flightNumber,
        'airline_id': airlineId,
        'airline_name': airline,
        'logo_url': airlineLogo,
        'departure': departure.toJson(),
        'arrival': arrival.toJson(),
        'departure_airport_code': departure.code,
        'arrival_airport_code': arrival.code,
        'departure_airport': departure.name,
        'arrival_airport': arrival.name,
        'departure_time': departureTime.toIso8601String(),
        'arrival_time': arrivalTime.toIso8601String(),
        'duration_minutes': durationMinutes,
        'stops_count': stopsCount,
        'distance': distance,
        'flight_class': flightClass,
        'total_seats': totalSeats,
        'fare_class_details': fareClassDetails?.toJson(),
        'pricing': pricing?.toJson(),
        'tax_and_fees': taxAndFees,
        // Backward compatibility
        'price': price,
        'aircraft': aircraft,
        'availableSeats': availableSeats,
        'duration': duration,
      };

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(',', '')) ?? 0;
    return 0;
  }
}
