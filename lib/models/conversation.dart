/// Conversation model representing a DM chat room between two users
class Conversation {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create Conversation from Supabase JSON response
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert Conversation to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Get the other user's ID (the one who is not the current user)
  String getOtherUserId(String currentUserId) {
    if (user1Id == currentUserId) {
      return user2Id;
    }
    return user1Id;
  }

  /// Check if a user is part of this conversation
  bool containsUser(String userId) {
    return user1Id == userId || user2Id == userId;
  }

  @override
  String toString() {
    return 'Conversation(id: $id, user1: $user1Id, user2: $user2Id)';
  }
}

