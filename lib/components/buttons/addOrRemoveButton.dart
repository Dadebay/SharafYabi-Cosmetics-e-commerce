import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';
import 'package:vibration/vibration.dart';

class AddOrRemoveButton extends StatefulWidget {
  const AddOrRemoveButton({
    Key? key,
    required this.id,
    required this.stockCount,
    required this.price,
    required this.sizeWidth,
  }) : super(key: key);

  final int id;
  final String price;
  final bool sizeWidth;
  final int stockCount;

  @override
  State<AddOrRemoveButton> createState() => _AddOrRemoveButtonState();
}

class _AddOrRemoveButtonState extends State<AddOrRemoveButton> {
  bool addCartBool = false;
  int quantity = 0;

  changeCartCount() {
    bool value = false;
    for (final element in Get.find<Fav_Cart_Controller>().cartList) {
      if (element["id"] == widget.id) {
        addCartBool = true;
        value = true;
        quantity = element["count"];
      }
    }
    if (value == false) addCartBool = false;
  }

  @override
  Widget build(BuildContext context) {
    changeCartCount();
    return addCartBool
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Get.find<Fav_Cart_Controller>().removeCart(widget.id);
                  Get.find<HomePageController>().searchAndRemove(widget.id);
                  Get.find<CartPageController>().removeCard(widget.id);
                  if (quantity > 1) {
                    if (Get.find<FilterController>().list.isNotEmpty) {
                      for (final element2 in Get.find<FilterController>().list) {
                        if (element2["id"] == widget.id) {
                          element2["count"]--;
                        }
                      }
                    }
                    quantity--;
                    showCustomToast(
                      context,
                      "productCountAdded".tr,
                    );
                  } else {
                    addCartBool = false;
                    showCustomToast(
                      context,
                      "removedFromCartTitle".tr,
                    );
                  }
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(color: kPrimaryColor, borderRadius: borderRadius5),
                  child: Icon(CupertinoIcons.minus, color: Colors.white, size: 20),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "$quantity",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 20),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (widget.stockCount > (quantity + 1)) {
                    Get.find<Fav_Cart_Controller>().addCart(widget.id, widget.price);
                    if (Get.find<CartPageController>().list.isNotEmpty) {
                      Get.find<CartPageController>().addToCard(widget.id);
                    }
                    Get.find<HomePageController>().searchAndAdd(widget.id, widget.price);
                    quantity++;

                    if (Get.find<FilterController>().list.isNotEmpty) {
                      for (final element2 in Get.find<FilterController>().list) {
                        if (element2["id"] == widget.id) {
                          element2["count"]++;
                        }
                      }
                    }
                    showCustomToast(
                      context,
                      "productCountAdded".tr,
                    );
                  } else {
                    Vibration.vibrate();
                    showCustomToast(
                      context,
                      "emptyStockCount".tr,
                    );
                  }
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(color: kPrimaryColor, borderRadius: borderRadius5),
                  child: Icon(CupertinoIcons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          )
        : GestureDetector(
            onTap: () {
              print(widget.stockCount);
              if (widget.stockCount > 1) {
                addCartBool = !addCartBool;
                Get.find<Fav_Cart_Controller>().addCart(widget.id, widget.price);
                if (Get.find<CartPageController>().list.isNotEmpty) {
                  Get.find<CartPageController>().addToCard(widget.id);
                }
                Get.find<HomePageController>().searchAndAdd(widget.id, widget.price);
                showCustomToast(
                  context,
                  "addedToCardSubtitle".tr,
                );
              } else {
                Vibration.vibrate();
                showCustomToast(
                  context,
                  "emptyStockCount".tr,
                );
              }
              setState(() {});
            },
            child: Container(
                width: widget.sizeWidth ? Get.size.width : null,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: borderRadius5,
                ),
                child: Text("addCart".tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontFamily: montserratMedium, fontSize: 18))),
          );
  }
}
