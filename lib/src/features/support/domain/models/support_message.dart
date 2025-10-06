class SupportMessage {
  final String id;
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final SupportMessageStatus status;

  const SupportMessage({
    required this.id,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.status = SupportMessageStatus.sent,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      isFromUser: json['is_from_user'] as bool? ?? false,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      status: SupportMessageStatus.values.firstWhere(
        (status) => status.name == (json['status'] as String? ?? 'sent'),
        orElse: () => SupportMessageStatus.sent,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'is_from_user': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
    };
  }

  SupportMessage copyWith({
    String? id,
    String? text,
    bool? isFromUser,
    DateTime? timestamp,
    SupportMessageStatus? status,
  }) {
    return SupportMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

enum SupportMessageStatus {
  sending,
  sent,
  delivered,
  read,
}

class SupportChatSession {
  final String sessionId;
  final String userId;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final bool isActive;
  final List<SupportMessage> messages;

  const SupportChatSession({
    required this.sessionId,
    required this.userId,
    required this.createdAt,
    this.lastMessageAt,
    this.isActive = true,
    this.messages = const [],
  });

  factory SupportChatSession.fromJson(Map<String, dynamic> json) {
    final messagesList = (json['messages'] as List<dynamic>? ?? [])
        .map<SupportMessage>((json) => SupportMessage.fromJson(json as Map<String, dynamic>))
        .toList();
    
    return SupportChatSession(
      sessionId: json['session_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      lastMessageAt: json['last_message_at'] != null 
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      messages: messagesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'last_message_at': lastMessageAt?.toIso8601String(),
      'is_active': isActive,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  SupportChatSession copyWith({
    String? sessionId,
    String? userId,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    bool? isActive,
    List<SupportMessage>? messages,
  }) {
    return SupportChatSession(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      isActive: isActive ?? this.isActive,
      messages: messages ?? this.messages,
    );
  }
}

