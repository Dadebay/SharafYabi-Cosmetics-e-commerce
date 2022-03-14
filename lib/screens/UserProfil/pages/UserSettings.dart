// ignore_for_file: file_names, always_declare_return_types, type_annotate_public_apis, avoid_dynamic_calls

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';

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
    mine["full_name"] = name;
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
                        focusedErrorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red)),
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
                      focusedErrorBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.red)),
                      focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                      enabledBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.black12, width: 2)),
                    ),
                  ),
                ),
                Center(
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: () {
                      if (_login.currentState!.validate()) {
                        changedata(nameController.text);
                        showCustomToast(context, "changedPasswordName");
                        Navigator.of(context).pop();
                        setState(() {});
                      }
                    },
                    color: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
