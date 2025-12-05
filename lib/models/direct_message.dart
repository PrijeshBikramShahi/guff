/// Direct message model representing a message in a conversation
class DirectMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final DateTime? readAt;
  final String messageType; // 'text', 'image', 'file'
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;

  DirectMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.readAt,
    this.messageType = 'text',
    this.fileUrl,
    this.fileName,
    this.fileSize,
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
      messageType: json['message_type'] as String? ?? 'text',
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
      fileSize: json['file_size'] != null ? json['file_size'] as int : null,
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

  /// Check if message is an image
  bool get isImage => messageType == 'image' && fileUrl != null;

  /// Check if message is a file
  bool get isFile => messageType == 'file' && fileUrl != null;

  @override
  String toString() {
    return 'DirectMessage(id: $id, conversation: $conversationId, sender: $senderId, text: $text)';
  }
}

