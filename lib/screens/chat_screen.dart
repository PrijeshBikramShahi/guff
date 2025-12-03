import 'package:flutter/material.dart';
import '../models/direct_message.dart';
import '../models/chat_user.dart';
import '../services/conversation_service.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import 'conversations_list_screen.dart';

/// Chat screen for direct messaging in a conversation
class ChatScreen extends StatefulWidget {
  final String conversationId;

  const ChatScreen({
    super.key,
    required this.conversationId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ConversationService _conversationService = ConversationService();
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  final TextEditingController _messageController = TextEditingController();
  ChatUser? _otherUser;

  @override
  void initState() {
    super.initState();
    _loadOtherUser();
  }

  Future<void> _loadOtherUser() async {
    try {
      final conversations = await _conversationService.getAllConversations();
      final conversation = conversations.firstWhere(
        (c) => c.id == widget.conversationId,
      );
      final currentUserId = _authService.currentUser?.id ?? '';
      final otherUserId = conversation.getOtherUserId(currentUserId);
      final user = await _userService.getUserById(otherUserId);
      if (mounted) {
        setState(() {
          _otherUser = user;
        });
      }
    } catch (e) {
      print('❌ Error loading other user: $e');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    try {
      await _conversationService.sendMessage(widget.conversationId, text);
    } catch (e) {
      print('❌ Error sending message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
        _messageController.text = text;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (_otherUser != null) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: _otherUser!.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          _otherUser!.avatarUrl!,
                          errorBuilder: (context, error, stackTrace) =>
                              Text(_otherUser!.initials),
                        ),
                      )
                    : Text(
                        _otherUser!.initials,
                        style: const TextStyle(fontSize: 12),
                      ),
              ),
              const SizedBox(width: 8),
            ],
            Text(_otherUser?.name ?? 'Loading...'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ConversationsListScreen(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Messages List with Real-time Stream
          Expanded(
            child: StreamBuilder<List<DirectMessage>>(
              stream: _conversationService.getMessagesStream(widget.conversationId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading messages: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet.\nSend a message to get started!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final messages = snapshot.data!;
                final currentUserId = _authService.currentUser?.id ?? '';

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSentByMe = message.isSentBy(currentUserId);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        mainAxisAlignment:
                            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isSentByMe) ...[
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.grey.shade300,
                              child: _otherUser != null && _otherUser!.avatarUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        _otherUser!.avatarUrl!,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Text(_otherUser!.initials),
                                      ),
                                    )
                                  : Text(
                                      _otherUser?.initials ?? 'U',
                                      style: const TextStyle(fontSize: 10),
                                    ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isSentByMe
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isSentByMe ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          if (isSentByMe) ...[
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                _authService.getUserName()?[0].toUpperCase() ?? 'U',
                                style: const TextStyle(fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
