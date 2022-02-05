// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/AuthController.dart';

class PhoneNumber extends StatelessWidget {
  PhoneNumber({
    required this.mineFocus,
    required this.controller,
    required this.requestFocus,
  });
  final AuthController authController = Get.put(AuthController());

  final TextEditingController controller;
  final FocusNode mineFocus;
  final FocusNode requestFocus;

  String a = "errorEmpty".tr;
  String b = "errorPhoneCount".tr;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text("userPhoneNumber".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
        ),
        TextFormField(
          style: const TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.black),
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          focusNode: mineFocus,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return "errorEmpty".tr;
            } else if (value.length != 8) {
              return b;
            }
            return null;
          },
          inputFormatters: [
            LengthLimitingTextInputFormatter(8),
          ],
          onEditingComplete: () {
            requestFocus.requestFocus();
          },
          cursorColor: kPrimaryColor,
          decoration: const InputDecoration(
            errorMaxLines: 2,
            errorStyle: TextStyle(fontFamily: montserratRegular),
            prefixIcon: Text(
              '+ 993  ',
              style: TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
            ),
            prefixIconConstraints: BoxConstraints.tightForFinite(),
            isDense: true,
            hintText: '65 656565 ',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
            disabledBorder: UnderlineInputBorder(),
            border: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(),
            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            enabledBorder: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
