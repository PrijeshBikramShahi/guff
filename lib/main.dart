import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/conversations_list_screen.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Replace with your Supabase URL and anon key
  // Get these from: https://supabase.com/dashboard/project/_/settings/api
  // See SETUP_INSTRUCTIONS.md for detailed steps
  const supabaseUrl = 'https://ypiidrjowcuxzfrqetkl.supabase.co';
  const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlwaWlkcmpvd2N1eHpmcnFldGtsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3NjI0ODUsImV4cCI6MjA4MDMzODQ4NX0.Dwpg_dVeKkSm0KAdUjUMyj8GCYnxtSJU9qk0fCDHvuM';
  
  // Check if credentials are set
  if (supabaseUrl == 'YOUR_SUPABASE_URL' || supabaseAnonKey == 'YOUR_SUPABASE_ANON_KEY') {
    print('⚠️  Please set your Supabase credentials in lib/main.dart');
    print('📖 See SETUP_INSTRUCTIONS.md for help');
  } else {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );
      print('✅ Supabase initialized successfully!');
    } catch (e) {
      print('❌ Error initializing Supabase: $e');
    }
  }
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes
    _authService.authStateChanges.listen((AuthState state) {
      // Rebuild when auth state changes
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guff Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Show AuthScreen if not authenticated, ConversationsListScreen if authenticated
      home: _authService.isAuthenticated
          ? const ConversationsListScreen()
          : const AuthScreen(),
    );
  }
}
