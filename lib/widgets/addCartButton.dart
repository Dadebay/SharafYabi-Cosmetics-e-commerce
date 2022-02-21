// ignore_for_file: file_names, non_constant_identifier_names, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';

class AddCartButton extends StatefulWidget {
  const AddCartButton({Key? key, this.id, required this.price}) : super(key: key);

  final int? id;
  final String price;
  @override
  State<AddCartButton> createState() => _AddCartButtonState();
}

class _AddCartButtonState extends State<AddCartButton> with TickerProviderStateMixin {
  bool addCart = false;
  bool changeLottie = false;
  Fav_Cart_Controller fav_cart_controller = Get.put(Fav_Cart_Controller());
  @override
  void initState() {
    super.initState();
    if (fav_cart_controller.cartList.isNotEmpty) {
      for (final element in fav_cart_controller.cartList) {
        if (element["id"] == widget.id) {
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
        setState(() {
          addCart = !addCart;
          if (addCart == true) {
            showCustomToast(
              context,
              "addedToCardSubtitle".tr,
            );

            Get.find<Fav_Cart_Controller>().addCart(widget.id!, widget.price);
          } else {
            Get.find<Fav_Cart_Controller>().removeCartClear(
              widget.id!,
            );
            showCustomToast(
              context,
              "removedFromCartSubtitle".tr,
            );
          }
        });
      },
      child: addCart
          ? Container(
              margin: const EdgeInsets.only(right: 5),
              width: sizeWidth > 800 ? 45 : 32,
              height: sizeWidth > 800 ? 45 : 32,
              padding: EdgeInsets.symmetric(vertical: sizeWidth > 800 ? 5 : 2, horizontal: sizeWidth > 800 ? 6 : 3),
              decoration: const BoxDecoration(color: kPrimaryColor, borderRadius: borderRadius5),
              child: Lottie.asset(
                "assets/lottie/cartwhite.json",
                width: sizeWidth > 800 ? 38 : 28,
                animate: true,
                repeat: false,
              ))
          : Container(
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: kPrimaryColor, borderRadius: borderRadius5),
              child: Icon(IconlyLight.buy, size: sizeWidth > 800 ? 34 : 22, color: Colors.white)),
    );
  }
}
