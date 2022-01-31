// ignore_for_file: file_names, must_be_immutable, always_use_package_imports

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'Cart/CartPage.dart';
import 'Category/CategoryPage.dart';
import 'HomePage/HomePage.dart';
import 'News/News.dart';
import 'UserProfil/UserProfilPage.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    Get.find<Fav_Cart_Controller>().returnFavList();
    Get.find<Fav_Cart_Controller>().returnCartList();
    tabController = TabController(vsync: this, length: 5);
  }

  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: kPrimaryColor, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [const HomePage(), CategoryPage(), CartPage(), News(), UserProfil()],
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: BottomNavigationBar(
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
      ),
    );
  }
}
