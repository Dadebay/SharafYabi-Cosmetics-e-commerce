// ignore_for_file: avoid_dynamic_calls, file_names

import 'package:flutter/cupertino.dart';
import 'package:sharaf_yabi_ecommerce/components/compackages.dart';

class AddCartButton2 extends StatefulWidget {
  final int? id;
  final int quantity;
  const AddCartButton2({Key? key, this.id, required this.quantity}) : super(key: key);

  @override
  _AddCartButton2State createState() => _AddCartButton2State();
}

class _AddCartButton2State extends State<AddCartButton2> {
  bool addCart = false;
  int quantityMine = 1;
  @override
  void initState() {
    super.initState();
    quantityMine = widget.quantity;
    if (quantityMine > 1) addCart = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                        Get.find<Fav_Cart_Controller>().cartList.forEach((element) {
                          if (element["id"] == widget.id) {
                            quantityMine--;

                            element["count"]--;
                            if (quantityMine == 0) {
                              addCart = false;
                            }
                          }
                        });
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
                  Text(
                    "$quantityMine",
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print(Get.find<Fav_Cart_Controller>().cartList);
                        Get.find<Fav_Cart_Controller>().addCart(widget.id!);
                        print(Get.find<Fav_Cart_Controller>().cartList);

                        quantityMine++;
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
          // ignore: deprecated_member_use
          : RaisedButton(
              onPressed: () {
                setState(() {
                  addCart = !addCart;
                  Get.find<Fav_Cart_Controller>().addCart(widget.id!);
                });
              },
              elevation: 0,
              disabledElevation: 0,
              shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
              color: kPrimaryColor,
              child: Text(
                "addCart".tr,
                style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold),
              ),
            ),
    );
  }
}
