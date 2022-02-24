// ignore_for_file: deprecated_member_use, file_names, avoid_dynamic_calls, unnecessary_statements, always_declare_return_types, type_annotate_public_apis

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/ProductProfilPage/ProductProfil.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';

class ProductCard3 extends StatefulWidget {
  final int? id;
  final String? name;
  final String? price;
  final String? image;
  final int? discountValue;

  const ProductCard3({Key? key, this.name, this.id, this.discountValue, this.price, this.image}) : super(key: key);

  @override
  State<ProductCard3> createState() => _ProductCard3State();
}

class _ProductCard3State extends State<ProductCard3> {
  bool addCart = false;
  bool favButton = false;
  int quantity = 0;
  final HomePageController _homePageController = Get.put(HomePageController());
  final Fav_Cart_Controller favCartController = Get.put(Fav_Cart_Controller());
  final FilterController filterController = Get.put(FilterController());
  @override
  void initState() {
    super.initState();
    changeCartCount();
  }

  changeCartCount() {
    bool value = false;
    for (final element in favCartController.favList) {
      if (element["id"] == widget.id!) {
        favButton = true;
      }
    }
    for (final element in favCartController.cartList) {
      if (element["id"] == widget.id!) {
        addCart = true;
        value = true;
        quantity = element["count"];
      }
    }
    if (value == false) addCart = false;
  }

  @override
  Widget build(BuildContext context) {
    favCartController.cartList.isNotEmpty ? changeCartCount() : null;
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        final int? a = widget.id;
        pushNewScreen(
          context,
          screen: ProductProfil(
            id: a,
            productName: widget.name,
            image: "$serverImage/${widget.image}-mini.webp",
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
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              imageExpanded(),
              namePartMine(sizeWidth, sizeHeight),
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
  Expanded namePartMine(double sizeWidth, double sizeHeight) {
    priceMine = double.parse(widget.price!);
    if (widget.discountValue != null || widget.discountValue != 0) {
      priceOLD = priceMine;
      discountValue = widget.discountValue ?? 0;
      discountedPrice = (priceMine * discountValue) / 100;
      priceMine -= discountedPrice;
    }
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                "${widget.name}",
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: montserratRegular, fontSize: sizeWidth > 800 ? 15 : sizeWidth / 34),
              ),
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
                "${widget.price} m.",
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: montserratSemiBold, fontSize: sizeWidth > 800 ? 22 : 18, color: kPrimaryColor),
              ),
            SizedBox(width: MediaQuery.of(context).size.width, child: addCart ? addRemoveButton() : addButton()),
          ],
        ),
      ),
    );
  }

  RaisedButton addButton() {
    return RaisedButton(
      onPressed: () {
        setState(() {
          addCart = !addCart;
          showCustomToast(
            context,
            "addedToCardSubtitle".tr,
          );
          quantity++;
          _homePageController.searchAndAdd(widget.id!, "${widget.price}");
          favCartController.addCart(widget.id!, "${widget.price}");
        });
      },
      elevation: 0,
      disabledElevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
      color: kPrimaryColor,
      child: Text(
        "addCart".tr,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold),
      ),
    );
  }

  Padding addRemoveButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showCustomToast(
                context,
                "productCountAdded".tr,
              );

              _homePageController.searchAndRemove(
                widget.id!,
              );
              favCartController.removeCart(
                widget.id!,
              );
              quantity--;
              if (quantity <= 0) {
                addCart = false;
              }
              setState(() {});
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
          Text(
            "$quantity",
            style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
          ),
          GestureDetector(
            onTap: () {
              showCustomToast(
                context,
                "productCountAdded".tr,
              );
              quantity++;

              _homePageController.searchAndAdd(widget.id!, "${widget.price}");
              favCartController.addCart(widget.id!, "${widget.price}");
              setState(() {});
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
    );
  }

  Expanded imageExpanded() {
    return Expanded(
      flex: 4,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CachedNetworkImage(
                fadeInCurve: Curves.ease,
                imageUrl: "$serverImage/${widget.image}-mini.webp",
                imageBuilder: (context, imageProvider) => Container(
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
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  favButton = !favButton;
                  final int? id = widget.id;
                  favCartController.toggleFav(id ?? 0);
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
          if (widget.discountValue != 0 && widget.discountValue != null)
            Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius5),
                  child: Text("- ${widget.discountValue} %", style: const TextStyle(color: Colors.white, fontFamily: montserratRegular, fontSize: 12)),
                ))
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }
}
