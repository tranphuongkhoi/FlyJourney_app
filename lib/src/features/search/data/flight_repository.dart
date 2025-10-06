import 'package:fly_journey/src/core/config/api_config.dart';
import 'flight_api_client.dart';

class FlightRepository {
  static final FlightApiClient _apiClient = FlightApiClient();

  static Future<Map<String, dynamic>> testConnection() async {
    try {
      final data = await _apiClient.get('/health');
      return {
        'success': true,
        'message': 'Connected to backend successfully',
        'data': data,
      };
    } on FlightApiException catch (e) {
      return {
        'success': false,
        'error': 'HTTP_${e.statusCode ?? ''}',
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Network Error',
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> searchFlights(
      Map<String, dynamic> searchParams) async {
    try {
      if (ApiConfig.useMockData) {
        throw const FlightApiException(
            'Mock data is disabled. Please set useMockData to false and ensure backend is running.');
      }

      final apiParams = _transformSearchParams(searchParams);
      final bool isRoundTrip = apiParams['return_date'] != null;
      final path =
          isRoundTrip ? ApiConfig.searchRoundtripFlights : ApiConfig.searchFlights;
      final data = await _apiClient.post(path, apiParams);

      if (data['status'] == true) {
        final responseData = data['data'];
        if (responseData['search_results'] is Map &&
            responseData['search_results']['outbound_flights'] != null) {
          return {
            'success': true,
            'data': {
              ...responseData,
              'is_roundtrip': true,
              'search_results': responseData['search_results'],
            },
          };
        } else {
          return {
            'success': true,
            'data': {
              ...responseData,
              'is_roundtrip': false,
            },
          };
        }
      } else {
        return {
          'success': false,
          'error': data['errorCode'] ?? 'API_ERROR',
          'message': data['errorMessage'] ?? 'Unknown error',
        };
      }
    } on FlightApiException catch (e) {
      return {
        'success': false,
        'error': 'Network Error',
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Unknown',
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getFlightDetails(String flightId) async {
    try {
      final path = ApiConfig.flightDetails.replaceAll('{id}', flightId);
      final data = await _apiClient.get(path);
      return data;
    } on FlightApiException catch (e) {
      return {
        'success': false,
        'error': 'Network Error',
        'message': e.message,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Unknown',
        'message': e.toString(),
      };
    }
  }

  static Map<String, dynamic> _transformSearchParams(
      Map<String, dynamic> appParams) {
    final apiParams = Map<String, dynamic>.from(appParams);
    apiParams['airline_ids'] = _convertToIntArray(appParams['airline_ids']);
    apiParams['departure_airport_code'] ??= 'HAN';
    apiParams['arrival_airport_code'] ??= 'SGN';
    apiParams['departure_date'] ??= '27/08/2025';
    apiParams['page'] ??= 1;
    apiParams['limit'] ??= 50;
    apiParams['sort_by'] ??= 'price';
    apiParams['sort_order'] ??= 'asc';
    return apiParams;
  }

  static List<int> _convertToIntArray(dynamic airlineIds) {
    if (airlineIds == null) return [];
    if (airlineIds is List) {
      return airlineIds
          .map((id) {
            if (id is int) return id;
            if (id is String) return int.tryParse(id) ?? 0;
            return 0;
          })
          .where((id) => id > 0)
          .toList();
    }
    return [];
  }
}
