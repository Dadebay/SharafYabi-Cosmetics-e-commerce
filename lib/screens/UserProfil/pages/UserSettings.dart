// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/screens/BottomNavBar.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';
import 'package:vibration/vibration.dart';

class UserSettings extends StatefulWidget {
  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final storage = GetStorage();

  String name = "";
  String phone = "";
  @override
  void initState() {
    super.initState();
    changeUserData();
  }

  changeUserData() {
    final result = storage.read('data');

    if (result != null) {
      nameController.text = jsonDecode(result)["full_name"];
      phoneController.text = "+993 ${jsonDecode(result)["phone"]}";
    }
  }

  changedata(String name) {
    final result = storage.read('data');
    final mine = jsonDecode(result);
    mine["full_name"] = "$name";
    final String jsonString = jsonEncode(mine);

    storage.write('data', jsonString);
  }

  final _login = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: MyAppBar(
          icon: Icons.add,
          onTap: () {},
          backArrow: true,
          iconRemove: false,
          name: "profil",
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
                Form(
                  key: _login,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 20),
                    child: TextFormField(
                      style: const TextStyle(fontFamily: montserratMedium, fontSize: 18, color: Colors.black),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "errorEmpty".tr;
                        }
                        return null;
                      },
                      controller: nameController,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        errorStyle: const TextStyle(fontFamily: montserratRegular),
                        label: Text("userName".tr),
                        labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
                        isDense: true,
                        errorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red, width: 1)),
                        focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                        enabledBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.black12, width: 2)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: TextFormField(
                    style: const TextStyle(fontFamily: montserratRegular, fontSize: 18, color: Colors.grey),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "errorEmpty".tr;
                      }
                      return null;
                    },
                    controller: phoneController,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      errorMaxLines: 2,
                      enabled: false,
                      errorStyle: const TextStyle(fontFamily: montserratRegular),
                      label: Text("userPhoneNumber".tr),
                      labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
                      isDense: true,
                      disabledBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.black12, width: 2)),
                      errorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red)),
                      focusedErrorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red, width: 1)),
                      focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                      enabledBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.black12, width: 2)),
                    ),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      if (_login.currentState!.validate()) {
                        changedata(nameController.text);
                        showCustomToast(context, "changedPasswordName");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomNavBar()));
                        setState(() {});
                      }
                    },
                    color: kPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                    child: Row(
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
        ));
  }
}
