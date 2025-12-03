import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/conversation.dart';
import '../models/direct_message.dart';

/// Service for managing conversations and direct messages
class ConversationService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Get all conversations for current user
  Future<List<Conversation>> getAllConversations() async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final response = await supabase
          .from('conversations')
          .select()
          .or('user1_id.eq.$currentUserId,user2_id.eq.$currentUserId')
          .order('updated_at', ascending: false);

      return (response as List)
          .map((json) => Conversation.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      print('❌ Error fetching conversations: $e');
      rethrow;
    }
  }

  /// Get or create a conversation between current user and another user
  Future<Conversation> getOrCreateConversation(String otherUserId) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      if (currentUserId == otherUserId) {
        throw Exception('Cannot create conversation with yourself');
      }

      // Ensure user1_id < user2_id for consistency (compare UUIDs as strings)
      final user1Id = currentUserId.compareTo(otherUserId) < 0 ? currentUserId : otherUserId;
      final user2Id = currentUserId.compareTo(otherUserId) < 0 ? otherUserId : currentUserId;

      // Try to find existing conversation
      final existingResponse = await supabase
          .from('conversations')
          .select()
          .eq('user1_id', user1Id)
          .eq('user2_id', user2Id)
          .maybeSingle();

      if (existingResponse != null) {
        return Conversation.fromJson(Map<String, dynamic>.from(existingResponse));
      }

      // Create new conversation
      final newResponse = await supabase
          .from('conversations')
          .insert({
            'user1_id': user1Id,
            'user2_id': user2Id,
          })
          .select()
          .single();

      print('✅ Conversation created');
      return Conversation.fromJson(Map<String, dynamic>.from(newResponse));
    } catch (e) {
      print('❌ Error getting/creating conversation: $e');
      rethrow;
    }
  }

  /// Get messages stream for a conversation (real-time)
  Stream<List<DirectMessage>> getMessagesStream(String conversationId) {
    try {
      return supabase
          .from('direct_messages')
          .stream(primaryKey: ['id'])
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false)
          .limit(50)
          .map((data) {
        return data
            .map((json) => DirectMessage.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      });
    } catch (e) {
      print('❌ Error creating messages stream: $e');
      rethrow;
    }
  }

  /// Send a message in a conversation
  Future<void> sendMessage(String conversationId, String text) async {
    if (text.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }

    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      await supabase.from('direct_messages').insert({
        'conversation_id': conversationId,
        'sender_id': currentUserId,
        'text': text.trim(),
      });

      print('✅ Message sent successfully');
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }

  /// Get the last message in a conversation (for preview)
  Future<DirectMessage?> getLastMessage(String conversationId) async {
    try {
      final response = await supabase
          .from('direct_messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return DirectMessage.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      print('❌ Error fetching last message: $e');
      return null;
    }
  }

  /// Mark all messages in a conversation as read
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Call the database function to mark messages as read
      await supabase.rpc('mark_messages_as_read', params: {
        'p_conversation_id': conversationId,
        'p_user_id': currentUserId,
      });

      print('✅ Messages marked as read');
    } catch (e) {
      print('❌ Error marking messages as read: $e');
      rethrow;
    }
  }

  /// Get unread message count for a conversation
  Future<int> getUnreadCount(String conversationId) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return 0;
      }

      final response = await supabase
          .from('direct_messages')
          .select('id')
          .eq('conversation_id', conversationId)
          .neq('sender_id', currentUserId) // Messages from other user
          .isFilter('read_at', null); // Not read yet

      return (response as List).length;
    } catch (e) {
      print('❌ Error getting unread count: $e');
      return 0;
    }
  }
}

