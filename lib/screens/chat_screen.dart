import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/direct_message.dart';
import '../models/chat_user.dart';
import '../services/conversation_service.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../services/typing_service.dart';
import '../utils/time_formatter.dart';
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
  final TypingService _typingService = TypingService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChatUser? _otherUser;
  bool _isOtherUserTyping = false;
  Timer? _typingDebounceTimer;
  String? _selectedMessageId; // Track which message is showing timestamp

  @override
  void initState() {
    super.initState();
    _loadOtherUser();
    _setupTypingIndicator();
    // Mark conversation as read when opening
    _markAsRead();
    // Scroll to bottom after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _setupTypingIndicator() {
    // Listen to typing status
    _typingService.getTypingStream(widget.conversationId).listen((typingUserId) {
      if (mounted) {
        setState(() {
          _isOtherUserTyping = typingUserId != null;
        });
      }
    });
  }

  Future<void> _markAsRead() async {
    try {
      await _conversationService.markConversationAsRead(widget.conversationId);
    } catch (e) {
      print('❌ Error marking as read: $e');
    }
  }

  @override
  void dispose() {
    _typingService.setTyping(widget.conversationId, false);
    _typingService.dispose();
    _typingDebounceTimer?.cancel();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0, // reverse: true means 0 is bottom
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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


  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Stop typing indicator
    await _typingService.setTyping(widget.conversationId, false);
    _messageController.clear();

    try {
      await _conversationService.sendMessage(widget.conversationId, text);
      // Scroll to bottom after sending
      _scrollToBottom();
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

  Future<void> _pickAndSendImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      if (mounted) {
        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 16),
                Text('Uploading image...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );
      }

      await _conversationService.sendImage(widget.conversationId, image.path);

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _scrollToBottom();
      }
    } catch (e) {
      print('❌ Error picking/sending image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onTextChanged(String text) {
    // Cancel previous timer
    _typingDebounceTimer?.cancel();

    // Set typing to true immediately
    _typingService.setTyping(widget.conversationId, true);

    // If text is empty, stop typing
    if (text.trim().isEmpty) {
      _typingService.setTyping(widget.conversationId, false);
      return;
    }

    // Set typing to false after 1 second of no typing
    _typingDebounceTimer = Timer(const Duration(seconds: 1), () {
      _typingService.setTyping(widget.conversationId, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (_otherUser != null) ...[
              Stack(
                children: [
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
                  // Online status indicator
                  if (_otherUser!.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
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
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_otherUser?.name ?? 'Loading...'),
                  if (_otherUser != null)
                    Text(
                      _otherUser!.isOnline ? 'Online' : _otherUser!.lastSeenText,
                      style: TextStyle(
                        fontSize: 12,
                        color: _otherUser!.isOnline ? Colors.green : Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
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

                // Scroll to bottom when new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSentByMe = message.isSentBy(currentUserId);

                    // Check if we should show timestamp (first message or time gap > 5 min)
                    final showTimestamp = index == messages.length - 1 ||
                        !TimeFormatter.shouldGroupMessages(
                          message.createdAt,
                          messages[index + 1].createdAt,
                        );

                    final isSelected = _selectedMessageId == message.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment:
                            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isSentByMe) ...[
                            Column(
                              children: [
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
                                // Relative timestamp below avatar (e.g., "1h ago")
                                if (showTimestamp)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      TimeFormatter.formatRelative(message.createdAt),
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Column(
                              crossAxisAlignment: isSentByMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                    // Image message or text message (tappable to show timestamp)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // Toggle timestamp visibility
                                          _selectedMessageId = _selectedMessageId == message.id
                                              ? null
                                              : message.id;
                                        });
                                      },
                                      child: message.isImage
                                          ? Container(
                                              constraints: const BoxConstraints(
                                                maxWidth: 250,
                                                maxHeight: 300,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isSentByMe
                                                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                                    : Colors.grey.shade200,
                                                borderRadius: BorderRadius.circular(16.0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: Image.network(
                                                  message.fileUrl!,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return Container(
                                                      width: 250,
                                                      height: 300,
                                                      color: Colors.grey.shade200,
                                                      child: Center(
                                                        child: CircularProgressIndicator(
                                                          value: loadingProgress.expectedTotalBytes != null
                                                              ? loadingProgress.cumulativeBytesLoaded /
                                                                  loadingProgress.expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      width: 250,
                                                      height: 200,
                                                      color: Colors.grey.shade300,
                                                      child: const Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                                          SizedBox(height: 8),
                                                          Text('Failed to load image', style: TextStyle(color: Colors.grey)),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            )
                                          : Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 8.0,
                                              ),
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
                                    // Time and read receipt (only shown when message is tapped)
                                    if (isSelected)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              TimeFormatter.formatTime(message.createdAt),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                            // Read receipt (only for sent messages)
                                            if (isSentByMe) ...[
                                              const SizedBox(width: 4),
                                              Icon(
                                                message.isRead
                                                    ? Icons.done_all
                                                    : Icons.done,
                                                size: 12,
                                                color: message.isRead
                                                    ? Colors.blue
                                                    : Colors.grey.shade500,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          if (isSentByMe) ...[
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  child: Text(
                                    _authService.getUserName()?[0].toUpperCase() ?? 'U',
                                    style: const TextStyle(fontSize: 10, color: Colors.white),
                                  ),
                                ),
                                // Relative timestamp below avatar (e.g., "1h ago")
                                if (showTimestamp)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      TimeFormatter.formatRelative(message.createdAt),
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                              ],
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

          // Typing Indicator
          if (_isOtherUserTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
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
                            style: const TextStyle(fontSize: 8),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_otherUser?.name ?? 'User'} is typing',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(3, (index) {
                              return TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInOut,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: 0.3 + ((value + (index * 0.2)) % 1.0 * 0.7),
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade600,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                      onChanged: _onTextChanged,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Image picker button
                  IconButton(
                    onPressed: _pickAndSendImage,
                    icon: const Icon(Icons.image),
                    tooltip: 'Send image',
                    style: IconButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  // Send button
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
