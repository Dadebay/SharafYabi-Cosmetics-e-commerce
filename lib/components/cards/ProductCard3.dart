// ignore_for_file: deprecated_member_use, file_names, avoid_dynamic_calls, unnecessary_statements, always_declare_return_types, type_annotate_public_apis

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/buttons/FavButton.dart';
import 'package:sharaf_yabi_ecommerce/components/buttons/addOrRemoveButton.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/ProductProfilPage/ProductProfil.dart';

class ProductCard3 extends StatefulWidget {
  final int? id;
  final String? name;
  final String? price;
  final String? image;
  final int? discountValue;
  final bool? addCart;
  final int? stockCount;
  final bool? newIncome;

  const ProductCard3({Key? key, this.name, this.id, this.discountValue, this.price, this.image, this.addCart, required this.stockCount, this.newIncome}) : super(key: key);

  @override
  State<ProductCard3> createState() => _ProductCard3State();
}

class _ProductCard3State extends State<ProductCard3> {
  @override
  Widget build(BuildContext context) {
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: ProductProfil(
            id: widget.id!,
            productName: widget.name,
            image: "$serverImage/${widget.image}-big.webp",
          ),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: borderRadius5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            imageExpanded(),
            namePartMine(sizeWidth, sizeHeight),
          ],
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
      flex: widget.addCart == false ? 2 : 3,
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
              widget.addCart == false ? Expanded(child: discountedPriceWidget() as Widget) : discountedPriceWidget() as Widget
            else
              widget.addCart == false
                  ? Expanded(
                      child: Text(
                        "${widget.price} m.",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: montserratSemiBold, fontSize: sizeWidth > 800 ? 22 : 18, color: kPrimaryColor),
                      ),
                    )
                  : Text(
                      "${widget.price} m.",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: montserratSemiBold, fontSize: sizeWidth > 800 ? 22 : 18, color: kPrimaryColor),
                    ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: AddOrRemoveButton(
                id: widget.id!,
                stockCount: widget.stockCount!,
                price: widget.price!,
                sizeWidth: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  discountedPriceWidget() {
    double staticPrice = double.parse(priceMine.toStringAsFixed(2));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$staticPrice m.",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: kPrimaryColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: [
              Positioned(left: 0, right: 0, top: 12, child: Transform.rotate(angle: pi / -8, child: Container(height: 1, color: Colors.red))),
              Text("$priceOLD", overflow: TextOverflow.ellipsis, maxLines: 1, textAlign: TextAlign.center, style: const TextStyle(fontFamily: montserratRegular, fontSize: 16, color: Colors.grey)),
            ],
          ),
        )
      ],
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
          Positioned(top: 0, right: 0, child: FavButton(id: widget.id!)),
          if (widget.discountValue != 0 && widget.discountValue != null)
            Positioned(
                bottom: 8,
                left: 8,
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
