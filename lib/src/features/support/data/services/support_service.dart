import 'package:fly_journey/src/features/support/domain/models/support_message.dart';
import 'package:fly_journey/src/features/support/data/repositories/support_repository.dart';
import 'package:fly_journey/src/features/auth/data/services/auth_service.dart';

class SupportService {
  static final SupportService _instance = SupportService._internal();
  factory SupportService() => _instance;
  SupportService._internal();

  SupportChatSession? _currentSession;
  final AuthService _authService = AuthService();

  SupportChatSession? get currentSession => _currentSession;
  bool get isSessionActive => _currentSession?.isActive ?? false;

  /// Initialize support session for current user
  Future<SupportChatSession> initializeSession() async {
    if (!_authService.isLoggedIn || _authService.currentUser == null) {
      throw Exception('User must be logged in to start support session');
    }

    final userId = _authService.currentUser!.id;
    
    // TODO: Replace with actual API call
    _currentSession = await SupportRepository.getOrCreateSession(userId: userId);
    
    return _currentSession!;
  }

  /// Send a message through support chat
  Future<SupportMessage> sendMessage(String text) async {
    if (_currentSession == null || !_authService.isLoggedIn || _authService.currentUser == null) {
      throw Exception('Support session not initialized or user not logged in');
    }

    // TODO: Replace with actual API call
    final message = await SupportRepository.sendMessage(
      sessionId: _currentSession!.sessionId,
      text: text,
      userId: _authService.currentUser!.id,
    );

    // Add message to local session
    if (_currentSession != null) {
      final updatedMessages = List<SupportMessage>.from(_currentSession!.messages)..add(message);
      _currentSession = _currentSession!.copyWith(
        messages: updatedMessages,
        lastMessageAt: DateTime.now(),
      );
    }

    return message;
  }

  /// Get all messages from current session
  Future<List<SupportMessage>> getAllMessages() async {
    if (_currentSession == null) {
      throw Exception('Support session not initialized');
    }

    // TODO: Replace with actual API call
    return await SupportRepository.getSessionMessages(_currentSession!.sessionId);
  }

  /// Check if support team is available
  Future<bool> isSupportOnline() async {
    // TODO: Replace with actual API call
    return await SupportRepository.checkSupportAvailability();
  }

  /// Close current support session
  Future<void> closeSession() async {
    if (_currentSession != null) {
      // TODO: Replace with actual API call
      await SupportRepository.closeSession(_currentSession!.sessionId);
      _currentSession = null;
    }
  }

  /// Load session messages (for when reopening support)
  Future<void> loadSessionMessages() async {
    if (_currentSession != null) {
      final messages = await SupportRepository.getSessionMessages(_currentSession!.sessionId);
      
      _currentSession = _currentSession!.copyWith(messages: messages);
    }
  }

  /// Subscribe to real-time message updates
  void subscribeToUpdates(Function onNewMessage) {
    if (_currentSession?.sessionId != null) {
      SupportRepository.subscribeToMessageUpdates(
        _currentSession!.sessionId,
        (messages) {
          _currentSession = _currentSession!.copyWith(messages: messages);
          onNewMessage();
        },
      );
    }
  }

  /// Unsubscribe from real-time updates
  void unsubscribeFromUpdates() {
    SupportRepository.unsubscribeFromMessageUpdates();
  }

  /// Clear current session (for logout)
  void clearSession() {
    unsubscribeFromUpdates();
    _currentSession = null;
  }
}

