// ignore_for_file: file_names, avoid_bool_literals_in_conditional_expressions, avoid_dynamic_calls, non_constant_identifier_names

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/ProductProfil.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/screens/Cart/OrderPage.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/pages/FavoritePage/Components/FavCardShimmer.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartPageController cartPageController = Get.put(CartPageController());
  final Fav_Cart_Controller favCartController = Get.put(Fav_Cart_Controller());
  @override
  void initState() {
    super.initState();
    cartPageController.loadData(parametrs: {"products": jsonEncode(Get.find<Fav_Cart_Controller>().cartList)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor.withOpacity(0.6),
        floatingActionButton: favCartController.cartList.isEmpty ? const SizedBox.shrink() : floatingActionButton(),
        appBar: MyAppBar(
          backArrow: false,
          iconRemove: favCartController.cartList.isNotEmpty ? true : false,
          icon: IconlyLight.delete,
          onTap: () {
            cartPageController.list.clear();
            favCartController.clearCartList();
            setState(() {});
          },
        ),
        body: Obx(() {
          if (cartPageController.loading.value == 1) {
            return favCartController.cartList.isEmpty
                ? emptyDataLottie(imagePath: "assets/lottie/emptyCart.json", errorTitle: "cartEmpty", errorSubtitle: "cartEmptySubtitle")
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cartPageController.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardMine(index);
                    },
                  );
          } else if (cartPageController.loading.value == 2) {
            return emptyDataLottie(imagePath: "assets/lottie/emptyCart.json", errorTitle: "cartEmpty", errorSubtitle: "cartEmptySubtitle");
          } else if (cartPageController.loading.value == 0) {
            return FavCardShimmer();
          }
          return FavCardShimmer();
        }));
  }

  Widget floatingActionButton() {
    return FloatingActionButton.extended(
      elevation: 1,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
      onPressed: () {
        double sum = 0.0;
        int sumCount = 0;
        for (int i = 0; i < cartPageController.list.length; i++) {
          final double a = double.parse(cartPageController.list[i]["price"]);
          final int b = cartPageController.list[i]["count"];
          sum += a * b;
          sumCount += b;
        }
        Get.to(() => OrderPage(
              totalPrice: sum,
              productCount: sumCount,
            ));
      },
      backgroundColor: kPrimaryColor,
      splashColor: kPrimaryColor,
      hoverColor: Colors.white,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              CupertinoIcons.shopping_cart,
              size: 22,
              color: Colors.white,
            ),
          ),
          Text(
            "order".tr,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: Colors.white),
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
    );
  }

  Widget CardMine(int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductProfil(
              id: cartPageController.list[index]["id"],
              productName: cartPageController.list[index]["name"],
              image: "$serverImage/${cartPageController.list[index]["image"]}-mini.webp",
            ));
      },
      child: Container(
        height: 140,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(borderRadius: borderRadius15, color: backgroundColor.withOpacity(0.6)),
                child: CachedNetworkImage(
                    fadeInCurve: Curves.ease,
                    color: Colors.black,
                    imageUrl: "$serverImage/${cartPageController.list[index]["image"]}-mini.webp",
                    imageBuilder: (context, imageProvider) => Container(
                          padding: EdgeInsets.zero,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                    placeholder: (context, url) => Center(child: spinKit()),
                    errorWidget: (context, url, error) => noImage()),
              ),
            ),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${cartPageController.list[index]["name"]}",
                          overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.start, style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16)),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(text: "${cartPageController.list[index]["price"]}", style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 20, color: Colors.black)),
                          const TextSpan(text: "  TMT", style: TextStyle(fontFamily: montserratMedium, fontSize: 16, color: Colors.black))
                        ]),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              final int id = cartPageController.list[index]["id"];
                              cartPageController.removeCard(id);
                              favCartController.removeCart(id);
                              setState(() {});
                            },
                            child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                                child: cartPageController.list[index]["count"] == 1
                                    ? const Icon(
                                        IconlyLight.delete,
                                        color: Colors.grey,
                                      )
                                    : const Icon(CupertinoIcons.minus)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "${cartPageController.list[index]["count"]}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black, fontFamily: montserratBold, fontSize: 18),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              cartPageController.addToCard(cartPageController.list[index]["id"]);
                              favCartController.addCart(cartPageController.list[index]["id"]);
                            },
                            child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
                                child: const Icon(CupertinoIcons.add, color: Colors.white)),
                          ),
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
