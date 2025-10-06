import 'package:fly_journey/src/features/search/domain/models/flight.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Flight> flights;
  final List<Flight> outboundFlights;
  final List<Flight> inboundFlights;
  final String? message;

  SearchLoaded({
    required this.flights,
    required this.outboundFlights,
    required this.inboundFlights,
    this.message,
  });
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
