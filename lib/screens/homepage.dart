import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guff_app/screens/homepage_tabs/calls.dart';
import 'package:guff_app/screens/homepage_tabs/contacts.dart';
import 'package:guff_app/screens/homepage_tabs/messages.dart';
import 'package:guff_app/screens/homepage_tabs/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int _currentIndex = 0;
List<Widget> _pages = [
  MessagesPage(),
  CallsPage(),
  ContactsPage(),
  SettingsPage(),
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(),
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone_rounded),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_rounded),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
          ),
        ],
        activeColor: Colors.deepOrangeAccent,
        onTap: (value) {
          setState(
            () {
              _currentIndex = value;
            },
          );
        },
      ),
    );
  }

  AppBar appBarMethod() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Icon(
          Icons.search,
          size: 40,
        ),
      ),
      title: Image.asset(
        './assets/images/light/logo_1.png',
        height: 50,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: CircleAvatar(),
        ),
      ],
    );
  }
}
