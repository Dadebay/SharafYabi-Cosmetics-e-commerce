import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/AddresModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/BottomNavBar.dart';

TextFormField phoneNumberTextField(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    cursorColor: kPrimaryColor,
    style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
    validator: (value) {
      if (value!.isEmpty) {
        return "errorEmpty".tr;
      } else {
        return null;
      }
    },
    inputFormatters: [
      LengthLimitingTextInputFormatter(8),
    ],
    decoration: InputDecoration(
        hintText: "__ ______",
        prefixIcon: const Text(
          '  + 993  ',
          style: TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratSemiBold),
        ),
        prefixIconConstraints: const BoxConstraints.tightForFinite(),
        isDense: true,
        constraints: const BoxConstraints(),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
        border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius10,
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            )),
        focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2))),
  );
}

Row productsCount(int productCount) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "productsCount".tr,
        style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: montserratMedium),
      ),
      Text(
        "${productCount}",
        style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
      )
    ],
  );
}
