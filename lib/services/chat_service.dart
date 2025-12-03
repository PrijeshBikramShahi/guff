import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message.dart';

/// Service for handling chat operations with Supabase
class ChatService {
  final SupabaseClient supabase = Supabase.instance.client;

  // For now, we'll use a hardcoded user ID for testing
  // This will be replaced with real authentication in Step 12
  static const String _hardcodedUserId = '00000000-0000-0000-0000-000000000000';
  static const String _hardcodedUserName = 'Test User';

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
  /// Uses hardcoded user for now (will use real user in Step 12)
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }

    try {
      await supabase.from('messages').insert({
        'text': text.trim(),
        'user_id': _hardcodedUserId,
        'user_name': _hardcodedUserName,
        'user_avatar_url': null, // Will add avatar in Step 13
      });

      print('✅ Message sent successfully!');
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }
}

