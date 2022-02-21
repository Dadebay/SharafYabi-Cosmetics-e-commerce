// ignore_for_file: file_names, must_be_immutable, deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: phoneNumberController,
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {},
              child: const Text("Sendaa Number"),
            ),
            TextField(
              controller: passwordController,
            ),
            TextField(
              controller: otpController,
            ),
            RaisedButton(
              onPressed: () {},
              child: const Text("Agree Button"),
            )
          ],
        ),
      ),
    );
  }
}
