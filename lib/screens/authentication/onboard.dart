import 'package:flutter/material.dart';
import 'package:guff_app/components/logo_container.dart';
import 'package:guff_app/components/my_button.dart';
import 'package:guff_app/style_models/button_styles.dart';
import 'package:guff_app/style_models/font_styles.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LogoContainer(),
              CenterContainer(),
              FingerprintContainer(),
            ],
          ),
        ),
      ),
    );
  }
}

class CenterContainer extends StatelessWidget {
  const CenterContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            direction: Axis.vertical,
            children: [
              MyButton(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                buttonTextStyle: Fonts.buttonLight,
                buttonName: "Login",
                decoration: ButtonStyles.fillColor,
              ),
              MyButton(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                buttonTextStyle: Fonts.buttonColor,
                buttonName: "Register",
                decoration: ButtonStyles.fillWhite,
              ),
            ],
          ),
          Text(
            "Now! Quick Login using Touch ID",
          ),
        ],
      ),
    );
  }
}

class FingerprintContainer extends StatelessWidget {
  const FingerprintContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 8,
          child: Image.asset('assets/images/light/fingerprint_black.png'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            "Use Touch ID",
            style: TextStyle(),
          ),
        ),
      ],
    );
  }
}
