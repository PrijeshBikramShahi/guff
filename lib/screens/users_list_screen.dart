import 'package:flutter/material.dart';
import '../models/chat_user.dart';
import '../services/user_service.dart';
import '../services/conversation_service.dart';
import 'chat_screen.dart';

/// Screen showing list of all users to start a new conversation
class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final UserService _userService = UserService();
  final ConversationService _conversationService = ConversationService();
  bool _isLoading = false;

  Future<void> _startConversation(ChatUser user) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get or create conversation
      final conversation = await _conversationService.getOrCreateConversation(user.id);

      if (mounted) {
        // Navigate to chat screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(conversationId: conversation.id),
          ),
        );
      }
    } catch (e) {
      print('❌ Error starting conversation: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: FutureBuilder<List<ChatUser>>(
        future: _userService.getAllUsers(),
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
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(
              child: Text(
                'No other users found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: user.avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                user.avatarUrl!,
                                errorBuilder: (context, error, stackTrace) =>
                                    Text(user.initials),
                              ),
                            )
                          : Text(user.initials),
                    ),
                    // Online status indicator
                    if (user.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                title: Text(user.name),
                subtitle: Row(
                  children: [
                    if (user.isOnline)
                      Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      )
                    else
                      Text(
                        user.lastSeenText,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    if (user.email != null && !user.isOnline) ...[
                      const Text(' • ', style: TextStyle(color: Colors.grey)),
                      Expanded(
                        child: Text(
                          user.email!,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                onTap: () => _startConversation(user),
              );
            },
          );
        },
      ),
    );
  }
}

