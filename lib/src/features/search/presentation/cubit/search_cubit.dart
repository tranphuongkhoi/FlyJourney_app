import 'package:bloc/bloc.dart';
import '../../domain/models/flight.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final Future<Map<String, dynamic>> Function(Map<String, dynamic>) searchFlightsFn;
  SearchCubit({required this.searchFlightsFn}) : super(SearchInitial());

  Future<void> search(Map<String, dynamic> params, bool isRoundTrip) async {
    emit(SearchLoading());
    try {
      final result = await searchFlightsFn(params);
      if (result['success'] == true) {
        final data = result['data'];
        final searchResults = data['search_results'];
        List<Flight> outbound = [];
        List<Flight> inbound = [];
        List<Flight> all = [];

        if (searchResults is List) {
          outbound = searchResults.map<Flight>((e) => Flight.fromJson(e)).toList();
          outbound = _applyClientSideFiltering(outbound, params);
          all.addAll(outbound);
        } else if (searchResults is Map<String, dynamic>) {
          final outboundList = (searchResults['outbound_flights'] as List?) ?? [];
          final inboundList = (searchResults['inbound_flights'] as List?) ?? [];
          outbound = outboundList.map<Flight>((e) => Flight.fromJson(e)).toList();
          inbound = inboundList.map<Flight>((e) => Flight.fromJson(e)).toList();
          outbound = _applyClientSideFiltering(outbound, params);
          inbound = _applyClientSideFiltering(inbound, params);
          all.addAll(outbound);
          if (isRoundTrip) {
            all.addAll(inbound);
          }
        }

        String? message;
        if (all.isEmpty) {
          message = 'Không tìm thấy chuyến bay nào cho tuyến này. Vui lòng thử lại với ngày khác hoặc bộ lọc khác.';
        }

        emit(SearchLoaded(
          flights: all,
          outboundFlights: outbound,
          inboundFlights: inbound,
          message: message,
        ));
      } else {
        emit(SearchError(result['message'] ?? 'Có lỗi xảy ra khi tìm kiếm chuyến bay. Vui lòng thử lại.'));
      }
    } catch (_) {
      emit(SearchError('Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng và thử lại.'));
    }
  }

  List<Flight> _applyClientSideFiltering(List<Flight> flights, Map<String, dynamic> params) {
    List<Flight> filtered = List.from(flights);

    final flightClass = params['flight_class'] as String?;
    final airlineIds = params['airline_ids'] as List?;

    if (flightClass != null && flightClass != 'all' && flightClass.isNotEmpty) {
      filtered = filtered
          .where((flight) => flight.flightClass.toLowerCase() == flightClass.toLowerCase())
          .toList();
    }

    if (airlineIds != null && airlineIds.isNotEmpty) {
      final ids = airlineIds.map((e) => e as int).toList();
      filtered = filtered.where((flight) => ids.contains(flight.airlineId)).toList();
    }

    return filtered;
  }
}
