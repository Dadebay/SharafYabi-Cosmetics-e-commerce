// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/Auth/Login.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/Auth/SignIn.dart';

class LoginPage extends StatelessWidget {
  SizedBox ImagePart() {
    return SizedBox(
      height: Get.size.height / 2.2,
      child: ClipRRect(
        borderRadius: borderRadius20,
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset("assets/appLogo/logo.png", fit: BoxFit.cover)),
            Positioned(
                top: 30,
                left: 15,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    IconlyLight.arrowLeft2,
                    color: Colors.white,
                    size: 28,
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: TabBar(
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                overlayColor: MaterialStateColor.resolveWith((states) => kPrimaryColor),
                indicatorPadding: const EdgeInsets.only(bottom: 5, left: 30, right: 30),
                labelStyle: const TextStyle(fontFamily: montserratBold, fontSize: 18),
                unselectedLabelStyle: const TextStyle(fontFamily: montserratMedium),
                unselectedLabelColor: Colors.white70,
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    text: "signin".tr,
                  ),
                  Tab(
                    text: "login".tr,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: Get.size.height,
            child: Stack(
              children: [
                ImagePart(),
                Container(
                  padding: EdgeInsets.only(top: Get.size.height / 2.2),
                  child: TabBarView(children: [SingIN(), Login()]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
