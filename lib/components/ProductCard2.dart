// ignore_for_file: deprecated_member_use, file_names, avoid_dynamic_calls, invariant_booleans, always_use_package_imports

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';

import 'ProductProfil.dart';

class ProductCard2 extends StatefulWidget {
  final int indexx;
  const ProductCard2({
    Key? key,
    required this.indexx,
  }) : super(key: key);
  @override
  _ProductCard2State createState() => _ProductCard2State();
}

class _ProductCard2State extends State<ProductCard2> {
  final FilterController _filterController = Get.put<FilterController>(FilterController());
  Fav_Cart_Controller favCartController = Get.put<Fav_Cart_Controller>(Fav_Cart_Controller());
  final HomePageController _homePageController = Get.put(HomePageController());

  bool favButton = false;
  bool addCart = false;

  @override
  void initState() {
    super.initState();
    if (favCartController.favList.isNotEmpty) {
      for (final element in favCartController.favList) {
        if (element["id"] == _filterController.list[widget.indexx]!["id"]) {
          favButton = true;
        }
      }
    } else {
      favButton = false;
    }
    if (favCartController.cartList.isNotEmpty) {
      for (final element in favCartController.cartList) {
        if (element["id"] == _filterController.list[widget.indexx]!["id"]) {
          addCart = true;
        }
      }
    } else {
      addCart = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: ProductProfil(
            id: _filterController.list[widget.indexx]!["id"],
            productName: _filterController.list[widget.indexx]["name"],
            image: "$serverImage/${_filterController.list[widget.indexx]["image"]}-mini.webp",
          ),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Material(
        elevation: 1,
        shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              imageExpanded(),
              nameAndButtonPart(sizeWidth),
            ],
          ),
        ),
      ),
    );
  }

  double priceOLD = 0.0;
  double priceMine = 0.0;
  double discountedPrice = 0.0;
  int discountValue = 0;
  Padding nameAndButtonPart(double sizeWidth) {
    priceMine = double.parse(_filterController.list[widget.indexx]["price"]);
    if (_filterController.list[widget.indexx]["discountValue"] != null || _filterController.list[widget.indexx]["discountValue"] != 0) {
      priceOLD = priceMine;
      discountValue = _filterController.list[widget.indexx]["discountValue"] ?? 0;
      discountedPrice = (priceMine * discountValue) / 100;
      priceMine -= discountedPrice;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7, bottom: 3, top: 7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            _filterController.list[widget.indexx]["name"],
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: montserratRegular, fontSize: sizeWidth / 34),
          ),
          if (discountValue > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$priceMine m.",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: kPrimaryColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Stack(
                    children: [
                      Positioned(left: 0, right: 5, top: 10, child: Transform.rotate(angle: pi / -14, child: Container(height: 1, color: Colors.red))),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(text: "$priceOLD", style: const TextStyle(fontFamily: montserratRegular, fontSize: 16, color: Colors.grey)),
                          const TextSpan(text: " m.", style: TextStyle(fontFamily: montserratRegular, fontSize: 10, color: Colors.grey))
                        ]),
                      ),
                    ],
                  ),
                )
              ],
            )
          else
            Text(
              "$priceMine m.",
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: kPrimaryColor),
            ),
          SizedBox(
            width: Get.size.width,
            child: addCart
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (favCartController.cartList.isEmpty) {
                                addCart = false;
                              } else {
                                for (final element in _filterController.list) {
                                  if (element["id"] == _filterController.list[widget.indexx]["id"]) {
                                    _filterController.list[widget.indexx]["count"]--;
                                    if (element["count"] == 0) {
                                      addCart = false;
                                    }
                                  }
                                }
                              }
                              showCustomToast(
                                context,
                                "productCountAdded".tr,
                              );
                              _homePageController.searchAndRemove(
                                _filterController.list[widget.indexx]["id"]!,
                              );

                              favCartController.removeCart(_filterController.list[widget.indexx]["id"]);
                            });
                          },
                          child: PhysicalModel(
                            elevation: 1,
                            color: Colors.transparent,
                            borderRadius: borderRadius5,
                            child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(borderRadius: borderRadius5, color: kPrimaryColor),
                                child: const Icon(
                                  CupertinoIcons.minus,
                                  size: 22,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        GetX<FilterController>(
                          init: FilterController(),
                          initState: (_) {},
                          builder: (_) {
                            return Text(
                              "${_filterController.list[widget.indexx]["count"]}",
                              style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
                            );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              for (final element2 in _filterController.list) {
                                if (element2["id"] == _filterController.list[widget.indexx]["id"]) {
                                  element2["count"]++;
                                  showCustomToast(
                                    context,
                                    "productCountAdded".tr,
                                  );
                                  _homePageController.searchAndAdd(_filterController.list[widget.indexx]["id"]!, "${_filterController.list[widget.indexx]["price"]}");

                                  favCartController.addCart(_filterController.list[widget.indexx]["id"], _filterController.list[widget.indexx]["price"]);
                                }
                              }
                            });
                          },
                          child: PhysicalModel(
                            elevation: 1,
                            borderRadius: borderRadius5,
                            color: Colors.transparent,
                            child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(borderRadius: borderRadius5, color: kPrimaryColor),
                                child: const Icon(
                                  CupertinoIcons.add,
                                  size: 22,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  )
                : RaisedButton(
                    onPressed: () {
                      setState(() {
                        showCustomToast(
                          context,
                          "addedToCardSubtitle".tr,
                        );
                        addCart = !addCart;
                        if (_filterController.list[widget.indexx]["count"] == 0) {
                          _filterController.list[widget.indexx]["count"]++;
                        } else {
                          _homePageController.searchAndAdd(_filterController.list[widget.indexx]["id"]!, "${_filterController.list[widget.indexx]["price"]}");

                          favCartController.addCart(_filterController.list[widget.indexx]["id"], _filterController.list[widget.indexx]["price"]);
                        }
                      });
                    },
                    elevation: 0,
                    disabledElevation: 0,
                    shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                    color: kPrimaryColor,
                    child: Text(
                      "addCart".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Expanded imageExpanded() {
    return Expanded(
      flex: 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
              fadeInCurve: Curves.ease,
              imageUrl: "$serverImage/${_filterController.list[widget.indexx]["image"]}-mini.webp",
              imageBuilder: (context, imageProvider) => Container(
                    padding: EdgeInsets.zero,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              placeholder: (context, url) => Center(child: spinKit()),
              errorWidget: (context, url, error) => noImage()),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  favButton = !favButton;
                  favCartController.toggleFav(_filterController.list[widget.indexx]["id"]);
                  if (favButton == true) {
                    showCustomToast(context, "addedfavorite");
                  } else {
                    showCustomToast(context, "removedfavorite");
                  }
                });
              },
              child: PhysicalModel(
                elevation: 2,
                color: Colors.transparent,
                shape: BoxShape.circle,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(favButton ? IconlyBold.heart : IconlyLight.heart, color: Colors.red)),
              ),
            ),
          ),
          if (_filterController.list[widget.indexx]["discountValue"] != 0)
            Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius5),
                  child: Text(" - ${_filterController.list[widget.indexx]["discountValue"]} %", style: const TextStyle(color: Colors.white, fontFamily: montserratRegular, fontSize: 14)),
                ))
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }
}
