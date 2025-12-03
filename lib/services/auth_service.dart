import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/app_user.dart';

/// Service for handling authentication with Supabase
class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Get current authenticated user
  User? get currentUser => supabase.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => supabase.auth.currentUser != null;

  /// Stream of authentication state changes
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  /// Sign up with email and password
  /// Note: Email confirmation is disabled, so user is signed in immediately
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await supabase.auth.signUp(
        email: email.trim(),
        password: password,
      );
      print('✅ Sign up successful! User signed in.');
    } catch (e) {
      print('❌ Error signing up: $e');
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      print('✅ Sign in successful!');
    } catch (e) {
      print('❌ Error signing in: $e');
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      print('✅ Signed out successfully');
    } catch (e) {
      print('❌ Error signing out: $e');
      rethrow;
    }
  }

  /// Get current user as AppUser
  AppUser? getCurrentAppUser() {
    final user = currentUser;
    if (user == null) return null;
    return AppUser.fromSupabaseUser(user);
  }

  /// Get user name from current user
  String? getUserName() {
    final user = currentUser;
    if (user == null) return null;
    // For email/password auth, use email as name
    return user.userMetadata?['full_name'] as String? ??
        user.userMetadata?['name'] as String? ??
        user.email;
  }

  /// Get user avatar URL from current user
  String? getUserAvatarUrl() {
    final user = currentUser;
    if (user == null) return null;
    return user.userMetadata?['avatar_url'] as String? ??
        user.userMetadata?['picture'] as String?;
  }
}

