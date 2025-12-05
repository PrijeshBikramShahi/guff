import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_user.dart';

/// Service for managing users
class UserService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Get all users (excluding current user)
  Future<List<ChatUser>> getAllUsers() async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final response = await supabase
          .from('users')
          .select()
          .neq('id', currentUserId)
          .order('last_seen', ascending: false, nullsFirst: false)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ChatUser.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      print('❌ Error fetching users: $e');
      rethrow;
    }
  }

  /// Get user by ID
  Future<ChatUser?> getUserById(String userId) async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return ChatUser.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      print('❌ Error fetching user: $e');
      return null;
    }
  }

  /// Get current user's profile
  Future<ChatUser?> getCurrentUserProfile() async {
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) return null;
    return getUserById(currentUserId);
  }

  /// Update current user's profile
  Future<void> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (displayName != null) {
        updates['display_name'] = displayName;
      }
      if (avatarUrl != null) {
        updates['avatar_url'] = avatarUrl;
      }

      await supabase
          .from('users')
          .update(updates)
          .eq('id', currentUserId);

      print('✅ Profile updated successfully');
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }

  /// Update user's last seen timestamp (call this periodically)
  Future<void> updateLastSeen() async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return; // Not authenticated, silently fail
      }

      await supabase
          .from('users')
          .update({'last_seen': DateTime.now().toIso8601String()})
          .eq('id', currentUserId);
    } catch (e) {
      print('❌ Error updating last seen: $e');
      // Don't throw - this is a background operation
    }
  }
}

