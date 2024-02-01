import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  MyButton(
      {super.key,
      required this.decoration,
      required this.buttonName,
      required this.onTap,
      required this.buttonTextStyle});
  final BoxDecoration decoration;
  final String buttonName;
  final TextStyle buttonTextStyle;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: MediaQuery.of(context).size.height / 17,
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: decoration,
          child: Center(
            child: Text(
              buttonName,
              style: buttonTextStyle.copyWith(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
