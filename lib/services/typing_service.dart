import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

/// Service for managing typing indicators
class TypingService {
  final SupabaseClient supabase = Supabase.instance.client;
  Timer? _typingTimer;

  /// Set typing status for current user in a conversation
  Future<void> setTyping(String conversationId, bool isTyping) async {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      // Upsert typing status
      await supabase.from('typing_indicators').upsert({
        'conversation_id': conversationId,
        'user_id': currentUserId,
        'is_typing': isTyping,
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Auto-clear typing status after 3 seconds if still typing
      if (isTyping) {
        _typingTimer?.cancel();
        _typingTimer = Timer(const Duration(seconds: 3), () {
          setTyping(conversationId, false);
        });
      } else {
        _typingTimer?.cancel();
      }
    } catch (e) {
      print('❌ Error setting typing status: $e');
    }
  }

  /// Get typing status stream for a conversation
  /// Returns the user ID of the person typing (if any)
  Stream<String?> getTypingStream(String conversationId) {
    try {
      final currentUserId = supabase.auth.currentUser?.id;
      if (currentUserId == null) {
        return Stream.value(null);
      }

      return supabase
          .from('typing_indicators')
          .stream(primaryKey: ['conversation_id', 'user_id'])
          .map((data) {
        // Find the user who is typing (not the current user)
        for (final row in data) {
          final rowConversationId = row['conversation_id'] as String;
          final userId = row['user_id'] as String;
          final isTyping = row['is_typing'] as bool? ?? false;
          
          if (rowConversationId == conversationId && 
              isTyping && 
              userId != currentUserId) {
            return userId;
          }
        }
        return null;
      });
    } catch (e) {
      print('❌ Error creating typing stream: $e');
      return Stream.value(null);
    }
  }

  /// Cleanup - call this when done
  void dispose() {
    _typingTimer?.cancel();
  }
}

