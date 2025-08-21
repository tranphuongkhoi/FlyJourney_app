import 'package:cnh_n/models/airport.dart';

class Flight {
  final String flightNumber;
  final String airline;
  final String airlineLogo;
  final Airport departure;
  final Airport arrival;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String aircraft;
  final int availableSeats;
  final String duration;

  const Flight({
    required this.flightNumber,
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
  });

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
        flightNumber: json['flightNumber'],
        airline: json['airline'],
        airlineLogo: json['airlineLogo'],
        departure: Airport.fromJson(json['departure']),
        arrival: Airport.fromJson(json['arrival']),
        departureTime: DateTime.parse(json['departureTime']),
        arrivalTime: DateTime.parse(json['arrivalTime']),
        price: json['price'].toDouble(),
        aircraft: json['aircraft'],
        availableSeats: json['availableSeats'],
        duration: json['duration'],
      );

  Map<String, dynamic> toJson() => {
        'flightNumber': flightNumber,
        'airline': airline,
        'airlineLogo': airlineLogo,
        'departure': departure.toJson(),
        'arrival': arrival.toJson(),
        'departureTime': departureTime.toIso8601String(),
        'arrivalTime': arrivalTime.toIso8601String(),
        'price': price,
        'aircraft': aircraft,
        'availableSeats': availableSeats,
        'duration': duration,
      };
}
