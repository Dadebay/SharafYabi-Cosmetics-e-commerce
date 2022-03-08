// ignore_for_file: missing_return, file_names, noop_primitive_operations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/AuthModel.dart';

void logOut(BuildContext context) {
  Get.bottomSheet(Container(
    decoration: const BoxDecoration(color: Colors.white),
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text(
                "log_out".tr,
                style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.xmark_circle, size: 22, color: Colors.black),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          height: 1,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text("log_out_title".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontFamily: montserratMedium,
                fontSize: 16,
              )),
        ),
        GestureDetector(
          onTap: () async {
            Auth().logout();
            Auth().removeToken();
            Auth().removeRefreshToken();
            Auth().getToken().then((value) {});
            Get.back();
            // Restart.restartApp();
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius10),
            child: Text(
              "yes".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontFamily: montserratBold, fontSize: 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius10),
            child: Text(
              "no".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  ));
}

Widget buttonProfile({required String name, required IconData icon, required Function() onTap}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: const BoxDecoration(
      borderRadius: borderRadius15,
    ),
    child: ListTile(
      tileColor: Colors.white,
      focusColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
      selectedColor: Colors.white,
      hoverColor: Colors.white,
      selectedTileColor: Colors.white,
      onTap: onTap,
      minVerticalPadding: 0.0,
      minLeadingWidth: 10.0,
      leading: Icon(
        icon,
        color: kPrimaryColor,
        size: 26,
      ),
      title: Text(
        name.tr,
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: kPrimaryColor, fontFamily: montserratMedium, fontSize: 16),
      ),
    ),
  );
}

void changeLanguage() {
  Get.bottomSheet(Container(
    padding: const EdgeInsets.only(bottom: 20),
    decoration: const BoxDecoration(color: Colors.white),
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text(
                "select_language".tr,
                style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.xmark_circle, size: 22, color: Colors.black),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          height: 1,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
              onTap: () {
                Get.find<SettingsController>().switchLang("tr");
                Get.find<HomePageController>().refreshList();
                Get.back();
              },
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  tmIcon,
                ),
                backgroundColor: Colors.white,
                radius: 20,
              ),
              title: const Text(
                "Türkmen",
                style: TextStyle(fontFamily: montserratMedium),
              )),
        ),
        dividerr(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
              onTap: () {
                Get.find<SettingsController>().switchLang("ru");
                Get.find<HomePageController>().refreshList();
                Get.back();
              },
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  ruIcon,
                ),
                radius: 20,
                backgroundColor: Colors.white,
              ),
              title: const Text(
                "Русский",
                style: TextStyle(fontFamily: montserratMedium),
              )),
        ),
        dividerr(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
              onTap: () {
                Get.find<SettingsController>().switchLang("en");
                Get.find<HomePageController>().refreshList();
                Get.back();
              },
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  enIcon,
                ),
                radius: 20,
                backgroundColor: Colors.white,
              ),
              title: const Text(
                "English",
                style: TextStyle(fontFamily: montserratMedium),
              )),
        ),
      ],
    ),
  ));
}
