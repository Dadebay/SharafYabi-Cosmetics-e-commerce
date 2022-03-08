// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:vibration/vibration.dart';

final _form1Key = GlobalKey<FormState>();

Future<dynamic> customDialog(
    {required String title,
    required String hintText,
    required TextEditingController controller,
    required TextEditingController secondTextFieldController,
    required int maxLine,
    required int maxLength,
    required Function() onTap,
    required bool secondTextField}) {
  Get.find<SettingsController>().dialogsBool.value = false;
  controller.clear();
  secondTextFieldController.clear();
  return Get.defaultDialog(
    radius: 8,
    title: title.tr,
    titlePadding: const EdgeInsets.only(
      bottom: 12,
      top: 10,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    titleStyle: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 22),
    content: Column(
      children: [
        SizedBox(
          width: Get.size.width,
          child: Form(
            key: _form1Key,
            child: secondTextField
                ? Column(
                    children: [
                      textFieldMine(controller, maxLine, maxLength, hintText),
                      secondTextFieldMine(secondTextFieldController, maxLine, maxLength),
                    ],
                  )
                : textFieldMine(controller, maxLine, maxLength, hintText),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          return SizedBox(
            width: Get.find<SettingsController>().dialogsBool.value ? 70 : Get.size.width - 50,
            child: RaisedButton(
                onPressed: () {
                  if (_form1Key.currentState!.validate()) {
                    onTap();
                  } else {
                    Vibration.vibrate();
                  }
                },
                shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                color: kPrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: Get.find<SettingsController>().dialogsBool.value ? 6 : 8),
                child: Get.find<SettingsController>().dialogsBool.value
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text("send".tr, style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 20))),
          );
        })
      ],
    ),
  );
}

Container secondTextFieldMine(TextEditingController? secondTextFieldController, int maxLine, int maxLength) {
  return Container(
    width: Get.size.width,
    padding: const EdgeInsets.only(top: 10),
    child: TextFormField(
      controller: secondTextFieldController,
      maxLines: maxLine,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: kPrimaryColor,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
      validator: (value) {
        if (value!.isEmpty) {
          return "errorEmpty".tr;
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          label: Text("orderNoteOrder".tr),
          alignLabelWithHint: true,
          prefixIconConstraints: const BoxConstraints.tightForFinite(),
          labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
          constraints: const BoxConstraints(),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
          border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
          errorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red, width: 2)),
          focusedErrorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius10,
              borderSide: BorderSide(
                color: Colors.grey.shade400,
              )),
          focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2))),
    ),
  );
}

TextFormField textFieldMine(TextEditingController controller, int maxLine, int maxLength, String hintText) {
  return TextFormField(
    controller: controller,
    textCapitalization: TextCapitalization.sentences,
    cursorColor: kPrimaryColor,
    maxLines: maxLine,
    inputFormatters: [
      LengthLimitingTextInputFormatter(maxLength),
    ],
    style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
    validator: (value) {
      if (value!.isEmpty) {
        return "errorEmpty".tr;
      } else {
        return null;
      }
    },
    decoration: InputDecoration(
        label: Text(hintText.tr),
        alignLabelWithHint: true,
        prefixIconConstraints: const BoxConstraints.tightForFinite(),
        labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
        constraints: const BoxConstraints(),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
        border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
        errorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red, width: 2)),
        focusedErrorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius10,
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            )),
        focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2))),
  );
}
