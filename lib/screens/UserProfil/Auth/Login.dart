// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:sharaf_yabi_ecommerce/components/buttons/agreeButton.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/components/textFields/PhoneNumber.dart';
import 'package:sharaf_yabi_ecommerce/components/textFields/passwordTextField.dart';
import 'package:sharaf_yabi_ecommerce/controllers/AuthController.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/UserSignInModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/Auth/ForgotPassword.dart';
import 'package:vibration/vibration.dart';

class Login extends StatelessWidget {
  TextEditingController loginPassswordController = TextEditingController();
  TextEditingController loginPhoneController = TextEditingController();
  FocusNode paswordFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();

  final _login = GlobalKey<FormState>();

  Column textPart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: Text(
            "login".tr,
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 22),
          ),
        ),
        Text(
          "signIn2".tr,
          textAlign: TextAlign.start,
          style: const TextStyle(color: Colors.grey, fontFamily: montserratMedium, fontSize: 18),
        ),
      ],
    );
  }

  Padding textMine(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(name.tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      color: Colors.white,
      child: Form(
        key: _login,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textPart(),
            PhoneNumber(
              mineFocus: phoneFocus,
              requestFocus: paswordFocus,
              controller: loginPhoneController,
            ),
            PasswordTextFieldMine(mineFocus: paswordFocus, requestFocus: paswordFocus, controller: loginPassswordController, hintText: "userPassword".tr),
            GestureDetector(
              onTap: () {
                Get.to(() => ForgotPassword());
              },
              child: Center(child: Text("forgotPasswordText".tr, style: const TextStyle(color: kPrimaryColor, decoration: TextDecoration.underline, fontFamily: montserratMedium, fontSize: 18))),
            ),
            Center(
              child: AgreeButton(
                name: "agree",
                onTap: () {
                  if (_login.currentState!.validate()) {
                    Get.find<AuthController>().changeSignInAnimation();
                    UserSignInModel().login(phone: loginPhoneController.text, password: loginPassswordController.text).then((value) {
                      if (value == true) {
                        Restart.restartApp();
                        showSnackBar("signIntitle", "signInSubtitle", kPrimaryColor);
                      } else if (value == 409) {
                        showSnackBar("signInErrorTitle", "errorLogin", Colors.red);

                        loginPhoneController.clear();
                      } else if (value == 500) {
                        showSnackBar("signInErrorTitle", "errorLogin", Colors.red);
                      } else if (value == 404) {
                        showSnackBar("retry", "errorLogin", Colors.red);
                      }
                      Get.find<AuthController>().changeSignInAnimation();
                    });
                  } else {
                    Vibration.vibrate();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
