import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/chat_user.dart';

/// Screen for editing user profile
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  bool _isLoading = false;
  ChatUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _userService.getCurrentUserProfile();
      if (mounted) {
        setState(() {
          _currentUser = user;
          _displayNameController.text = user?.displayName ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _userService.updateProfile(
        displayName: _displayNameController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload profile to show updated data
        _loadUserProfile();
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
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
        title: const Text('Edit Profile'),
      ),
      body: _isLoading && _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    // Avatar Section
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: _currentUser?.avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      _currentUser!.avatarUrl!,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Text(
                                        _currentUser?.initials ?? 'U',
                                        style: const TextStyle(fontSize: 36),
                                      ),
                                    ),
                                  )
                                : Text(
                                    _currentUser?.initials ?? 'U',
                                    style: const TextStyle(fontSize: 36),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _currentUser?.email ?? 'No email',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Implement avatar upload
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Avatar upload coming soon!'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Change Avatar'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Display Name Field
                    TextFormField(
                      controller: _displayNameController,
                      decoration: const InputDecoration(
                        labelText: 'Display Name',
                        hintText: 'Enter your display name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a display name';
                        }
                        if (value.trim().length < 2) {
                          return 'Display name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Save Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Account Info Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Information',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            _InfoRow(
                              label: 'Email',
                              value: _currentUser?.email ?? 'Not available',
                            ),
                            const Divider(),
                            _InfoRow(
                              label: 'User ID',
                              value: _currentUser?.id ?? 'Not available',
                              isMonospace: true,
                            ),
                            const Divider(),
                            _InfoRow(
                              label: 'Member since',
                              value: _currentUser != null
                                  ? _formatDate(_currentUser!.createdAt)
                                  : 'Not available',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }
}

/// Widget for displaying info row
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isMonospace;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isMonospace = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontFamily: isMonospace ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }
}

