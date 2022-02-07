// ignore_for_file: must_be_immutable, deprecated_member_use, file_names, avoid_dynamic_calls, avoid_bool_literals_in_conditional_expressions

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/models/CartModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/BottomNavBar.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
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
  final CartPageController cartPageController = Get.put(CartPageController());
  TextEditingController couponController = TextEditingController();
  Fav_Cart_Controller favCartController = Get.put(Fav_Cart_Controller());
  TextEditingController nameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  double price = 0;
  bool sendButton = false;
  final storage = GetStorage();
  final _form1Key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    sendButton = false;
    cartPageController.nagt.value = 1;
    favCartController.promoDiscount.value = 0;
    favCartController.promoLottie.value = false;
    // favCartController.promoLottieADDCoin.value = false;
  }

  Row productsCount() {
    return Row(
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
    );
  }

  Padding couponDiscount() {
    return Padding(
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
    );
  }

  Padding total() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
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
    );
  }

  Center orderButton() {
    return Center(
      child: SizedBox(
        width: sendButton ? 70 : Get.size.width,
        child: RaisedButton(
          shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
          color: kPrimaryColor,
          elevation: 1,
          padding: const EdgeInsets.symmetric(vertical: 10),
          onPressed: () {
            if (nameController.text.isEmpty) {
              showSnackBar("retry", "errorName", Colors.red);
            } else if (phoneController.text.isEmpty) {
              showSnackBar("retry", "errorPhone", Colors.red);
            } else if (addressController.text.isEmpty) {
              showSnackBar("retry", "errorAddress", Colors.red);
            } else {
              if (favCartController.cartList.isEmpty) {
                completeOrder();
              } else {
                final storage = GetStorage();
                final result = storage.read('data') ?? "[]";
                String id = "";
                if (result != "[]") {
                  id = jsonDecode(result)["id"];
                }
                setState(() {
                  sendButton = true;
                  OrderModel()
                      .createOrder(
                          userID: id,
                          phoneNumber: phoneController.text,
                          address: addressController.text,
                          name: nameController.text,
                          coupon: couponController.text,
                          comment: noteController.text,
                          payment: "${cartPageController.nagt.value}")
                      .then((value) {
                    if (value == true) {
                      OrderModel().getPdf(id: cartPageController.pdfID.value);

                      completeOrder();
                      sendButton = false;
                    } else {
                      sendButton = false;
                    }
                  });
                });
              }
            }
          },
          child: sendButton
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text("order".tr, style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: montserratSemiBold)),
        ),
      ),
    );
  }

  Widget paymentMethod() {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "${"paymentMethod".tr} : ",
            style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return RaisedButton(
                    onPressed: () {
                      cartPageController.buttonColor.value = false;
                      cartPageController.nagt.value = 1;
                    },
                    elevation: 0,
                    disabledElevation: 0,
                    color: cartPageController.buttonColor.value == true ? backgroundColor : kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius5, side: BorderSide(color: cartPageController.buttonColor.value == true ? backgroundColor : kPrimaryColor, width: 2)),
                    child: Text("cash".tr,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: cartPageController.buttonColor.value == true ? Colors.black : Colors.white,
                            fontFamily: cartPageController.buttonColor.value == true ? montserratMedium : montserratSemiBold)));
              }),
              const SizedBox(
                width: 10,
              ),
              Obx(() {
                return RaisedButton(
                    onPressed: () {
                      cartPageController.buttonColor.value = true;
                      cartPageController.nagt.value = 2;
                    },
                    elevation: 0,
                    disabledElevation: 0,
                    color: cartPageController.buttonColor.value == true ? kPrimaryColor : backgroundColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius5, side: BorderSide(color: cartPageController.buttonColor.value == true ? kPrimaryColor : backgroundColor, width: 2)),
                    child: Text("creditCart".tr,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: cartPageController.buttonColor.value == true ? Colors.white : Colors.black,
                            fontFamily: cartPageController.buttonColor.value == true ? montserratSemiBold : montserratMedium)));
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget mineListTile(String text, String labelText, IconData icon, String dialogTitle, TextEditingController controllermine, int textLength, bool changeIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        minVerticalPadding: 0.0,
        dense: true,
        tileColor: backgroundColor,
        shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
        title: Text(text.tr, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: kPrimaryColor, fontSize: 16, fontFamily: montserratMedium)),
        leading: Icon(icon, color: kPrimaryColor),
        trailing: Icon(changeIcon ? Icons.done : IconlyLight.arrowRightCircle, color: kPrimaryColor),
        onTap: () {
          Get.defaultDialog(
              radius: 8,
              titlePadding: EdgeInsets.only(top: 15, left: 15, right: 15),
              title: dialogTitle.tr,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              titleStyle: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: montserratMedium),
              content: customTextField(labelText, controllermine, textLength));
        },
      ),
    );
  }

  customTextField(String hintText, TextEditingController controller, int lenght) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Form(
            key: _form1Key,
            child: controller == phoneController
                ? phoneNumberTextField()
                : TextFormField(
                    controller: controller,
                    textCapitalization: TextCapitalization.sentences,
                    cursorColor: kPrimaryColor,
                    maxLines: lenght > 20 ? 3 : 1,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(lenght),
                    ],
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "errorEmpty".tr;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        label: Text(hintText.tr),
                        alignLabelWithHint: true,
                        prefixIconConstraints: const BoxConstraints.tightForFinite(),
                        labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
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
        ),
        SizedBox(
          width: Get.size.width,
          child: RaisedButton(
            color: kPrimaryColor,
            shape: RoundedRectangleBorder(borderRadius: borderRadius10),
            onPressed: () {
              if (_form1Key.currentState!.validate()) {
                if (controller == couponController) {
                  OrderModel().createPromo(coupon: couponController.text).then((value) {
                    if (value == false) {
                      showSnackBar("retry", "couponCodeError", Colors.red);
                    } else {
                      favCartController.promoLottie.value = true;
                      favCartController.promoDiscount.value = value;
                    }
                  });
                }
                Future.delayed(Duration(seconds: 5), () {
                  favCartController.promoLottie.value = false;
                });
                setState(() {});
                Get.back();
              } else {
                Vibration.vibrate();
              }
            },
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Text("agree".tr, style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: montserratSemiBold)),
          ),
        ),
      ],
    );
  }

  phoneNumberTextField() {
    return TextFormField(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mineListTile(nameController.text.isEmpty ? "enterUserName" : "${"orderName".tr} : ${nameController.text}", "enterUserName", IconlyLight.profile, "pleaseEnterYourName",
                        nameController, 20, nameController.text.isEmpty ? false : true),
                    mineListTile(phoneController.text.isEmpty ? "userPhoneNumber" : "${"orderPhone".tr} : ${phoneController.text}", "userPhoneNumber", IconlyLight.call, "pleaseEnterYourPhone",
                        phoneController, 8, phoneController.text.isEmpty ? false : true),
                    mineListTile(addressController.text.isEmpty ? "address" : "${"orderAddress".tr} : ${addressController.text}", "address", IconlyLight.location, "pleaseEnterYourAddress",
                        addressController, 50, addressController.text.isEmpty ? false : true),
                    mineListTile(noteController.text.isEmpty ? "note" : "${"orderNote".tr} : ${noteController.text}", "note", IconlyLight.editSquare, "pleaseEnterYourNote", noteController, 50,
                        noteController.text.isEmpty ? false : true),
                    mineListTile(couponController.text.isEmpty ? "couponCodeTitle" : "${"orderСoupon".tr} :  ${couponController.text}", "couponCodeTitle", IconlyLight.discount,
                        "pleaseEnterYourCouponeCode", couponController, 20, couponController.text.isEmpty ? false : true),
                    const SizedBox(
                      height: 80,
                    ),
                    paymentMethod(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "orderInfo".tr,
                        style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 20),
                      ),
                    ),
                    productsCount(),
                    couponDiscount(),
                    total(),
                    orderButton(),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            Obx(() {
              return Center(
                  child: favCartController.promoLottie.value == true
                      ? Lottie.asset(
                          "assets/lottie/coupon_falling_confetti.json",
                          animate: true,
                        )
                      : SizedBox.shrink());
            }),
          ],
        ));
  }
}

Future<dynamic> completeOrder() {
  return Get.defaultDialog(
      radius: 25,
      backgroundColor: Colors.white,
      title: "",
      barrierDismissible: false,
      actions: [
        SizedBox(
          width: Get.size.width / 1.5,
          child: RaisedButton(
            onPressed: () {
              Get.to(() => BottomNavBar());
            },
            shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
            color: kPrimaryColor,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text("agree".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: montserratSemiBold,
                )),
          ),
        )
      ],
      content: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 25),
            width: Get.size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("orderComplete".tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: montserratSemiBold)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text("orderCompleteSubtitle".tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontFamily: montserratRegular)),
                ),
              ],
            ),
          ),
          Positioned(
            top: -120,
            child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(15),
                child: Lottie.asset("assets/lottie/cartblack.json", fit: BoxFit.cover, width: 110, height: 110)),
          )
        ],
      ));
}

AppBar appbar() {
  return AppBar(
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          IconlyLight.arrowLeft2,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      title: Text(
        "order".tr,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 18),
      ));
}
