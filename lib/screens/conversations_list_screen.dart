import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../models/direct_message.dart';
import '../models/chat_user.dart';
import '../services/conversation_service.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import 'chat_screen.dart';
import 'users_list_screen.dart';

/// Screen showing list of all conversations (DMs)
class ConversationsListScreen extends StatefulWidget {
  const ConversationsListScreen({super.key});

  @override
  State<ConversationsListScreen> createState() => _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen> {
  final ConversationService _conversationService = ConversationService();
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              try {
                await _authService.signOut();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Conversation>>(
        stream: Stream.periodic(const Duration(seconds: 2))
            .asyncMap((_) => _conversationService.getAllConversations()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final conversations = snapshot.data ?? [];

          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No conversations yet.\nStart a new chat!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return _ConversationListItem(
                conversation: conversation,
                conversationService: _conversationService,
                userService: _userService,
                authService: _authService,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(conversationId: conversation.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UsersListScreen(),
            ),
          );
        },
        child: const Icon(Icons.chat),
        tooltip: 'New chat',
      ),
    );
  }
}

/// Widget for a single conversation list item
class _ConversationListItem extends StatelessWidget {
  final Conversation conversation;
  final ConversationService conversationService;
  final UserService userService;
  final AuthService authService;
  final VoidCallback onTap;

  const _ConversationListItem({
    required this.conversation,
    required this.conversationService,
    required this.userService,
    required this.authService,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = authService.currentUser?.id ?? '';
    final otherUserId = conversation.getOtherUserId(currentUserId);

    return FutureBuilder<ChatUser?>(
      future: userService.getUserById(otherUserId),
      builder: (context, userSnapshot) {
        final user = userSnapshot.data;
        final userName = user?.name ?? 'Unknown User';

        return FutureBuilder<DirectMessage?>(
          future: conversationService.getLastMessage(conversation.id),
          builder: (context, messageSnapshot) {
            final lastMessage = messageSnapshot.data;
            final preview = lastMessage?.text ?? 'No messages yet';

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: user?.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          user!.avatarUrl!,
                          errorBuilder: (context, error, stackTrace) =>
                              Text(user.initials),
                        ),
                      )
                    : Text(user?.initials ?? 'U'),
              ),
              title: Text(userName),
              subtitle: Text(
                preview,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: lastMessage != null
                  ? Text(
                      _formatTime(lastMessage.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  : null,
              onTap: onTap,
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}

