// ignore_for_file: file_names, must_be_immutable, always_use_package_imports, avoid_void_async, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
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
  late PersistentTabController _controller;
  final SettingsController _settingsController = Get.put<SettingsController>(SettingsController());
  final Fav_Cart_Controller fav_cart_controller = Get.put<Fav_Cart_Controller>(Fav_Cart_Controller());
  @override
  void initState() {
    super.initState();
    fav_cart_controller.returnFavList();
    fav_cart_controller.returnCartList();
    tabController = TabController(vsync: this, length: 5);
    _controller = PersistentTabController();
    checkConnection();
  }

  void checkConnection() async {
    try {
      final result = await InternetAddress.lookup('sharafyabi.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _settingsController.connectionState.value = true;
      }
    } on SocketException catch (_) {
      _settingsController.connectionState.value = false;
    }
  }

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      CategoryPage(),
      CartPage(), //
      const TabbarViewPage(), //
      UserProfil()
    ];
  }

  int selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      return _settingsController.connectionState.value
          ? PersistentTabView.custom(
              context,
              controller: _controller,
              screens: _buildScreens(),
              resizeToAvoidBottomInset: true,
              itemCount: 5,
              backgroundColor: kPrimaryColor,
              screenTransitionAnimation: const ScreenTransitionAnimation(animateTabTransition: true),
              customWidget: CustomNavBarWidget(
                items: [
                  PersistentBottomNavBarItem(
                    activeColorPrimary: Colors.white,
                    inactiveColorPrimary: Colors.white70,
                    inactiveIcon: const Icon(IconlyLight.home),
                    icon: const Icon(IconlyBold.home),
                    title: 'homePage'.tr,
                    textStyle: const TextStyle(color: Colors.white70, fontFamily: montserratMedium),
                  ),
                  PersistentBottomNavBarItem(
                    activeColorPrimary: Colors.white,
                    inactiveIcon: const Icon(IconlyLight.category),
                    icon: const Icon(IconlyBold.category),
                    title: 'category'.tr,
                    textStyle: const TextStyle(color: Colors.white70, fontFamily: montserratMedium),
                    inactiveColorPrimary: Colors.white70,
                  ),
                  PersistentBottomNavBarItem(
                    inactiveIcon: fav_cart_controller.cartList.isEmpty
                        ? const Icon(IconlyLight.bag)
                        : Badge(
                            badgeContent: Text('${fav_cart_controller.cartList.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: montserratMedium)),
                            animationType: BadgeAnimationType.fade,
                            child: const Icon(IconlyLight.bag)),
                    icon: fav_cart_controller.cartList.isEmpty
                        ? const Icon(IconlyBold.bag)
                        : Badge(
                            badgeContent: Text('${fav_cart_controller.cartList.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontFamily: montserratMedium)),
                            animationType: BadgeAnimationType.fade,
                            child: const Icon(IconlyBold.bag)),
                    activeColorPrimary: Colors.white,
                    title: fav_cart_controller.cartList.isEmpty ? 'cart'.tr : "${fav_cart_controller.priceAll.value} TMT",
                    onPressed: (context) {},
                    textStyle: const TextStyle(color: Colors.white70, fontFamily: montserratMedium),
                    inactiveColorPrimary: Colors.white70,
                  ),
                  PersistentBottomNavBarItem(
                    activeColorPrimary: Colors.white,
                    inactiveIcon: const Icon(IconlyLight.paper),
                    icon: const Icon(IconlyBold.paper),
                    title: 'news'.tr,
                    onPressed: (context) {},
                    textStyle: const TextStyle(color: Colors.white70, fontFamily: montserratMedium),
                    inactiveColorPrimary: Colors.white70,
                  ),
                  PersistentBottomNavBarItem(
                    activeColorPrimary: Colors.white,
                    inactiveIcon: const Icon(IconlyLight.profile),
                    icon: const Icon(IconlyBold.profile),
                    title: 'profil'.tr,
                    textStyle: const TextStyle(color: Colors.white70, fontFamily: montserratMedium),
                    inactiveColorPrimary: Colors.white70,
                  ),
                ],
                selectedIndex: _controller.index,
                onItemSelected: (index) {
                  if (index == 0) {
                  } else if (index == 1) {
                  } else if (index == 2) {
                    Get.find<CartPageController>().loadData(parametrs: {"products": jsonEncode(Get.find<Fav_Cart_Controller>().cartList)});
                  } else if (index == 3) {
                  } else if (index == 4) {}
                  setState(() {
                    _controller.index = index;
                  });
                },
              ),
            )
          : errorConnection(
              onTap: () {
                checkConnection();
              },
              sizeWidth: sizeWidth);
    });
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
                data: IconThemeData(size: 26.0, color: isSelected ? (item.activeColorSecondary ?? item.activeColorPrimary) : item.inactiveColorPrimary ?? item.activeColorPrimary),
                child: isSelected ? item.icon : item.inactiveIcon ?? const SizedBox.shrink(),
              ),
            ),
            Text("${item.title}",
                maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: isSelected ? 13 : 12, fontFamily: montserratMedium))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kPrimaryColor,
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
                style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))), padding: EdgeInsets.zero, primary: kPrimaryColor.withOpacity(0.4), side: BorderSide.none),
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
