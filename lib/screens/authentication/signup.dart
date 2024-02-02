import 'package:flutter/material.dart';
import 'package:guff_app/components/logo_container.dart';
import 'package:guff_app/components/my_button.dart';
import 'package:guff_app/components/my_textfield.dart';
import 'package:guff_app/style_models/button_styles.dart';
import 'package:guff_app/style_models/font_styles.dart';
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LogoContainer(),
            CenterContainer(),
            BottomContainer(),
          ],
        ),
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
      child: Column(
        children: [
          Wrap(
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
          MyButton(
            decoration: ButtonStyles.fillColor,
            buttonName: "Sign Up",
            onTap: () {
              Navigator.pushNamed(context, '/number');
            },
            buttonTextStyle: Fonts.buttonLight,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.shade600,
                  ),
                  height: 2,
                  width: 150,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "OR",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.shade600,
                  ),
                  height: 2,
                  width: 150,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Wrap(
              spacing: 70,
              children: [
                Icon(
                  Icons.face,
                  size: 60,
                ),
                Icon(
                  Icons.face,
                  size: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
