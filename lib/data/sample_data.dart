import 'package:cnh_n/models/airport.dart';
import 'package:cnh_n/models/flight.dart';

class SampleData {
  static const List<Airport> airports = [
    Airport(code: 'HAN', name: 'Sân bay quốc tế Nội Bài', city: 'Hà Nội', country: 'Việt Nam'),
    Airport(code: 'SGN', name: 'Sân bay quốc tế Tân Sơn Nhất', city: 'TP.HCM', country: 'Việt Nam'),
    Airport(code: 'DAD', name: 'Sân bay quốc tế Đà Nẵng', city: 'Đà Nẵng', country: 'Việt Nam'),
    Airport(code: 'PQC', name: 'Sân bay quốc tế Phú Quốc', city: 'Phú Quốc', country: 'Việt Nam'),
    Airport(code: 'CXR', name: 'Sân bay Cam Ranh', city: 'Nha Trang', country: 'Việt Nam'),
    Airport(code: 'HPH', name: 'Sân bay Cát Bi', city: 'Hải Phòng', country: 'Việt Nam'),
    Airport(code: 'VCA', name: 'Sân bay Cần Thơ', city: 'Cần Thơ', country: 'Việt Nam'),
  ];

  static List<Flight> generateFlights(Airport departure, Airport arrival, DateTime date) {
    final List<Flight> flights = [];
    
    // Vietnam Airlines flights
    flights.addAll([
      Flight(
        flightNumber: 'VN${_generateFlightNumber()}',
        airline: 'Vietnam Airlines',
        airlineLogo: 'https://pixabay.com/get/gf3cff1a9d4d7169cf84dc2d6524d611facb25064d502d3b703e0a69fcf5649354a9fe369dfe2a43e9fbd2eafd7c0fc1c9d035b52fc94a22793e251faf286dc49_1280.jpg',
        departure: departure,
        arrival: arrival,
        departureTime: DateTime(date.year, date.month, date.day, 6, 30),
        arrivalTime: DateTime(date.year, date.month, date.day, 8, 45),
        price: _generatePrice(departure, arrival),
        aircraft: 'Airbus A321',
        availableSeats: 45,
        duration: '2h 15m',
      ),
      Flight(
        flightNumber: 'VN${_generateFlightNumber()}',
        airline: 'Vietnam Airlines',
        airlineLogo: 'https://pixabay.com/get/gf3cff1a9d4d7169cf84dc2d6524d611facb25064d502d3b703e0a69fcf5649354a9fe369dfe2a43e9fbd2eafd7c0fc1c9d035b52fc94a22793e251faf286dc49_1280.jpg',
        departure: departure,
        arrival: arrival,
        departureTime: DateTime(date.year, date.month, date.day, 14, 20),
        arrivalTime: DateTime(date.year, date.month, date.day, 16, 35),
        price: _generatePrice(departure, arrival) + 200000,
        aircraft: 'Boeing 787',
        availableSeats: 23,
        duration: '2h 15m',
      ),
    ]);

    // VietJet Air flights
    flights.addAll([
      Flight(
        flightNumber: 'VJ${_generateFlightNumber()}',
        airline: 'VietJet Air',
        airlineLogo: 'https://pixabay.com/get/gc7c5f74f5d7a9f1e95283155d06d4992b0543f276c0c227824092cba2c3308a3e20878cd15cb66973a8f1f6804e4d848f13e9027cae5d418978b3d47d27108aa_1280.jpg',
        departure: departure,
        arrival: arrival,
        departureTime: DateTime(date.year, date.month, date.day, 9, 15),
        arrivalTime: DateTime(date.year, date.month, date.day, 11, 30),
        price: _generatePrice(departure, arrival) - 300000,
        aircraft: 'Airbus A320',
        availableSeats: 67,
        duration: '2h 15m',
      ),
      Flight(
        flightNumber: 'VJ${_generateFlightNumber()}',
        airline: 'VietJet Air',
        airlineLogo: 'https://pixabay.com/get/gc7c5f74f5d7a9f1e95283155d06d4992b0543f276c0c227824092cba2c3308a3e20878cd15cb66973a8f1f6804e4d848f13e9027cae5d418978b3d47d27108aa_1280.jpg',
        departure: departure,
        arrival: arrival,
        departureTime: DateTime(date.year, date.month, date.day, 18, 45),
        arrivalTime: DateTime(date.year, date.month, date.day, 21, 0),
        price: _generatePrice(departure, arrival) - 150000,
        aircraft: 'Airbus A321',
        availableSeats: 34,
        duration: '2h 15m',
      ),
    ]);

    // Bamboo Airways flights
    flights.addAll([
      Flight(
        flightNumber: 'QH${_generateFlightNumber()}',
        airline: 'Bamboo Airways',
        airlineLogo: 'https://pixabay.com/get/g364926d29cc5c292fa868e01c324af4ccbd4c76e14b18cc327032b4a3959b88a699ecc51ce2cc8ed4cea12384853c9873033fc8ceb6c6421176eb3c108e0882c_1280.jpg',
        departure: departure,
        arrival: arrival,
        departureTime: DateTime(date.year, date.month, date.day, 12, 10),
        arrivalTime: DateTime(date.year, date.month, date.day, 14, 25),
        price: _generatePrice(departure, arrival) - 100000,
        aircraft: 'Embraer E190',
        availableSeats: 18,
        duration: '2h 15m',
      ),
    ]);

    return flights;
  }

  static String _generateFlightNumber() {
    return (100 + DateTime.now().millisecond % 900).toString();
  }

  static double _generatePrice(Airport departure, Airport arrival) {
    // Base prices for common routes in VND
    final basePrice = {
      'HAN-SGN': 2500000.0,
      'SGN-HAN': 2500000.0,
      'HAN-DAD': 1800000.0,
      'DAD-HAN': 1800000.0,
      'SGN-DAD': 1600000.0,
      'DAD-SGN': 1600000.0,
      'HAN-PQC': 2200000.0,
      'PQC-HAN': 2200000.0,
      'SGN-PQC': 1400000.0,
      'PQC-SGN': 1400000.0,
    };

    final route = '${departure.code}-${arrival.code}';
    return basePrice[route] ?? 2000000.0;
  }
}