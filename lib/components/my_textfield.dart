import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({super.key, this.inputDecoration});
final inputDecoration;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 40),
      child: TextField(
        decoration: inputDecoration,
        style: TextStyle(),
      ),
    );
  }
}
