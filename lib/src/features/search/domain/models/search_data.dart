import 'package:cnh_n/src/features/search/domain/models/airport.dart';
import 'package:cnh_n/src/core/config/api_config.dart';

class SearchData {
  // Step 1 - Basic Info
  final DateTime departureDate;
  final DateTime returnDate;
  bool isRoundTrip;
  int passengers;
  int children;
  int infants;
  String flightClass;

  // Step 2 - Locations & Filters
  Airport? departure;
  Airport? arrival;
  int maxStops;
  double? minPrice;
  double? maxPrice;
  String sortBy;
  String sortOrder;
  List<String> departureTimeFilters;

  // Step 3 - Airlines
  List<int> selectedAirlineIds;

  SearchData({
    DateTime? departureDate,
    DateTime? returnDate,
    this.isRoundTrip = false,
    this.passengers = 1,
    this.children = 0,
    this.infants = 0,
    this.flightClass = 'economy', // Default to economy instead of 'all'
    this.departure,
    this.arrival,
    this.maxStops = 2,
    this.minPrice,
    this.maxPrice,
    this.sortBy = 'price',
    this.sortOrder = 'asc',
    this.departureTimeFilters = const [],
    this.selectedAirlineIds = const [], // Empty to include all airlines
  }) : 
    departureDate = departureDate ?? _parseDevDate(ApiConfig.currentDevDates[0]),
    returnDate = returnDate ?? _parseDevDate(ApiConfig.currentDevDates[1]);

  // Helper function to parse date from DD/MM/YYYY format
  static DateTime _parseDevDate(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
    // Fallback to original date if parsing fails
    return DateTime(2025, 8, 27);
  }

  // Convert to API format
  Map<String, dynamic> toApiParams() {
    final params = {
      "departure_airport_code": departure?.code ?? 'HAN',
      "arrival_airport_code": arrival?.code ?? 'SGN',
      "departure_date": "${departureDate.day.toString().padLeft(2, '0')}/${departureDate.month.toString().padLeft(2, '0')}/${departureDate.year}",
      "flight_class": flightClass,
      "airline_ids": selectedAirlineIds,
      "max_stops": maxStops,
      "page": 1,
      "limit": 50,
      "sort_by": sortBy,
      "sort_order": sortOrder,
      if (minPrice != null) "min_price": minPrice,
      if (maxPrice != null) "max_price": maxPrice,
      if (departureTimeFilters.isNotEmpty) "departure_time_filters": departureTimeFilters,
    };

    // Handle passengers format based on trip type
    if (isRoundTrip) {
      // Roundtrip uses 'passengers' object with 'infants' (plural)
      params["passengers"] = {
        "adults": passengers,
        "children": children,
        "infants": infants,
      };
      params["return_date"] = "${returnDate.day.toString().padLeft(2, '0')}/${returnDate.month.toString().padLeft(2, '0')}/${returnDate.year}";
    } else {
      // One-way uses 'passenger' object with 'infant' (singular)
      params["passenger"] = {
        "adults": passengers,
        "children": children,
        "infant": infants,
      };
    }

    return params;
  }

  bool get canProceedToStep2 => true; // Always true since dates have default values
  bool get canProceedToStep3 => departure != null && arrival != null;
  bool get canSubmitSearch => true; // Allow search without airline selection

  SearchData copyWith({
    DateTime? departureDate,
    DateTime? returnDate,
    bool? isRoundTrip,
    int? passengers,
    int? children,
    int? infants,
    String? flightClass,
    Airport? departure,
    Airport? arrival,
    int? maxStops,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? sortOrder,
    List<String>? departureTimeFilters,
    List<int>? selectedAirlineIds,
  }) {
    return SearchData(
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      isRoundTrip: isRoundTrip ?? this.isRoundTrip,
      passengers: passengers ?? this.passengers,
      children: children ?? this.children,
      infants: infants ?? this.infants,
      flightClass: flightClass ?? this.flightClass,
      departure: departure ?? this.departure,
      arrival: arrival ?? this.arrival,
      maxStops: maxStops ?? this.maxStops,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      departureTimeFilters: departureTimeFilters ?? this.departureTimeFilters,
      selectedAirlineIds: selectedAirlineIds ?? this.selectedAirlineIds,
    );
  }
}
