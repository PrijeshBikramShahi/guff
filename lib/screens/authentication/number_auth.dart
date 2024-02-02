import 'package:flutter/material.dart';
import 'package:guff_app/components/my_button.dart';
import 'package:guff_app/style_models/button_styles.dart';
import 'package:guff_app/style_models/font_styles.dart';

class PhoneNumber extends StatelessWidget {
  const PhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            GraphicsContainer(),
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
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // direction: Axis.vertical,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "Enter the 5 digit number sent to this phone number: ",
                  ),
                  TextSpan(
                    text: "+977-9862300199",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              overflow: TextOverflow.clip,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.deepOrangeAccent.withOpacity(0.5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Resend Code"),
              ],
            ),
            MyButton(
                decoration: ButtonStyles.fillWhite,
                buttonName: "Verify",
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                buttonTextStyle: Fonts.buttonColor)
          ],
        ),
      ),
    ));
  }
}

class GraphicsContainer extends StatelessWidget {
  const GraphicsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: Colors.red,
    ));
  }
}
