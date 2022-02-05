// ignore_for_file: must_be_immutable, deprecated_member_use, file_names, avoid_dynamic_calls

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/models/CartModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/Cart/Components/CartWidget.dart';
import 'package:vibration/vibration.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key, this.totalPrice, this.productCount}) : super(key: key);

  final int? productCount;
  final double? totalPrice;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController addressController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  String name = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final storage = GetStorage();

  final _form1Key = GlobalKey<FormState>();
  double price = 0;
  bool sendButton = false;
  @override
  void initState() {
    super.initState();
    sendButton = false;
    favCartController.promoDiscount.value = 0;
    favCartController.promoLottie.value = false;
    favCartController.promoLottieADDCoin.value = false;
    if (storage.read('data') != null) {
      final result = storage.read('data');
      name = jsonDecode(result)["full_name"] ?? "name".tr;
      nameController.text = name.capitalizeFirst!;
      phoneController.text = jsonDecode(result)["phone"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar(),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textFieldOthers(),
                const SizedBox(
                  height: 20,
                ),
                promoCode(),
                const SizedBox(
                  height: 20,
                ),
                paymentMethod(),
                const SizedBox(
                  height: 20,
                ),
                dividerr(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "productsCount".tr,
                      style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: montserratMedium),
                    ),
                    Text(
                      "${widget.productCount}",
                      style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "couponCodeDiscount".tr,
                        style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: montserratMedium),
                      ),
                      Obx(() {
                        return Text(
                          "${favCartController.promoDiscount.value}%",
                          style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
                        );
                      })
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "total".tr,
                        style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: montserratMedium),
                      ),
                      Obx(() {
                        price = widget.totalPrice!;

                        price = ((100 - favCartController.promoDiscount.value) / 100) * price;
                        return RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(text: price.toStringAsFixed(2), style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 20, color: Colors.black)),
                            const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratSemiBold, fontSize: 16, color: Colors.black))
                          ]),
                        );
                      }),
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: sendButton ? 70 : Get.size.width,
                    child: RaisedButton(
                      shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
                      color: kPrimaryColor,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      onPressed: () {
                        setState(() {
                          if (favCartController.cartList.isEmpty) {
                            completeOrder();
                          } else {
                            final storage = GetStorage();
                            final result = storage.read('data') ?? "[]";

                            if (_form1Key.currentState!.validate()) {
                              sendButton = true;

                              OrderModel()
                                  .createOrder(
                                      userID: result == "[]" ? "" : jsonDecode(result)["id"],
                                      phoneNumber: phoneController.text,
                                      address: addressController.text,
                                      name: nameController.text,
                                      coupon: couponController.text,
                                      comment: noteController.text,
                                      payment: "$nagt")
                                  .then((value) {
                                if (value == true) {
                                  completeOrder();
                                } else {
                                  sendButton = false;
                                }
                              });
                            } else {
                              Vibration.vibrate();
                              sendButton = false;
                            }
                          }
                        });
                      },
                      child: sendButton
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text("order".tr, style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: montserratSemiBold)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }

  int nagt = 1;
  bool buttonColor = false;
  Padding paymentMethod() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "paymentMethod".tr,
              style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      buttonColor = false;
                      nagt = 1;
                    });
                  },
                  elevation: 0,
                  disabledElevation: 0,
                  color: buttonColor == true ? Colors.white : kPrimaryColor,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius5, side: BorderSide(color: buttonColor == true ? Colors.grey : kPrimaryColor, width: 2)),
                  child: Text("cash".tr, overflow: TextOverflow.ellipsis, style: TextStyle(color: buttonColor == true ? Colors.black : Colors.white, fontFamily: montserratMedium))),
              const SizedBox(
                width: 10,
              ),
              RaisedButton(
                  onPressed: () {
                    setState(() {
                      buttonColor = true;
                      nagt = 2;
                    });
                  },
                  elevation: 0,
                  disabledElevation: 0,
                  color: buttonColor == true ? kPrimaryColor : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius5, side: BorderSide(color: buttonColor == true ? kPrimaryColor : Colors.grey, width: 2)),
                  child: Text("creditCart".tr, overflow: TextOverflow.ellipsis, style: TextStyle(color: buttonColor == true ? Colors.white : Colors.black, fontFamily: montserratMedium))),
            ],
          ),
        ],
      ),
    );
  }

  Form textFieldOthers() {
    return Form(
      key: _form1Key,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            textCapitalization: TextCapitalization.sentences,
            cursorColor: kPrimaryColor,
            style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
            validator: (value) {
              if (value!.isEmpty) {
                return "errorEmpty".tr;
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                // hintText: "name".tr,
                label: Text("name".tr),
                alignLabelWithHint: true,
                prefixIconConstraints: const BoxConstraints.tightForFinite(),
                labelStyle: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
                constraints: const BoxConstraints(),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius10,
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    )),
                focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              cursorColor: kPrimaryColor,
              style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
              validator: (value) {
                if (value!.isEmpty) {
                  return "errorEmpty".tr;
                } else {
                  return null;
                }
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(8),
              ],
              decoration: InputDecoration(
                  hintText: "__ ______",
                  prefixIcon: const Text(
                    '  + 993  ',
                    style: TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratSemiBold),
                  ),
                  prefixIconConstraints: const BoxConstraints.tightForFinite(),
                  isDense: true,
                  constraints: const BoxConstraints(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                  border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius10,
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      )),
                  focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "errorEmpty".tr;
                } else {
                  return null;
                }
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(50),
              ],
              controller: addressController,
              cursorColor: kPrimaryColor,
              style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
              maxLines: 3,
              decoration: InputDecoration(
                  label: Text("address".tr),
                  alignLabelWithHint: true,
                  labelStyle: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold),
                  constraints: const BoxConstraints(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                  border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius10,
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      )),
                  focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2))),
            ),
          ),
          TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(50),
            ],
            controller: noteController,
            cursorColor: kPrimaryColor,
            style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
            maxLines: 3,
            decoration: InputDecoration(
                alignLabelWithHint: true,
                label: Text("note".tr),
                labelStyle: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold),
                constraints: const BoxConstraints(),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius10,
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    )),
                focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2))),
          ),
        ],
      ),
    );
  }

  Fav_Cart_Controller favCartController = Get.put(Fav_Cart_Controller());
  Widget promoCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "couponCode".tr,
            style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
          ),
        ),
        Obx(() {
          return TextFormField(
            controller: couponController,
            cursorColor: kPrimaryColor,
            style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
            validator: (value) {
              if (value!.isEmpty) {
                return "errorEmpty".tr;
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                hintText: "couponCodeTitle".tr,
                suffixIcon: GestureDetector(
                  onTap: () {
                    OrderModel().createPromo(coupon: couponController.text).then((value) {
                      if (value == false) {
                        showSnackBar("erro404", "couponCodeError", Colors.red);
                      } else {
                        favCartController.promoLottie.value = true;
                        favCartController.promoDiscount.value = value;
                        Future.delayed(const Duration(seconds: 2), () {
                          favCartController.promoLottieADDCoin.value = true;
                        });
                      }
                    });
                  },
                  child: favCartController.promoLottie.value
                      ? favCartController.promoLottieADDCoin.value
                          ? const Icon(Icons.done, color: Colors.green)
                          : const CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(
                            "couponApple".tr,
                            style: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratSemiBold),
                          ),
                        ),
                ),
                suffixIconConstraints: const BoxConstraints(),
                constraints: const BoxConstraints(),
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius10,
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    )),
                focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2))),
          );
        }),
      ],
    );
  }
}
