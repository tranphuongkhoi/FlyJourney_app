import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
// import '../data/sample_data.dart'; // Commented out since not using mock data

class FlightService {
  /// Test connection to backend
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      print('🔍 Testing connection to backend...');
      print('🌐 Backend URL: ${ApiConfig.baseUrl}');
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/health'), // Health check endpoint
        headers: ApiConfig.headers,
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        print('✅ Backend connection successful!');
        return {
          'success': true,
          'message': 'Connected to backend successfully',
          'data': jsonDecode(response.body),
        };
      } else {
        print('⚠️ Backend responded with status: ${response.statusCode}');
        return {
          'success': false,
          'error': 'HTTP_${response.statusCode}',
          'message': 'Backend responded with status ${response.statusCode}',
        };
      }
    } catch (e) {
      print('❌ Cannot connect to backend: $e');
      return {
        'success': false,
        'error': 'CONNECTION_FAILED',
        'message': 'Cannot connect to backend: $e',
      };
    }
  }

  /// Search for flights based on search parameters
  static Future<Map<String, dynamic>> searchFlights(Map<String, dynamic> searchParams) async {
    try {
      // Check if using mock data for development
      if (ApiConfig.useMockData) {
        // Mock data is disabled - always use real API
        throw Exception('Mock data is disabled. Please set useMockData to false and ensure backend is running.');
      }
      
      // Transform search params to match API format
      final apiParams = _transformSearchParams(searchParams);
      final bool isRoundTrip = apiParams['return_date'] != null;
      
      // Debug: Print the transformed params (remove in production)
      print('🔥 API Request: ${jsonEncode(apiParams)}');
      
      // Prepare API endpoint - different for roundtrip
      final String endpoint = isRoundTrip 
        ? '${ApiConfig.baseUrl}${ApiConfig.searchRoundtripFlights}'
        : '${ApiConfig.baseUrl}${ApiConfig.searchFlights}';
      print('🌐 Endpoint: $endpoint');
      print('📡 Attempting to connect to backend...');
      
      // Make POST request to API
      print('⏰ Sending HTTP POST request...');
      final response = await http.post(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
        body: jsonEncode(apiParams),
      ).timeout(ApiConfig.requestTimeout);
      
      print('✅ Response received - Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}...');
      
      // Handle response
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        // Check if API response is successful
        if (data['status'] == true) {
          // Process response data to match Flutter app structure
          final responseData = data['data'];
          
          // For roundtrip, handle different structure
          if (responseData['search_results'] is Map && 
              responseData['search_results']['outbound_flights'] != null) {
            // Roundtrip response
            return {
              'success': true,
              'data': {
                ...responseData,
                'is_roundtrip': true,
                'outbound_flights': responseData['search_results']['outbound_flights'],
                'inbound_flights': responseData['search_results']['inbound_flights'],
                'search_results': responseData['search_results']['outbound_flights'], // For compatibility
              },
            };
          } else {
            // One-way response
            return {
              'success': true,
              'data': {
                ...responseData,
                'is_roundtrip': false,
              },
            };
          }
        } else {
          print('❌ API Error: ${data['errorCode']} - ${data['errorMessage']}');
          return {
            'success': false,
            'error': data['errorCode'] ?? 'API_ERROR',
            'message': data['errorMessage'] ?? 'Unknown error',
          };
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'error': 'HTTP_ERROR',
          'message': 'HTTP ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      // Handle network errors
      print('💥 Network/Connection Error: $e');
      if (e.toString().contains('Connection refused') || e.toString().contains('Failed host lookup')) {
        print('🚫 Backend không khả dụng tại: ${ApiConfig.baseUrl}');
        print('💡 Hãy kiểm tra:');
        print('   - Backend server có đang chạy không?');
        print('   - URL có đúng không? ${ApiConfig.baseUrl}');
        print('   - Port 3000 có mở không?');
      }
      return {
        'success': false,
        'error': 'Network Error',
        'message': e.toString(),
      };
    }
  }
  
  /// Transform app search params to API format
  static Map<String, dynamic> _transformSearchParams(Map<String, dynamic> appParams) {
    final passengers = appParams['passengers'] ?? {'adults': 1, 'children': 0, 'infants': 0};
    final bool isRoundTrip = appParams['return_date'] != null && appParams['return_date'].toString().isNotEmpty;
    
    Map<String, dynamic> apiParams = {
      'departure_airport_code': appParams['from_airport'] ?? appParams['departure_airport_code'] ?? 'HAN',
      'arrival_airport_code': appParams['to_airport'] ?? appParams['arrival_airport_code'] ?? 'SGN',
      'departure_date': appParams['departure_date'] ?? '01/08/2025',
      'airline_ids': _convertToIntArray(appParams['airline_ids']),
      'flight_class': appParams['flight_class'] ?? 'economy',
      'page': appParams['page'] ?? 1,
      'limit': appParams['limit'] ?? 50,
      'sort_by': appParams['sort_by'] ?? 'price',
      'sort_order': appParams['sort_order'] ?? 'asc',
    };
    
    // Handle passengers - API expects different format for roundtrip
    if (isRoundTrip) {
      // Roundtrip uses 'passengers' object
      apiParams['passengers'] = {
        'adults': passengers['adults'] ?? 1,
        'children': passengers['children'] ?? 0,
        'infants': passengers['infants'] ?? 0,  // Note: 'infants' for roundtrip
      };
      apiParams['return_date'] = appParams['return_date'];
    } else {
      // One-way uses 'passenger' object with 'infant' (singular)
      apiParams['passenger'] = {
        'adults': passengers['adults'] ?? 1,
        'children': passengers['children'] ?? 0,
        'infant': passengers['infants'] ?? 0,  // Note: 'infant' (singular) for one-way
      };
    }
    
    return apiParams;
  }

  /// Convert airline_ids to array of integers
  static List<int> _convertToIntArray(dynamic airlineIds) {
    print('🔍 Converting airline_ids: $airlineIds (type: ${airlineIds.runtimeType})');
    
    if (airlineIds == null) return [];
    
    if (airlineIds is List) {
      final result = airlineIds.map((id) {
        print('  Converting id: $id (type: ${id.runtimeType})');
        if (id is int) return id;
        if (id is String) {
          final parsed = int.tryParse(id);
          print('  Parsed: $parsed');
          return parsed ?? 0;
        }
        return 0;
      }).where((id) => id > 0).toList();
      
      print('✅ Final airline_ids: $result');
      return result;
    }
    
    return [];
  }
  
  /// Get flight details by ID
  static Future<Map<String, dynamic>> getFlightDetails(String flightId) async {
    try {
      // Check if using mock data
      if (ApiConfig.useMockData) {
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'data': {
            'id': flightId,
            'airline': 'Vietnam Airlines',
            'flight_number': 'VN214',
            'departure_time': '08:30',
            'arrival_time': '10:00',
            'duration': '1h 30m',
            'price': 1250000,
          }
        };
      }
      
      final String endpoint = '${ApiConfig.baseUrl}${ApiConfig.flightDetails.replaceAll('{id}', flightId)}';
      
      final response = await http.get(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.requestTimeout);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'error': 'API Error: ${response.statusCode}',
          'message': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network Error',
        'message': e.toString(),
      };
    }
  }
  
  /*
  /// Generate mock data for development (remove when API is ready)
  static Map<String, dynamic> _generateMockData(Map<String, dynamic> apiParams) {
    final String departureDate = apiParams['departure_date'] ?? '01/08/2025';
    final String? returnDate = apiParams['return_date'];
    final String fromAirport = apiParams['departure_airport_code'] ?? 'HAN';
    final String toAirport = apiParams['arrival_airport_code'] ?? 'SGN';
    
    // Check if this is a roundtrip search
    if (returnDate != null) {
      // Return roundtrip mock data
      return SampleData.generateRoundtripSearchResponse(
        fromAirport, 
        toAirport, 
        departureDate, 
        returnDate
      )['data'];
    } else {
      // Return one-way mock data
      return SampleData.generateOneWaySearchResponse(
        fromAirport, 
        toAirport, 
        departureDate
      )['data'];
    }
  }

  /// Mock search flights for development (remove when API is ready)
  static Future<Map<String, dynamic>> mockSearchFlights(Map<String, dynamic> searchParams) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Transform params to API format for consistency
    final apiParams = _transformSearchParams(searchParams);
    
    return {
      'success': true,
      'data': _generateMockData(apiParams),
    };
  }
  */
}
