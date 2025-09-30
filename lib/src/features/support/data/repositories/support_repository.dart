import 'package:fly_journey/src/features/support/domain/models/support_message.dart';
import 'package:fly_journey/src/features/support/data/services/support_api_client.dart';

class SupportRepository {
  static final SupportApiClient _apiClient = SupportApiClient();

  /// Get or create support session for current user
  static Future<SupportChatSession> getOrCreateSession({required String userId}) async {
    try {
      // TODO: Replace with real API call when backend is ready
      final response = await _apiClient.getOrCreateSession(userId);
      
      if (response['status'] == true && response['data'] != null) {
        return SupportChatSession.fromJson(response['data'] as Map<String, dynamic>);
      } else {
        throw SupportApiException(
          response['error'] ?? response['message'] ?? 'Session creation failed',
        );
      }
    } catch (e) {
      if (e is SupportApiException) rethrow;
      throw SupportApiException(e.toString());
    }
  }

  /// Send a message in support chat
  static Future<SupportMessage> sendMessage({
    required String sessionId,
    required String text,
    required String userId,
  }) async {
    try {
      // TODO: Replace with real API call when backend is ready
      final response = await _apiClient.sendMessage(
        sessionId: sessionId,
        text: text,
        userId: userId,
      );

      if (response['status'] == true && response['data'] != null) {
        return SupportMessage.fromJson(response['data'] as Map<String, dynamic>);
      } else {
        throw SupportApiException(
          response['error'] ?? response['message'] ?? 'Failed to send message',
        );
      }
    } catch (e) {
      if (e is SupportApiException) rethrow;
      throw SupportApiException(e.toString());
    }
  }

  /// Get all messages for a support session
  static Future<List<SupportMessage>> getSessionMessages(String sessionId) async {
    try {
      // TODO: Replace with real API call when backend is ready
      final response = await _apiClient.getSessionMessages(sessionId);

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> messagesList = response['data']['messages'] as List<dynamic>;
        return messagesList
            .map((json) => SupportMessage.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw SupportApiException(
          response['error'] ?? response['message'] ?? 'Failed to get messages',
        );
      }
    } catch (e) {
      if (e is SupportApiException) rethrow;
      throw SupportApiException(e.toString());
    }
  }

  /// Check if support is available
  static Future<bool> checkSupportAvailability() async {
    try {
      // TODO: Replace with real API call when backend is ready
      final response = await _apiClient.checkSupportAvailability();

      if (response['status'] == true && response['data'] != null) {
        return response['data']['is_online'] as bool? ?? false;
      } else {
        return false; // Default to offline if API call fails
      }
    } catch (e) {
      return false; // Default to offline on any error
    }
  }

  /// Close support session
  static Future<void> closeSession(String sessionId) async {
    try {
      // TODO: Replace with real API call when backend is ready
      await _apiClient.closeSession(sessionId);
    } catch (e) {
      // Silently handle close session errors - not critical
      print('Failed to close support session: $e');
    }
  }

  /// Subscribe to real-time updates (for when backend implements WebSocket)
  static void subscribeToMessageUpdates(
    String sessionId,
    Function(List<SupportMessage> messages) onMessagesUpdate,
  ) {
    // TODO: Implement WebSocket subscription when backend is ready
    _apiClient.subscribeToMessageUpdates(
      sessionId,
      (newMessageData) {
        // TODO: Parse and handle incoming messages
        // This will be implemented when WebSocket connection is established
      },
    );
  }

  /// Unsubscribe from real-time updates
  static void unsubscribeFromMessageUpdates() {
    // TODO: Implement WebSocket disconnection
    // This will be implemented when WebSocket connection is established
  }
}

