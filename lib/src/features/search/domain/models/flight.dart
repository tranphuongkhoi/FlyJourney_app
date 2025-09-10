import 'package:cnh_n/src/features/search/domain/models/airport.dart';
import 'package:cnh_n/src/features/search/domain/models/fare_class_details.dart';
import 'package:cnh_n/src/features/search/domain/models/pricing.dart';

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

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
        flightId: json['flight_id'],
        flightClassId: json['flight_class_id'],
        flightNumber: json['flight_number'] ?? json['flightNumber'] ?? '',
        airlineId: json['airline_id'],
        airline: json['airline_name'] ?? json['airline'] ?? '',
        airlineLogo: json['logo_url'] ?? json['airlineLogo'] ?? '',
        departure: json['departure'] != null 
            ? Airport.fromJson(json['departure'])
            : Airport(
                code: json['departure_airport_code'] ?? '',
                name: json['departure_airport'] ?? '',
                city: json['departure_airport'] ?? '',
                country: 'Việt Nam',
              ),
        arrival: json['arrival'] != null 
            ? Airport.fromJson(json['arrival'])
            : Airport(
                code: json['arrival_airport_code'] ?? '',
                name: json['arrival_airport'] ?? '',
                city: json['arrival_airport'] ?? '',
                country: 'Việt Nam',
              ),
        departureTime: DateTime.tryParse(json['departure_time'] ?? json['departureTime'] ?? '') ?? DateTime.now(),
        arrivalTime: DateTime.tryParse(json['arrival_time'] ?? json['arrivalTime'] ?? '') ?? DateTime.now(),
        price: (json['pricing']?['grand_total'] ?? json['price'] ?? 0).toDouble(),
        aircraft: json['aircraft'] ?? 'Aircraft',
        availableSeats: json['availableSeats'] ?? json['total_seats'] ?? 0,
        duration: json['duration'] ?? _formatDuration(json['duration_minutes'] ?? 0),
        durationMinutes: json['duration_minutes'] ?? 0,
        stopsCount: json['stops_count'] ?? 0,
        distance: (json['distance'] ?? 0).toDouble(),
        flightClass: json['flight_class'] ?? 'economy',
        totalSeats: json['total_seats'] ?? 0,
        fareClassDetails: json['fare_class_details'] != null 
            ? FareClassDetails.fromJson(json['fare_class_details'])
            : null,
        pricing: json['pricing'] != null 
            ? Pricing.fromJson(json['pricing'])
            : null,
        taxAndFees: (json['tax_and_fees'] ?? 0).toDouble(),
      );

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
}
