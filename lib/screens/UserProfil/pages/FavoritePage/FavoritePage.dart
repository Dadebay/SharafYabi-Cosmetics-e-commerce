// ignore_for_file: file_names, deprecated_member_use, always_use_package_imports, avoid_bool_literals_in_conditional_expressions, non_constant_identifier_names, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/cards/ProductCard3.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Fav_Cart_Controller fav_cart_controller = Get.put(Fav_Cart_Controller());
  final HomePageController _homePageController = Get.put(HomePageController());
  final FilterController filterController = Get.put(FilterController());

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
              fav_cart_controller.clearFavList();
              _homePageController.refreshList();
              filterController.list.clear();
              filterController.fetchProducts();
              setState(() {});
            },
            backArrow: true,
            iconRemove: fav_cart_controller.favList.isNotEmpty ? true : false),
        body: Obx(() {
          if (_homePageController.loadingFavlist.value == 1) {
            return fav_cart_controller.favList.isEmpty
                ? emptyData(imagePath: emptyFav, errorTitle: "emptyFavoriteTitle", errorSubtitle: "emptyFavoriteSubtitle")
                : GridView.builder(
                    itemCount: _homePageController.listFavlist.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: sizeWidth > 800 ? 3 : 2, childAspectRatio: 1.5 / 2.5),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: sizeWidth > 800 ? 220 : 180,
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.only(
                          bottom: 4,
                        ),
                        child: ProductCard3(
                          id: _homePageController.listFavlist[index]["id"],
                          name: _homePageController.listFavlist[index]["name"],
                          price: _homePageController.listFavlist[index]["price"],
                          image: _homePageController.listFavlist[index]["image"],
                          discountValue: _homePageController.listFavlist[index]["discountValue"],
                        ),
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
          return Center(
            child: spinKit(),
          );
        }));
  }
}
