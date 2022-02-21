// ignore_for_file: file_names, must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/UserSignInModel.dart';

class ForgotPassword extends StatelessWidget {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: phoneNumberController,
              ),
              RaisedButton(
                onPressed: () {
                  UserSignInModel().forgotPassword(phoneNumber: phoneNumberController.text);
                },
                child: const Text("Send Number"),
              ),
              TextField(
                controller: passwordController,
              ),
              TextField(
                controller: otpController,
              ),
              RaisedButton(
                onPressed: () {
                  UserSignInModel().changePassword(code: otpController.text, newPassword: passwordController.text);
                },
                child: const Text("Agree Button"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
