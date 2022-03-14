// ignore_for_file: file_names, avoid_bool_literals_in_conditional_expressions, avoid_dynamic_calls, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/cards/CartCard.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/shimmers.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';
import 'package:sharaf_yabi_ecommerce/screens/Cart/OrderPage.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartPageController cartPageController = Get.put(CartPageController());

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
        if (Get.find<Fav_Cart_Controller>().priceAll.value > 49.9) {
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
        } else {
          showSnackBar("emptyStockMin", "minSumCount", Colors.red);
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor.withOpacity(0.6),
        floatingActionButton: Get.find<Fav_Cart_Controller>().cartList.isEmpty ? const SizedBox.shrink() : floatingActionButton(),
        appBar: MyAppBar(
          backArrow: false,
          iconRemove: Get.find<Fav_Cart_Controller>().cartList.isNotEmpty ? true : false,
          icon: IconlyLight.delete,
          onTap: () {
            cartPageController.list.clear();
            Get.find<Fav_Cart_Controller>().clearCartList();
            Get.find<FilterController>().list.clear();
            Get.find<FilterController>().fetchProducts();
            setState(() {
              Get.find<HomePageController>().refreshList();
            });
          },
        ),
        body: Obx(() {
          if (cartPageController.loading.value == 1) {
            return Get.find<Fav_Cart_Controller>().cartList.isEmpty
                ? Center(child: emptyDataLottie(imagePath: emptyCart, errorTitle: "cartEmpty", errorSubtitle: "cartEmptySubtitle"))
                : Stack(
                    children: [
                      Get.find<Fav_Cart_Controller>().priceAll.value > 49.9
                          ? SizedBox.shrink()
                          : Positioned(
                              bottom: 80,
                              left: 0,
                              right: 0,
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(14),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.2), borderRadius: borderRadius5),
                                child: Text(
                                  "minSumCount".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 16),
                                ),
                              )),
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: cartPageController.list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CartCard(
                              discountValue: cartPageController.list[index]["discountValue"] ?? 0,
                              count: cartPageController.list[index]["count"],
                              id: cartPageController.list[index]["id"],
                              image: "$serverImage/${cartPageController.list[index]["image"]}-mini.webp",
                              name: cartPageController.list[index]["name"],
                              price: cartPageController.list[index]["price"],
                              stockMin: int.parse(cartPageController.list[index]["stockMin"]));
                        },
                      ),
                    ],
                  );
          } else if (cartPageController.loading.value == 2) {
            return emptyDataLottie(imagePath: emptyCart, errorTitle: "cartEmpty", errorSubtitle: "cartEmptySubtitle");
          } else if (cartPageController.loading.value == 0) {
            return cartCardShimmer();
          }
          return cartCardShimmer();
        }));
  }
}
