// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/BannersModel.dart';

class SendMessage extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final _login = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        icon: Icons.add,
        onTap: () {},
        backArrow: true,
        iconRemove: false,
        name: "messageTitle",
        addName: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  cursorColor: kPrimaryColor,
                  style: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
                  decoration: InputDecoration(
                    labelText: "userName".tr,
                    labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
                    focusedBorder: const OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                    enabledBorder: const OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: mailController,
                  cursorColor: kPrimaryColor,
                  style: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
                  decoration: InputDecoration(
                    labelText: "mail".tr,
                    labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
                    focusedBorder: const OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                    enabledBorder: const OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Form(
                key: _login,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: const TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.black),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "errorEmpty".tr;
                      } else if (value.length != 8) {
                        return "errorPhoneCount".tr;
                      }
                      return null;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                    ],
                    controller: phoneController,
                    decoration: const InputDecoration(
                      errorMaxLines: 2,
                      errorStyle: TextStyle(fontFamily: montserratRegular),
                      prefixIcon: Text(
                        '  + 993  ',
                        style: TextStyle(color: Colors.grey, fontSize: 19, fontFamily: montserratMedium),
                      ),
                      prefixIconConstraints: BoxConstraints.tightForFinite(),
                      isDense: true,
                      hintText: '65 656565 ',
                      errorBorder: OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: Colors.red)),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                      border: OutlineInputBorder(
                          borderRadius: borderRadius5,
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                          )),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: borderRadius5,
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: borderRadius5,
                          borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: messageController,
                  cursorColor: kPrimaryColor,
                  style: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "message".tr,
                    labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
                    focusedBorder: const OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                    enabledBorder: const OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  onPressed: () {
                    if (_login.currentState!.validate()) {
                      SendAdminMessage()
                          .sendAdminMessage(
                        name: nameController.text.isEmpty ? "" : nameController.text,
                        phone: phoneController.text.isEmpty ? "" : phoneController.text,
                        mail: mailController.text.isEmpty ? "" : mailController.text,
                        message: messageController.text.isEmpty ? "" : messageController.text,
                      )
                          .then((value) {
                        if (value == true) {
                          showCustomToast(context, "messageSend".tr);
                          nameController.clear();
                          phoneController.clear();
                          mailController.clear();
                          messageController.clear();
                        } else {
                          showCustomToast(context, "error404".tr);
                        }
                      });
                    } else {
                      showCustomToast(context, "errorEmpty".tr);
                    }
                  },
                  color: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("send".tr, style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 18)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          IconlyLight.send,
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
