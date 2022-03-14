import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/ProductProfilPage/ProductProfil.dart';
import 'package:vibration/vibration.dart';

class CartCard extends StatefulWidget {
  final int id;
  final String name;
  final String price;
  final String image;
  final int discountValue;
  final int count;
  final int stockMin;

  const CartCard({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.discountValue,
    required this.count,
    required this.stockMin,
  }) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int discountValue = 0;
  double discountedPrice = 0.0;
  double priceMine = 0.0;
  double priceOLD = 0.0;
  int _count = 0;
  whenDataComes() {
    _count = widget.count;
    priceMine = double.parse(widget.price);
    priceOLD = priceMine;

    if (widget.discountValue != 0) {
      discountValue = widget.discountValue;
      discountedPrice = (priceMine * discountValue) / 100;
      priceMine -= discountedPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    whenDataComes();
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: ProductProfil(
            id: widget.id,
            productName: widget.name,
            image: widget.image,
          ),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      },
      child: Container(
        height: 140,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius10),
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
                        imageUrl: widget.image,
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
                  if (widget.discountValue > 0)
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
                      Text("${widget.name}",
                          overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.start, style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16)),
                      if (widget.discountValue > 0)
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
                          "$priceOLD m.",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: Colors.black),
                        ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showCustomToast(
                                context,
                                "productCountAdded".tr,
                              );
                              _count--;
                              if (_count == 0) {
                                showCustomToast(
                                  context,
                                  "removedFromCartTitle".tr,
                                );
                              }
                              print(discountValue);
                              Get.find<CartPageController>().removeCard(widget.id);
                              Get.find<Fav_Cart_Controller>().removeCart(widget.id);
                              Get.find<HomePageController>().searchAndRemove(widget.id);
                              setState(() {});
                            },
                            child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle), child: const Icon(CupertinoIcons.minus)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "$_count",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black, fontFamily: montserratBold, fontSize: 18),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              int a = _count + 1;
                              if (widget.stockMin > a) {
                                showCustomToast(
                                  context,
                                  "productCountAdded".tr,
                                );
                                Get.find<HomePageController>().searchAndAdd(widget.id, "$priceMine");
                                Get.find<CartPageController>().addToCard(widget.id);
                                Get.find<Fav_Cart_Controller>().addCart(widget.id, "$priceMine");
                              } else {
                                Vibration.vibrate();
                                showCustomToast(
                                  context,
                                  "emptyStockCount".tr,
                                );
                              }
                              setState(() {
                                _count++;
                              });
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
