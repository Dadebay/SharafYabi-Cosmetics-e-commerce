// ignore_for_file: file_names, must_be_immutable, always_use_package_imports, avoid_void_async, non_constant_identifier_names

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/screens/Category_Brands/CategoryPage.dart';
import 'package:sharaf_yabi_ecommerce/screens/News_Videos/TabbarViewPage.dart';

import 'Cart/CartPage.dart';
import 'HomePage/HomePage.dart';
import 'UserProfil/UserProfilPage.dart';

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {
  TabController? tabController;
  PersistentTabController? _controller;
  @override
  void initState() {
    super.initState();
    Get.find<Fav_Cart_Controller>().returnFavList();
    Get.find<Fav_Cart_Controller>().returnCartList();
    tabController = TabController(vsync: this, length: 5);
    _controller = PersistentTabController();
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      CategoryPage(),
      CartPage(), //
      const TabbarViewPage(), //
      UserProfil()
    ];
  }

  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return PersistentTabView.custom(
      context,
      controller: _controller,
      screens: _buildScreens(),
      resizeToAvoidBottomInset: true,
      itemCount: 5,
      screenTransitionAnimation: const ScreenTransitionAnimation(animateTabTransition: true),
      customWidget: CustomNavBarWidget(
        items: [
          PersistentBottomNavBarItem(
            activeColorPrimary: kPrimaryColor,
            inactiveColorPrimary: Colors.grey,
            inactiveIcon: const Icon(IconlyLight.home),
            icon: const Icon(IconlyBold.home),
            title: 'homePage'.tr,
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: kPrimaryColor,
            inactiveColorPrimary: Colors.grey,
            inactiveIcon: const Icon(IconlyLight.category),
            icon: const Icon(IconlyBold.category),
            title: 'category'.tr,
          ),
          PersistentBottomNavBarItem(
            inactiveIcon: Obx(() {
              return Get.find<Fav_Cart_Controller>().cartList.isEmpty
                  ? const Icon(CupertinoIcons.cart)
                  : Badge(
                      badgeContent: Text('${Get.find<Fav_Cart_Controller>().cartList.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: montserratMedium)),
                      animationType: BadgeAnimationType.fade,
                      child: const Icon(CupertinoIcons.cart));
            }),
            icon: Obx(() {
              return Get.find<Fav_Cart_Controller>().cartList.isEmpty
                  ? const Icon(CupertinoIcons.cart_fill)
                  : Badge(
                      badgeContent: Text('${Get.find<Fav_Cart_Controller>().cartList.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: montserratMedium)),
                      animationType: BadgeAnimationType.fade,
                      child: const Icon(CupertinoIcons.cart_fill));
            }),
            title: Get.find<Fav_Cart_Controller>().cartList.isEmpty ? 'cart'.tr : "${Get.find<Fav_Cart_Controller>().priceAll.value.toStringAsFixed(2)} m.",
            activeColorPrimary: kPrimaryColor,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: kPrimaryColor,
            inactiveColorPrimary: Colors.grey,
            inactiveIcon: const Icon(IconlyLight.paper),
            icon: const Icon(IconlyBold.paper),
            title: 'news'.tr,
          ),
          PersistentBottomNavBarItem(
            activeColorPrimary: kPrimaryColor,
            inactiveColorPrimary: Colors.grey,
            inactiveIcon: const Icon(IconlyLight.profile),
            icon: const Icon(IconlyBold.profile),
            title: 'profil'.tr,
          ),
        ],
        selectedIndex: _controller!.index,
        onItemSelected: (index) {
          setState(() {
            if (index == 2) {
              Get.find<CartPageController>().loadData(parametrs: {"products": jsonEncode(Get.find<Fav_Cart_Controller>().cartList)});
            }
            _controller!.index = index;
          });
        },
      ),
    );
  }
}

class CustomNavBarWidget extends StatelessWidget {
  final int? selectedIndex;
  final List<PersistentBottomNavBarItem>? items;
  final ValueChanged<int>? onItemSelected;

  const CustomNavBarWidget({
    this.selectedIndex,
    this.items,
    this.onItemSelected,
  });

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Tooltip(
      message: "${item.title}",
      textStyle: const TextStyle(fontFamily: "Poppins", color: Colors.white),
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: IconTheme(
                data: IconThemeData(size: 24.0, color: isSelected ? (item.activeColorSecondary ?? item.activeColorPrimary) : item.inactiveColorPrimary ?? item.activeColorPrimary),
                child: isSelected ? item.icon : item.inactiveIcon ?? const SizedBox.shrink(),
              ),
            ),
            Text("${item.title}",
                maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isSelected ? kPrimaryColor : Colors.grey, fontSize: isSelected ? 12 : 11, fontFamily: montserratMedium))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items!.map((item) {
            final int index = items!.indexOf(item);
            return Flexible(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, primary: kPrimaryColor.withOpacity(0.4), side: BorderSide.none),
                onPressed: () {
                  onItemSelected!(index);
                },
                child: _buildItem(item, selectedIndex == index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
