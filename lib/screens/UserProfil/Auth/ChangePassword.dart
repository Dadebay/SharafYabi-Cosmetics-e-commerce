// ignore_for_file: file_names, must_be_immutable, deprecated_member_use, duplicate_ignore, noop_primitive_operations

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/UserSignInModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/BottomNavBar.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';
import 'package:vibration/vibration.dart';

class ChangePassword extends StatefulWidget {
  final String otpCode;

  const ChangePassword({Key? key, required this.otpCode}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController passwordControllerTest = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool numberSendingLoading = false;
  final _login = GlobalKey<FormState>();
  String a = "errorPassword1".tr;
  String b = "errorPassword2".tr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: MyAppBar(
        icon: Icons.add,
        onTap: () {},
        backArrow: true,
        iconRemove: false,
        name: "newUserPasswordTitle",
        addName: true,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${"newUserPasswordSubtitle".tr} : ",
                style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
              ),
              Form(
                key: _login,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: TextFormField(
                        style: const TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.black),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "errorEmpty".tr;
                          } else if (value == "") {
                            return a;
                          } else if (value.toString().length < 8) {
                            return b;
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9 a-z A-Z]')),
                          LengthLimitingTextInputFormatter(14),
                        ],
                        controller: passwordController,
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          errorStyle: const TextStyle(fontFamily: montserratRegular),
                          label: Text("userPassword".tr),
                          labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
                          isDense: true,
                          errorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red)),
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                          focusedErrorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red)),
                          focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                          enabledBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.black12, width: 2)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 25),
                      child: TextFormField(
                        style: const TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.black),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "errorEmpty".tr;
                          } else if (value == "") {
                            return a;
                          } else if (value.toString().length < 8) {
                            return b;
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9 a-z A-Z]')),
                          LengthLimitingTextInputFormatter(14),
                        ],
                        controller: passwordControllerTest,
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          errorStyle: const TextStyle(fontFamily: montserratRegular),
                          label: Text("userPasswordApporve".tr),
                          labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
                          isDense: true,
                          errorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red)),
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                          focusedErrorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red)),
                          focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                          enabledBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.black12, width: 2)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    if (_login.currentState!.validate()) {
                      if (passwordController.text == passwordControllerTest.text) {
                        setState(() {
                          numberSendingLoading = true;
                        });

                        UserSignInModel().changePassword(code: widget.otpCode, newPassword: passwordController.text).then((value) {
                          if (value == 200) {
                            showCustomToast(context, "changedPassword");
                            setState(() {
                              numberSendingLoading = false;
                            });
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomNavBar()));
                          } else if (value == 500 || value == 403) {
                            showSnackBar("otpErrorTitle", "otpErrorSubtitle", Colors.red);
                            setState(() {
                              numberSendingLoading = false;
                              Vibration.vibrate();
                            });
                          } else {
                            showSnackBar("retry", "errorLogin", Colors.red);

                            setState(() {
                              numberSendingLoading = false;
                              Vibration.vibrate();
                            });
                          }
                        });
                      } else {
                        showSnackBar("retry", "fuckPasswordsError", Colors.red);

                        Vibration.vibrate();
                      }
                    }
                  },
                  color: kPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: numberSendingLoading ? 10 : 4, horizontal: 12),
                  shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                  child: numberSendingLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("agree".tr, style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: montserratMedium)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
