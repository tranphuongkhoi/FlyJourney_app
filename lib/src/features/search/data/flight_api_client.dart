import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fly_journey/src/core/config/api_config.dart';

class FlightApiException implements Exception {
  final String message;
  final int? statusCode;

  const FlightApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'FlightApiException: $message${statusCode != null ? ' (HTTP ${statusCode.toString()})' : ''}';
}

class FlightApiClient {
  final http.Client _httpClient;

  FlightApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final response = await _httpClient
          .get(Uri.parse('${ApiConfig.baseUrl}$path'), headers: ApiConfig.headers)
          .timeout(ApiConfig.requestTimeout);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      throw FlightApiException('Request failed', statusCode: response.statusCode);
    } catch (e) {
      throw FlightApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('${ApiConfig.baseUrl}$path'),
            headers: ApiConfig.headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.requestTimeout);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      throw FlightApiException('Request failed', statusCode: response.statusCode);
    } catch (e) {
      throw FlightApiException(e.toString());
    }
  }
}
