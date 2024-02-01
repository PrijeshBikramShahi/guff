import 'package:flutter/material.dart';
import 'package:guff_app/components/logo_container.dart';
import 'package:guff_app/components/my_textfield.dart';
import 'package:guff_app/style_models/textfield_styles.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LogoContainer(),
          CenterContainer(),
          BottomContainer(),
        ],
      ),
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already have an account? ",
              style: TextStyle(color: Colors.black),
            ),
            TextSpan(
              text: "Login",
              style: TextStyle(color: Colors.deepOrangeAccent),
            ),
          ],
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
      child: Wrap(
        children: [
          MyTextField(
            inputDecoration: TextFieldStyles.usernameStyle,
          ),
          MyTextField(
            inputDecoration: TextFieldStyles.emailStyle,
          ),
          MyTextField(
            inputDecoration: TextFieldStyles.passwordStyle,
          ),
        ],
      ),
    );
  }
}
