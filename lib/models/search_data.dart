import 'package:cnh_n/models/airport.dart';

class SearchData {
  // Step 1 - Basic Info
  DateTime? departureDate;
  DateTime? returnDate;
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
    this.departureDate,
    this.returnDate,
    this.isRoundTrip = false,
    this.passengers = 1,
    this.children = 0,
    this.infants = 0,
    this.flightClass = 'business',
    this.departure,
    this.arrival,
    this.maxStops = 2,
    this.minPrice,
    this.maxPrice,
    this.sortBy = 'price',
    this.sortOrder = 'asc',
    this.departureTimeFilters = const [],
    this.selectedAirlineIds = const [],
  });

  // Convert to API format
  Map<String, dynamic> toApiParams() {
    final params = {
      "departure_airport_code": departure?.code ?? 'HAN',
      "arrival_airport_code": arrival?.code ?? 'SGN',
      "departure_date": departureDate != null
          ? "${departureDate!.day.toString().padLeft(2, '0')}/${departureDate!.month.toString().padLeft(2, '0')}/${departureDate!.year}"
          : '01/08/2025',
      "flight_class": flightClass,
      "airline_ids": selectedAirlineIds,
      "max_stops": maxStops,
      "passengers": {
        "adults": passengers,
        "children": children,
        "infants": infants,
      },
      "passenger": {
        "adults": passengers,
        "children": children,
        "infant": infants,
      },
      "page": 1,
      "limit": 50,
      "sort_by": sortBy,
      "sort_order": sortOrder,
      if (minPrice != null) "min_price": minPrice,
      if (maxPrice != null) "max_price": maxPrice,
      if (departureTimeFilters.isNotEmpty) "departure_time_filters": departureTimeFilters,
    };

    if (isRoundTrip && returnDate != null) {
      params["return_date"] = "${returnDate!.day.toString().padLeft(2, '0')}/${returnDate!.month.toString().padLeft(2, '0')}/${returnDate!.year}";
    }

    return params;
  }

  bool get canProceedToStep2 => departureDate != null && (!isRoundTrip || returnDate != null);
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
