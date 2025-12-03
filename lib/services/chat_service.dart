import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message.dart';
import 'auth_service.dart';

/// Service for handling chat operations with Supabase
class ChatService {
  final SupabaseClient supabase = Supabase.instance.client;
  final AuthService _authService = AuthService();

  /// Get all messages from Supabase (one-time fetch)
  Future<List<Message>> getMessages() async {
    try {
      final response = await supabase
          .from('messages')
          .select()
          .order('created_at', ascending: false)
          .limit(50);

      // Convert Supabase response to Message objects
      return (response as List)
          .map((json) => Message.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error fetching messages: $e');
      rethrow;
    }
  }

  /// Get messages as a real-time stream
  /// Messages update automatically when new ones are added
  Stream<List<Message>> getMessagesStream() {
    try {
      return supabase
          .from('messages')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false)
          .limit(50)
          .map((data) {
        // Convert Supabase response to Message objects
        return data
            .map((json) => Message.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      });
    } catch (e) {
      print('❌ Error creating messages stream: $e');
      rethrow;
    }
  }

  /// Send a message to Supabase
  /// Uses authenticated user's information
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }

    // Check if user is authenticated
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to send messages');
    }

    // Get user info from auth service
    final userName = _authService.getUserName() ?? 'Unknown User';
    final userAvatarUrl = _authService.getUserAvatarUrl();

    try {
      await supabase.from('messages').insert({
        'text': text.trim(),
        'user_id': user.id,
        'user_name': userName,
        'user_avatar_url': userAvatarUrl,
      });

      print('✅ Message sent successfully!');
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }
}

