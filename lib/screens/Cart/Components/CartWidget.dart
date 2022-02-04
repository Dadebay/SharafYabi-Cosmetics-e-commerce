import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/screens/BottomNavBar.dart';

Future<dynamic> completeOrder() {
  return Get.defaultDialog(
      radius: 25,
      backgroundColor: Colors.white,
      title: "",
      barrierDismissible: false,
      actions: [
        SizedBox(
          width: Get.size.width / 1.5,
          child: RaisedButton(
            onPressed: () {
              Get.to(() => BottomNavBar());
            },
            shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
            color: kPrimaryColor,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("agree".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: montserratSemiBold,
                )),
          ),
        )
      ],
      content: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 25),
            width: Get.size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("orderComplete".tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: montserratSemiBold)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text("orderCompleteSubtitle".tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontFamily: montserratRegular)),
                ),
              ],
            ),
          ),
          Positioned(
            top: -120,
            child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(15),
                child: Lottie.asset("assets/lottie/cartblack.json", fit: BoxFit.cover, width: 110, height: 110)),
          )
        ],
      ));
}

AppBar appbar() {
  return AppBar(
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          IconlyLight.arrowLeft2,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      title: Text(
        "order".tr,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 18),
      ));
}
