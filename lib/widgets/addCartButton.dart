// ignore_for_file: file_names, non_constant_identifier_names, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';

class AddCartButton extends StatefulWidget {
  const AddCartButton({Key? key, this.id}) : super(key: key);

  final int? id;

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
    return GestureDetector(
      onTap: () {
        setState(() {
          addCart = !addCart;
          if (addCart == true) {
            Get.find<Fav_Cart_Controller>().addCart(widget.id!);
          } else {
            Get.find<Fav_Cart_Controller>().removeCartClear(
              widget.id!,
            );
          }
        });
      },
      child: addCart
          ? Container(
              margin: const EdgeInsets.only(right: 5),
              width: 35,
              height: 35,
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
              decoration: const BoxDecoration(color: kPrimaryColor, borderRadius: borderRadius10),
              child: Lottie.asset(
                "assets/lottie/cartwhite.json",
                width: 28,
                animate: true,
                repeat: false,
              ))
          : Container(
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: kPrimaryColor, borderRadius: borderRadius10),
              child: const Icon(IconlyLight.buy, color: Colors.white)),
    );
  }
}
