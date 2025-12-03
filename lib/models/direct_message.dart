/// Direct message model representing a message in a conversation
class DirectMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final DateTime? readAt;

  DirectMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.readAt,
  });

  /// Create DirectMessage from Supabase JSON response
  factory DirectMessage.fromJson(Map<String, dynamic> json) {
    return DirectMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
    );
  }

  /// Convert DirectMessage to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Check if message was sent by current user
  bool isSentBy(String userId) {
    return senderId == userId;
  }

  /// Check if message has been read
  bool get isRead => readAt != null;

  @override
  String toString() {
    return 'DirectMessage(id: $id, conversation: $conversationId, sender: $senderId, text: $text)';
  }
}

