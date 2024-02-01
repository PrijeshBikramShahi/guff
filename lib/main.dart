import 'package:flutter/material.dart';
import 'package:guff_app/screens/homepage.dart';
import 'package:guff_app/screens/login.dart';
import 'package:guff_app/screens/onboard.dart';
import 'package:guff_app/screens/signup.dart';
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
      },
      // home: LoginPage(),
    );
  }
}
