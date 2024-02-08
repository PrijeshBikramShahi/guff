import 'package:flutter/material.dart';
import 'package:guff_app/screens/authentication/number_auth.dart';
import 'package:guff_app/screens/homepage.dart';
import 'package:guff_app/screens/authentication/login.dart';
import 'package:guff_app/screens/authentication/onboard.dart';
import 'package:guff_app/screens/homepage_tabs/settings.dart';
import 'package:guff_app/screens/authentication/signup.dart';
import 'package:guff_app/themes/light_mode.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardPage(),
        '/register': (context) => SignUpPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => SettingsPage(),
        '/number': (context) => PhoneNumber(),
      },
    );
  }
}
