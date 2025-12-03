import 'package:supabase_flutter/supabase_flutter.dart';

/// App user model representing an authenticated user
class AppUser {
  final String id;
  final String? email;
  final String? name;
  final String? avatarUrl;

  AppUser({
    required this.id,
    this.email,
    this.name,
    this.avatarUrl,
  });

  /// Create AppUser from Supabase User
  factory AppUser.fromSupabaseUser(User user) {
    return AppUser(
      id: user.id,
      email: user.email,
      name: user.userMetadata?['full_name'] as String? ??
          user.userMetadata?['name'] as String? ??
          user.email,
      avatarUrl: user.userMetadata?['avatar_url'] as String? ??
          user.userMetadata?['picture'] as String?,
    );
  }

  @override
  String toString() {
    return 'AppUser(id: $id, email: $email, name: $name)';
  }
}

