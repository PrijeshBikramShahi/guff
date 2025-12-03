/// Chat user model representing a user in the app
class ChatUser {
  final String id;
  final String? displayName;
  final String? avatarUrl;
  final String? email;
  final DateTime createdAt;

  ChatUser({
    required this.id,
    this.displayName,
    this.avatarUrl,
    this.email,
    required this.createdAt,
  });

  /// Create ChatUser from Supabase JSON response
  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert ChatUser to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get display name or fallback to email
  String get name => displayName ?? email ?? 'Unknown User';

  /// Get initials for avatar
  String get initials {
    final name = displayName ?? email ?? 'U';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  String toString() {
    return 'ChatUser(id: $id, name: $name)';
  }
}

