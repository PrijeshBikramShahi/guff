import 'package:flutter/material.dart';

class TextFieldStyles {
  static var emailStyle = InputDecoration(
    label: Text("E-mail"),
    labelStyle: TextStyle(),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    border: OutlineInputBorder(
      gapPadding: 5,
    ),
  );
  static var passwordStyle = InputDecoration(
    label: Text("Password"),
    labelStyle: TextStyle(),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    border: OutlineInputBorder(
      gapPadding: 5,
    ),
  );
  static var usernameStyle = InputDecoration(
    label: Text("Username"),
    labelStyle: TextStyle(),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    border: OutlineInputBorder(
      gapPadding: 5,
    ),
  );
}
