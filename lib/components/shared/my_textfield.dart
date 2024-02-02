import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  MyTextField(
      {super.key, required this.inputDecoration, required this.textInputType});
  final InputDecoration inputDecoration;
  final TextInputType textInputType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
      child: TextFormField(
        keyboardType: textInputType,
        decoration: inputDecoration,
        style: TextStyle(),
      ),
    );
  }
}
