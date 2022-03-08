// ignore_for_file: file_names, deprecated_member_use, always_use_package_imports, avoid_bool_literals_in_conditional_expressions, non_constant_identifier_names, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/cards/ProductCard3.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final HomePageController _homePageController = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
    _homePageController.fetcbFavListProducts();
  }

  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: MyAppBar(
            icon: IconlyLight.delete,
            addName: true,
            name: "favorite",
            onTap: () {
              Get.find<Fav_Cart_Controller>().clearFavList();
              _homePageController.refreshList();
              Get.find<FilterController>().list.clear();
              Get.find<FilterController>().fetchProducts();
              setState(() {});
            },
            backArrow: true,
            iconRemove: Get.find<Fav_Cart_Controller>().favList.isNotEmpty ? true : false),
        body: Obx(() {
          if (_homePageController.loadingFavlist.value == 1) {
            return Get.find<Fav_Cart_Controller>().favList.isEmpty
                ? emptyData(imagePath: emptyFav, errorTitle: "emptyFavoriteTitle", errorSubtitle: "emptyFavoriteSubtitle")
                : GridView.builder(
                    itemCount: _homePageController.listFavlist.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: sizeWidth > 800 ? 3 : 2, childAspectRatio: 1.5 / 2.5),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard3(
                        id: _homePageController.listFavlist[index]["id"] ?? 1,
                        name: _homePageController.listFavlist[index]["name"] ?? "asdasd",
                        price: _homePageController.listFavlist[index]["price"],
                        image: _homePageController.listFavlist[index]["image"],
                        discountValue: _homePageController.listFavlist[index]["discountValue"],
                        stockCount: _homePageController.listFavlist[index]["stockCount"],
                      );
                    });
          } else if (_homePageController.loadingFavlist.value == 3) {
            return retryButton(() {
              _homePageController.fetcbFavListProducts();
            });
          } else if (_homePageController.loadingFavlist.value == 2) {
            return emptyData(imagePath: emptyFav, errorTitle: "emptyFavoriteTitle", errorSubtitle: "emptyFavoriteSubtitle");
          } else if (_homePageController.loadingFavlist.value == 0) {
            return Center(
              child: spinKit(),
            );
          }
          return emptyData(imagePath: emptyFav, errorTitle: "emptyFavoriteTitle", errorSubtitle: "emptyFavoriteSubtitle");
        }));
  }
}
