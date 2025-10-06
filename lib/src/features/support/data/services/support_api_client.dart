import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fly_journey/src/core/config/api_config.dart';

class SupportApiException implements Exception {
  final String message;
  final int? statusCode;

  const SupportApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'SupportApiException: $message${statusCode != null ? ' (HTTP ${statusCode.toString()})' : ''}';
}

class SupportApiClient {
  final http.Client _httpClient;

  SupportApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  /// Get or create a support chat session for the user
  Future<Map<String, dynamic>> getOrCreateSession(String userId) async {
    try {
      final response = await _httpClient
          .get(
            Uri.parse('${ApiConfig.baseUrl}/support/session/$userId'),
            headers: _getAuthHeaders(),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      throw SupportApiException(
        'Failed to get/create session',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SupportApiException) rethrow;
      throw SupportApiException(e.toString());
    }
  }

  /// Send a message in the support chat
  Future<Map<String, dynamic>> sendMessage({
    required String sessionId,
    required String text,
    required String userId,
  }) async {
    try {
      final body = {
        'session_id': sessionId,
        'message': text,
        'user_id': userId,
        'is_from_user': true,
      };

      final response = await _httpClient
          .post(
            Uri.parse('${ApiConfig.baseUrl}/support/message'),
            headers: _getAuthHeaders(),
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      throw SupportApiException(
        'Failed to send message',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SupportApiException) rethrow;
      throw SupportApiException(e.toString());
    }
  }

  /// Get all messages for a specific session
  Future<Map<String, dynamic>> getSessionMessages(String sessionId) async {
    try {
      final response = await _httpClient
          .get(
            Uri.parse('${ApiConfig.baseUrl}/support/session/$sessionId/messages'),
            headers: _getAuthHeaders(),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      throw SupportApiException(
        'Failed to get messages',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SupportApiException) rethrow;
      throw SupportApiException(e.toString());
    }
  }

  /// Close support session
  Future<Map<String, dynamic>> closeSession(String sessionId) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('${ApiConfig.baseUrl}/support/session/$sessionId/close'),
            headers: _getAuthHeaders(),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      throw SupportApiException(
        'Failed to close session',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SupportApiException) rethrow;
      throw SupportApiException(e.toString());
    }
  }

  /// Check if support team is online
  Future<Map<String, dynamic>> checkSupportAvailability() async {
    try {
      final response = await _httpClient
          .get(
            Uri.parse('${ApiConfig.baseUrl}/support/availability'),
            headers: ApiConfig.headers,
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      throw SupportApiException(
        'Failed to check availability',
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SupportApiException) rethrow;
      throw SupportApiException(e.toString());
    }
  }

  /// Subscribe to real-time message updates (WebSocket or polling)
  Future<void> subscribeToMessageUpdates(
    String sessionId,
    Function(dynamic newMessage) onNewMessage,
  ) async {
    // TODO: Implement WebSocket or polling connection
    // This is a placeholder - you'll need to implement the actual WebSocket connection
    // or polling mechanism based on your backend setup
  }

  Map<String, String> _getAuthHeaders() {
    // TODO: Add actual auth headers when backend is ready
    // This should include Bearer token from AuthService
    return {
      ...ApiConfig.headers,
      // 'Authorization': 'Bearer ${AuthService().accessToken}',
    };
  }
}

