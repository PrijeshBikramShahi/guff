/// Message model representing a chat message
class Message {
  final String id;
  final String text;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.text,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.createdAt,
  });

  /// Create a Message from Supabase JSON response
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      text: json['text'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userAvatarUrl: json['user_avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert Message to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'user_id': userId,
      'user_name': userName,
      'user_avatar_url': userAvatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Create a Message from Supabase response (alias for fromJson)
  factory Message.fromSupabase(Map<String, dynamic> json) {
    return Message.fromJson(json);
  }

  @override
  String toString() {
    return 'Message(id: $id, text: $text, userId: $userId, userName: $userName, createdAt: $createdAt)';
  }
}

