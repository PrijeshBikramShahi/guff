/// Chat user model representing a user in the app
class ChatUser {
  final String id;
  final String? displayName;
  final String? avatarUrl;
  final String? email;
  final DateTime createdAt;
  final DateTime? lastSeen;

  ChatUser({
    required this.id,
    this.displayName,
    this.avatarUrl,
    this.email,
    required this.createdAt,
    this.lastSeen,
  });

  /// Create ChatUser from Supabase JSON response
  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
          : null,
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

  /// Check if user is online (last seen within 2 minutes)
  /// More strict to avoid showing everyone as online
  bool get isOnline {
    if (lastSeen == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastSeen!);
    // Only show as online if last seen within 2 minutes (more strict)
    return difference.inMinutes < 2 && difference.inSeconds >= 0;
  }

  /// Get last seen text (e.g., "2m ago", "Online", "Offline")
  String get lastSeenText {
    if (isOnline) return 'Online';
    if (lastSeen == null) return 'Offline';
    
    final now = DateTime.now();
    final difference = now.difference(lastSeen!);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return 'Offline';
    }
  }

  @override
  String toString() {
    return 'ChatUser(id: $id, name: $name)';
  }
}

