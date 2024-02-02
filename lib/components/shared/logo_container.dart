import 'package:flutter/material.dart';

class LogoContainer extends StatelessWidget {
  const LogoContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 10,
      child: Image.asset(
        'assets/images/light/logo_1.png',
        fit: BoxFit.cover,
      ),
    );
  }
}