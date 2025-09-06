import 'package:cnh_n/models/flight.dart';

class RoundtripSearchResponse {
  final String arrivalAirport;
  final String departureAirport;
  final String departureDate;
  final String returnDate;
  final String flightClass;
  final int inboundTotalCount;
  final int inboundTotalPages;
  final int outboundTotalCount;
  final int outboundTotalPages;
  final int limit;
  final int page;
  final PassengerCount passengerCount;
  final SearchResults searchResults;
  final String sortBy;
  final String sortOrder;

  const RoundtripSearchResponse({
    required this.arrivalAirport,
    required this.departureAirport,
    required this.departureDate,
    required this.returnDate,
    required this.flightClass,
    required this.inboundTotalCount,
    required this.inboundTotalPages,
    required this.outboundTotalCount,
    required this.outboundTotalPages,
    required this.limit,
    required this.page,
    required this.passengerCount,
    required this.searchResults,
    required this.sortBy,
    required this.sortOrder,
  });

  factory RoundtripSearchResponse.fromJson(Map<String, dynamic> json) => RoundtripSearchResponse(
        arrivalAirport: json['arrival_airport'] ?? '',
        departureAirport: json['departure_airport'] ?? '',
        departureDate: json['departure_date'] ?? '',
        returnDate: json['return_date'] ?? '',
        flightClass: json['flight_class'] ?? '',
        inboundTotalCount: json['inbound_total_count'] ?? 0,
        inboundTotalPages: json['inbound_total_pages'] ?? 0,
        outboundTotalCount: json['outbound_total_count'] ?? 0,
        outboundTotalPages: json['outbound_total_pages'] ?? 0,
        limit: json['limit'] ?? 50,
        page: json['page'] ?? 1,
        passengerCount: PassengerCount.fromJson(json['passenger_count'] ?? {}),
        searchResults: SearchResults.fromJson(json['search_results'] ?? {}),
        sortBy: json['sort_by'] ?? 'price',
        sortOrder: json['sort_order'] ?? 'asc',
      );

  Map<String, dynamic> toJson() => {
        'arrival_airport': arrivalAirport,
        'departure_airport': departureAirport,
        'departure_date': departureDate,
        'return_date': returnDate,
        'flight_class': flightClass,
        'inbound_total_count': inboundTotalCount,
        'inbound_total_pages': inboundTotalPages,
        'outbound_total_count': outboundTotalCount,
        'outbound_total_pages': outboundTotalPages,
        'limit': limit,
        'page': page,
        'passenger_count': passengerCount.toJson(),
        'search_results': searchResults.toJson(),
        'sort_by': sortBy,
        'sort_order': sortOrder,
      };
}

class PassengerCount {
  final int adults;
  final int children;
  final int infants;

  const PassengerCount({
    required this.adults,
    required this.children,
    required this.infants,
  });

  factory PassengerCount.fromJson(Map<String, dynamic> json) => PassengerCount(
        adults: json['adults'] ?? 0,
        children: json['children'] ?? 0,
        infants: json['infants'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'adults': adults,
        'children': children,
        'infants': infants,
      };
}

class SearchResults {
  final List<Flight> outboundFlights;
  final List<Flight> inboundFlights;

  const SearchResults({
    required this.outboundFlights,
    required this.inboundFlights,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
        outboundFlights: (json['outbound_flights'] as List<dynamic>?)
                ?.map((flight) => Flight.fromJson(flight as Map<String, dynamic>))
                .toList() ??
            [],
        inboundFlights: (json['inbound_flights'] as List<dynamic>?)
                ?.map((flight) => Flight.fromJson(flight as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'outbound_flights': outboundFlights.map((flight) => flight.toJson()).toList(),
        'inbound_flights': inboundFlights.map((flight) => flight.toJson()).toList(),
      };
}
