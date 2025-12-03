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
                leading: CircleAvatar(
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
                title: Text(user.name),
                subtitle: user.email != null ? Text(user.email!) : null,
                onTap: () => _startConversation(user),
              );
            },
          );
        },
      ),
    );
  }
}

