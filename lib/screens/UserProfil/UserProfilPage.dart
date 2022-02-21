// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls, prefer_typing_uninitialized_variables, type_annotate_public_apis, always_declare_return_types

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/AuthController.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/Components/Profile_Widgets.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/AboutUS.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/MyAddress.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/Orders.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/UserSettings.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/ourDeliveryService.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

import 'Auth/LoginPage.dart';
import 'pages/FavoritePage/FavoritePage.dart';

class UserProfil extends StatefulWidget {
  @override
  State<UserProfil> createState() => _UserProfilState();
}

class _UserProfilState extends State<UserProfil> {
  final storage = GetStorage();
  AuthController authController = Get.put(AuthController());
  TextEditingController phoneController = TextEditingController();
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
      name = jsonDecode(result)["full_name"];
      phone = jsonDecode(result)["phone"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor.withOpacity(0.1),
        appBar: MyAppBar(
          iconRemove: false,
          backArrow: false,
          icon: Icons.ac_unit,
          onTap: () {},
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (storage.read("AccessToken") != null) namePart(context) else const SizedBox.shrink(),
              if (storage.read("AccessToken") != null)
                buttonProfile(
                  name: "myAddress",
                  icon: IconlyLight.location,
                  onTap: () {
                    Get.to(() => MyAddress());
                  },
                )
              else
                const SizedBox.shrink(),
              buttonProfile(
                name: "orders",
                icon: CupertinoIcons.cube_box,
                onTap: () {
                  Get.to(() => Orders());
                },
              ),
              selectLang(),
              buttonProfile(
                name: "favorite",
                icon: IconlyLight.heart,
                onTap: () async {
                  Get.to(() => FavoritePage());
                },
              ),
              shareApp(),
              buttonProfile(
                name: "ourDeliveryService",
                icon: IconlyLight.paper,
                onTap: () {
                  Get.to(() => OurDeliveryService());
                },
              ),
              buttonProfile(
                name: "aboutUS",
                icon: IconlyLight.infoSquare,
                onTap: () {
                  Get.to(() => AboutUS());
                },
              ),
              buttonProfile(
                name: storage.read("AccessToken") != null ? "log_out" : "login",
                icon: storage.read("AccessToken") != null ? IconlyLight.logout : IconlyLight.login,
                onTap: () {
                  authController.loginInAnimation.value = false;
                  authController.signInAnimation.value = false;
                  storage.read("AccessToken") != null ? logOut() : Get.to(() => LoginPage());
                },
              ),
            ],
          ),
        ));
  }

  Container namePart(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius15,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () {
                Get.to(() => UserSettings());
              },
              child: const Icon(IconlyLight.editSquare, color: kPrimaryColor, size: 30),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Lottie.asset(
                    "assets/lottie/user.json",
                    repeat: false,
                    width: 70,
                    height: 70,
                    animate: true,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 6),
                  child: Text(
                    name,
                    style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18),
                  ),
                ),
                Text(
                  "+993 $phone",
                  style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
