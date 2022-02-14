// ignore_for_file: file_names, must_be_immutable, always_use_package_imports, avoid_void_async

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/screens/News/TabbarViewPage.dart';
import 'Cart/CartPage.dart';
import 'Category/CategoryPage.dart';
import 'HomePage/HomePage.dart';
import 'UserProfil/UserProfilPage.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {
  late TabController tabController;
  final SettingsController _settingsController = Get.put<SettingsController>(SettingsController());
  @override
  void initState() {
    super.initState();
    Get.find<Fav_Cart_Controller>().returnFavList();
    Get.find<Fav_Cart_Controller>().returnCartList();
    tabController = TabController(vsync: this, length: 5);
    checkConnection();
  }

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _settingsController.connectionState.value = true;
      }
    } on SocketException catch (_) {
      _settingsController.connectionState.value = false;
    }
  }

  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: kPrimaryColor, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          return TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: _settingsController.connectionState.value
                ? [const HomePage(), CategoryPage(), CartPage(), const TabbarViewPage(), UserProfil()]
                : [
                    errorConnection(onTap: () {
                      checkConnection();
                    }),
                    errorConnection(onTap: () {
                      checkConnection();
                    }),
                    errorConnection(onTap: () {
                      checkConnection();
                    }),
                    errorConnection(onTap: () {
                      checkConnection();
                    }),
                    errorConnection(onTap: () {
                      checkConnection();
                    }),
                  ],
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              selectedPageIndex = index;

              tabController.animateTo(selectedPageIndex);
            });
          },
          selectedLabelStyle: const TextStyle(color: kPrimaryColor, fontFamily: montserratSemiBold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(color: Colors.black87, fontFamily: montserratMedium, fontSize: 11),
          currentIndex: selectedPageIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: kPrimaryColor,
          iconSize: 26,
          elevation: 2,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(label: 'homePage'.tr, icon: Icon(selectedPageIndex == 0 ? IconlyBold.home : IconlyLight.home)),
            BottomNavigationBarItem(label: 'category'.tr, icon: Icon(selectedPageIndex == 1 ? IconlyBold.category : IconlyLight.category)),
            BottomNavigationBarItem(label: 'cart'.tr, icon: Icon(selectedPageIndex == 2 ? IconlyBold.bag : IconlyLight.bag)),
            BottomNavigationBarItem(label: 'news'.tr, icon: Icon(selectedPageIndex == 3 ? IconlyBold.paper : IconlyLight.paper)),
            BottomNavigationBarItem(label: 'profil'.tr, icon: Icon(selectedPageIndex == 4 ? IconlyBold.profile : IconlyLight.profile)),
          ],
        ),
      ),
    );
  }
}
