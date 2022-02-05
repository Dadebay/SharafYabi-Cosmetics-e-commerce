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

  @override
  void initState() {
    super.initState();
    Get.find<CartPageController>().loadData(parametrs: {"products": jsonEncode(Get.find<Fav_Cart_Controller>().cartList)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor.withOpacity(0.2),
        floatingActionButton: Get.find<Fav_Cart_Controller>().cartList.isEmpty ? const SizedBox.shrink() : floatingActionButton(),
        appBar: MyAppBar(
          backArrow: false,
          iconRemove: Get.find<Fav_Cart_Controller>().cartList.isNotEmpty ? true : false,
          icon: IconlyLight.delete,
          onTap: () {
            Get.find<CartPageController>().list.clear();
            Get.find<Fav_Cart_Controller>().clearCartList();
            setState(() {});
          },
        ),
        body: Obx(() {
          if (Get.find<CartPageController>().loading.value == 1) {
            return Get.find<Fav_Cart_Controller>().cartList.isEmpty
                ? emptyDataLottie(imagePath: "assets/lottie/emptyCart.json", errorTitle: "cartEmpty", errorSubtitle: "cartEmptySubtitle")
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: Get.find<CartPageController>().list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardMine(index);
                    },
                  );
          } else if (Get.find<CartPageController>().loading.value == 2) {
            return emptyDataLottie(imagePath: "assets/lottie/emptyCart.json", errorTitle: "cartEmpty", errorSubtitle: "cartEmptySubtitle");
          } else if (Get.find<CartPageController>().loading.value == 0) {
            return FavCardShimmer();
          }
          return FavCardShimmer();
        }));
  }

  Widget floatingActionButton() {
    return FloatingActionButton.extended(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        double sum = 0.0;
        int sumCount = 0;
        for (int i = 0; i < Get.find<CartPageController>().list.length; i++) {
          final double a = double.parse(Get.find<CartPageController>().list[i]["price"]);
          final int b = Get.find<CartPageController>().list[i]["count"];
          sum += a * b;
          sumCount += b;
        }
        Get.to(() => OrderPage(
              totalPrice: sum,
              productCount: sumCount,
            ));
      },
      backgroundColor: kPrimaryColor,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 10),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "order".tr,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              IconlyLight.arrowRightCircle,
              size: 20,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget CardMine(int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductProfil(
              id: Get.find<CartPageController>().list[index]["id"],
              productName: Get.find<CartPageController>().list[index]["name"],
              image: "$serverImage/${Get.find<CartPageController>().list[index]["image"]}-mini.webp",
            ));
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: backgroundColor.withOpacity(0.4), borderRadius: borderRadius15),
                child: CachedNetworkImage(
                    fadeInCurve: Curves.ease,
                    imageUrl: "$serverImage/${Get.find<CartPageController>().list[index]["image"]}-mini.webp",
                    imageBuilder: (context, imageProvider) => Container(
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius10,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                    placeholder: (context, url) => Center(child: spinKit()),
                    errorWidget: (context, url, error) => Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Image.asset(
                            "assets/appLogo/greyLogo.png",
                            color: Colors.grey,
                          ),
                        )),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text("${Get.find<CartPageController>().list[index]["name"]}",
                                  overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18))),
                          GestureDetector(
                            onTap: () {
                              final int id = Get.find<CartPageController>().list[index]["id"];
                              Get.find<CartPageController>().removeCardClear(id);
                              setState(() {});
                            },
                            child: const Icon(CupertinoIcons.xmark_circle, color: Colors.black, size: 24),
                          ),
                        ],
                      ),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(text: "${Get.find<CartPageController>().list[index]["price"]}", style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 20, color: Colors.black)),
                          const TextSpan(text: "  TMT", style: TextStyle(fontFamily: montserratMedium, fontSize: 16, color: Colors.black))
                        ]),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              final int id = Get.find<CartPageController>().list[index]["id"];

                              Get.find<CartPageController>().removeCard(id);
                              Get.find<Fav_Cart_Controller>().removeCart(id);
                              setState(() {});
                            },
                            child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle), child: const Icon(CupertinoIcons.minus)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "${Get.find<CartPageController>().list[index]["count"]}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black, fontFamily: montserratBold, fontSize: 18),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.find<CartPageController>().addToCard(Get.find<CartPageController>().list[index]["id"]);
                              Get.find<Fav_Cart_Controller>().addCart(Get.find<CartPageController>().list[index]["id"]);
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
