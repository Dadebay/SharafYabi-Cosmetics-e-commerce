// ignore_for_file: missing_return, file_names, noop_primitive_operations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/AuthModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/BottomNavBar.dart';
import 'package:share/share.dart';

final SettingsController _settingsController = Get.put(SettingsController());

void logOut() {
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
            Get.back();
            Restart.restartApp();

            Get.to(() => BottomNavBar());
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

void clearCache() {
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
                "clearAppCache".tr,
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
          child: Text("clearAppCacheSubtitle".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontFamily: montserratMedium,
                fontSize: 16,
              )),
        ),
        GestureDetector(
          onTap: () async {
            // await FlutterRestart.restartApp();
            Restart.restartApp();
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

Padding myText(String name) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Text(
      name.tr,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: kPrimaryColor,
        fontSize: 18,
        fontFamily: montserratSemiBold,
      ),
    ),
  );
}

Widget buttonProfile({required String name, required IconData icon, required Function() onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ListTile(
      tileColor: Colors.white,
      focusColor: Colors.white,
      selectedColor: Colors.white,
      hoverColor: Colors.white,
      selectedTileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xfff1f2f4).withOpacity(0.6), borderRadius: borderRadius15),
        child: Icon(
          icon,
          color: Colors.black,
          size: 26,
        ),
      ),
      title: Text(
        name.tr,
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
      ),
      trailing: const Icon(
        IconlyLight.arrowRightCircle,
        color: Colors.black,
        size: 18,
      ),
    ),
  );
}

Padding selectLang() {
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
                  _settingsController.switchLang("tr");
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
                  _settingsController.switchLang("ru");

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
                  _settingsController.switchLang("en");

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

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ListTile(
      tileColor: Colors.white,
      focusColor: Colors.white,
      hoverColor: Colors.white,
      selectedTileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      onTap: () async {
        changeLanguage();
      },
      leading: CircleAvatar(
        backgroundImage: AssetImage(
          Get.locale!.languageCode.toString() == "tr"
              ? tmIcon
              : Get.locale!.languageCode.toString() == "ru"
                  ? ruIcon
                  : enIcon,
        ),
        radius: 18,
      ),
      title: Text(
        Get.locale!.languageCode.toString() == "tr"
            ? "Türkmen dili"
            : Get.locale!.languageCode.toString() == "ru"
                ? "Rus dili"
                : "English",
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
      ),
      trailing: const Icon(
        IconlyLight.arrowRightCircle,
        color: Colors.black,
        size: 20,
      ),
    ),
  );
}

Padding shareApp() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ListTile(
      tileColor: Colors.white,
      focusColor: Colors.white,
      hoverColor: Colors.white,
      selectedTileColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      onTap: () {
        Share.share('https://play.google.com/store/apps/details?id=com.bilermennesil.sharafyabi', subject: 'Sharafýabi');
      },
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius15), child: Image.asset("assets/icons/share.png", width: 25)),
      title: Text(
        "share".tr,
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
      ),
      trailing: const Icon(
        IconlyLight.arrowRightCircle,
        color: Colors.black,
        size: 18,
      ),
    ),
  );
}
