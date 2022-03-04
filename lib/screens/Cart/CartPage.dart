// ignore_for_file: file_names, avoid_bool_literals_in_conditional_expressions, avoid_dynamic_calls, non_constant_identifier_names

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/shimmers.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';
import 'package:sharaf_yabi_ecommerce/screens/Cart/OrderPage.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/ProductProfilPage/ProductProfil.dart';
import 'package:vibration/vibration.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartPageController cartPageController = Get.put(CartPageController());
  final Fav_Cart_Controller favCartController = Get.put(Fav_Cart_Controller());
  final HomePageController _homePageController = Get.put(HomePageController());
  final FilterController filterController = Get.put(FilterController());

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
            filterController.list.clear();
            filterController.fetchProducts();
            setState(() {
              _homePageController.refreshList();
            });
          },
        ),
        body: Obx(() {
          if (cartPageController.loading.value == 1) {
            return favCartController.cartList.isEmpty
                ? Center(child: emptyDataLottie(imagePath: emptyCart, errorTitle: "cartEmpty", errorSubtitle: "cartEmptySubtitle"))
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: cartPageController.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardMine(index);
                    },
                  );
          } else if (cartPageController.loading.value == 2) {
            return emptyDataLottie(imagePath: emptyCart, errorTitle: "cartEmpty", errorSubtitle: "cartEmptySubtitle");
          } else if (cartPageController.loading.value == 0) {
            return cartCardShimmer();
          }
          return cartCardShimmer();
        }));
  }

  Widget floatingActionButton() {
    return FloatingActionButton.extended(
      elevation: 1,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
      onPressed: () {
        double sum = 0.0;
        int sumCount = 0;
        double discountedPriceMine = 0.0;
        double a = 0.0;
        int discountValue = 0;
        for (int i = 0; i < cartPageController.list.length; i++) {
          a = double.parse(cartPageController.list[i]["price"]);
          discountValue = cartPageController.list[i]["discountValue"] ?? 0;
          discountedPriceMine = (a * discountValue) / 100;
          a -= discountedPriceMine;
          final int b = cartPageController.list[i]["count"];
          sum += a * b;
          sumCount += b;
        }
        pushNewScreen(
          context,
          screen: OrderPage(
            totalPrice: sum,
            productCount: sumCount,
          ),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
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

  double priceOLD = 0.0;
  double priceMine = 0.0;
  double discountedPrice = 0.0;
  int discountValue = 0;
  Widget CardMine(int index) {
    priceMine = double.parse(cartPageController.list[index]["price"]);
    if (cartPageController.list[index]["discountValue"] != null || cartPageController.list[index]["discountValue"] != 0) {
      priceOLD = priceMine;
      discountValue = cartPageController.list[index]["discountValue"] ?? 0;
      discountedPrice = (priceMine * discountValue) / 100;
      priceMine -= discountedPrice;
    }
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: ProductProfil(
            id: cartPageController.list[index]["id"],
            productName: cartPageController.list[index]["name"],
            image: "$serverImage/${cartPageController.list[index]["image"]}-mini.webp",
          ),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      },
      child: Container(
        height: 140,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius20),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(borderRadius: borderRadius15, color: Colors.white),
                    child: CachedNetworkImage(
                        fadeInCurve: Curves.ease,
                        imageUrl: "$serverImage/${cartPageController.list[index]["image"]}-mini.webp",
                        imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: borderRadius20,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                        placeholder: (context, url) => Center(child: spinKit()),
                        errorWidget: (context, url, error) => noImage()),
                  ),
                  if (discountValue != 0)
                    Positioned(
                      bottom: 15,
                      right: 15,
                      child: discountText("$discountValue"),
                    )
                  else
                    const SizedBox.shrink()
                ],
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
                      if (discountValue > 0)
                        Row(
                          children: [
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(text: "${priceMine.toStringAsFixed(2)}", style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 20, color: Colors.black)),
                                const TextSpan(text: "  m.", style: TextStyle(fontFamily: montserratMedium, fontSize: 16, color: Colors.black))
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Stack(
                                children: [
                                  Positioned(left: 0, right: 0, top: 12, child: Transform.rotate(angle: pi / -8, child: Container(height: 1, color: Colors.red))),
                                  Text("$priceOLD",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontFamily: montserratRegular, fontSize: 16, color: Colors.grey)),
                                ],
                              ),
                            )
                          ],
                        )
                      else
                        Text(
                          "${cartPageController.list[index]["price"]} m.",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: Colors.black),
                        ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              final int id = cartPageController.list[index]["id"];
                              cartPageController.removeCard(id);
                              favCartController.removeCart(id);
                              _homePageController.searchAndRemove(
                                cartPageController.list[index]["id"],
                              );

                              showCustomToast(
                                context,
                                "productCountAdded".tr,
                              );

                              setState(() {});
                            },
                            child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle), child: const Icon(CupertinoIcons.minus)),
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
                              final int stockCount = cartPageController.list[index]["count"];
                              final int quantity = cartPageController.list[index]["count"] + 1;
                              if (stockCount > quantity) {
                                showCustomToast(
                                  context,
                                  "productCountAdded".tr,
                                );
                                _homePageController.searchAndAdd(cartPageController.list[index]["id"], "$priceMine");
                                cartPageController.addToCard(cartPageController.list[index]["id"]);
                                favCartController.addCart(cartPageController.list[index]["id"], "$priceMine");
                              } else {
                                Vibration.vibrate();
                                showCustomToast(
                                  context,
                                  "emptyStockCount".tr,
                                );
                              }
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
