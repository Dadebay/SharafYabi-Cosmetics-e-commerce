// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls, prefer_typing_uninitialized_variables, type_annotate_public_apis, always_declare_return_types

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/AuthController.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/Components/Profile_Widgets.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/AboutUS.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/MyAddress.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/Orders.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/SendMessage.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/UserSettings.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/ourDeliveryService.dart';

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
    changeUserData();
    return Scaffold(
        backgroundColor: backgroundColor,
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
                    pushNewScreen(
                      context,
                      screen: MyAddress(),
                      withNavBar: true, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                )
              else
                const SizedBox.shrink(),
              buttonProfile(
                name: "orders",
                icon: CupertinoIcons.cube_box,
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: Orders(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              buttonProfile(
                name: "favorite",
                icon: IconlyLight.heart,
                onTap: () async {
                  pushNewScreen(
                    context,
                    screen: FavoritePage(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              buttonProfile(
                name: "select_language",
                icon: Icons.language,
                onTap: () async {
                  changeLanguage();
                },
              ),
              buttonProfile(
                name: "ourDeliveryService",
                icon: IconlyLight.paper,
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: OurDeliveryService(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              buttonProfile(
                name: "messageTitle",
                icon: IconlyLight.message,
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: SendMessage(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              buttonProfile(
                name: "aboutUS",
                icon: IconlyLight.infoSquare,
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: AboutUS(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              buttonProfile(
                name: storage.read("AccessToken") != null ? "log_out" : "login",
                icon: storage.read("AccessToken") != null ? IconlyLight.logout : IconlyLight.login,
                onTap: () {
                  authController.loginInAnimation.value = false;
                  authController.signInAnimation.value = false;
                  storage.read("AccessToken") != null
                      ? logOut(context)
                      : pushNewScreen(
                          context,
                          screen: LoginPage(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
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
                pushNewScreen(
                  context,
                  screen: UserSettings(),
                  withNavBar: true, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
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
                    userProfile,
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
