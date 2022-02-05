// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/AuthController.dart';

class TextFieldMine extends StatelessWidget {
  TextFieldMine({
    required this.mineFocus,
    required this.requestFocus,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;
  final AuthController loginController = Get.put(AuthController());
  final FocusNode mineFocus;
  final FocusNode requestFocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text("userName".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
        ),
        TextFormField(
          style: const TextStyle(fontFamily: montserratMedium, fontSize: 17, color: Colors.black),
          textInputAction: TextInputAction.next,
          focusNode: mineFocus,
          controller: controller,
          validator: (value) {
            if (value.toString().length < 3) {
              return "errorLengthName".tr;
            }
            return null;
          },
          onEditingComplete: () {
            requestFocus.requestFocus();
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(60),
          ],
          cursorColor: kPrimaryColor,
          decoration: InputDecoration(
            errorMaxLines: 1,
            errorStyle: const TextStyle(fontFamily: montserratRegular),
            isDense: true,
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
            hintText: hintText.tr,
            hintStyle: const TextStyle(color: Colors.grey),
            disabledBorder: const UnderlineInputBorder(),
            border: const UnderlineInputBorder(),
            focusedBorder: const UnderlineInputBorder(),
            errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            enabledBorder: const UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
