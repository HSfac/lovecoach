enum MessageType {
  user,
  ai,
}

enum ConsultationCategory {
  flirting('썸'),
  dating('연애중'),
  breakup('이별후'),
  reconciliation('재회');

  const ConsultationCategory(this.displayName);
  final String displayName;
}

class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final ConsultationCategory category;
  final String userId;
  final String sessionId;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.category,
    required this.userId,
    required this.sessionId,
  });

  factory ChatMessage.fromFirestore(Map<String, dynamic> data, String id) {
    return ChatMessage(
      id: id,
      content: data['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.user,
      ),
      timestamp: data['timestamp']?.toDate() ?? DateTime.now(),
      category: ConsultationCategory.values.firstWhere(
        (e) => e.name == data['category'],
        orElse: () => ConsultationCategory.flirting,
      ),
      userId: data['userId'] ?? '',
      sessionId: data['sessionId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'type': type.name,
      'timestamp': timestamp,
      'category': category.name,
      'userId': userId,
      'sessionId': sessionId,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    ConsultationCategory? category,
    String? userId,
    String? sessionId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}