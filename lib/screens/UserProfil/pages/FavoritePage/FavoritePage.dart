// ignore_for_file: file_names, deprecated_member_use, always_use_package_imports, avoid_bool_literals_in_conditional_expressions, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/ProductCard3.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductsModel.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Fav_Cart_Controller fav_cart_controller = Get.put(Fav_Cart_Controller());
  final HomePageController _homePageController = Get.put(HomePageController());

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
              _homePageController.list.clear();
              _homePageController.listNewInCome.clear();
              _homePageController.listRecomended.clear();
              _homePageController.fetchDiscountedProducts();
              _homePageController.fetchPopularProducts();
              _homePageController.fetchNewInComeProducts();
              setState(() {});
            },
            backArrow: true,
            iconRemove: fav_cart_controller.favList.isNotEmpty ? true : false),
        body: Obx(() {
          return fav_cart_controller.favList.isEmpty
              ? GestureDetector(onTap: () {}, child: emptyData(imagePath: "assets/emptyState/emptyFav.png", errorTitle: "emptyFavoriteTitle", errorSubtitle: "emptyFavoriteSubtitle"))
              : FutureBuilder<List<ProductsModel>>(
                  future: ProductsModel().getFavorites(parametrs: {"products": jsonEncode(fav_cart_controller.favList)}),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return errorConnection(
                          onTap: () {
                            ProductsModel().getFavorites(parametrs: {"products": jsonEncode(fav_cart_controller.favList)});
                          },
                          sizeWidth: sizeWidth);
                    } else if (snapshot.hasData) {
                      return GridView.builder(
                        itemCount: snapshot.data?.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: sizeWidth > 800 ? 3 : 2, childAspectRatio: 1.5 / 2.5),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProductCard3(
                              id: snapshot.data![index].id,
                              name: snapshot.data![index].productName,
                              price: snapshot.data![index].price,
                              image: snapshot.data![index].imagePath,
                              discountValue: snapshot.data![index].discountValue,
                              whichList: 1,
                              index: index,
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: spinKit(),
                    );
                  });
        }));
  }
}
