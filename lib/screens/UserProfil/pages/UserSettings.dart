// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

class UserSettings extends StatefulWidget {
  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
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
      phoneController.text = jsonDecode(result)["phone"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          icon: Icons.add,
          onTap: () {},
          backArrow: true,
          iconRemove: false,
          name: "profil",
          addName: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              TextField(
                controller: nameController,
              ),
              TextField(
                controller: phoneController,
              ),
              TextField(
                controller: addressController,
              ),
            ],
          ),
        ));
  }
}
