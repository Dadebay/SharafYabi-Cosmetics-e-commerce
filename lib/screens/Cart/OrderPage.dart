// ignore_for_file: must_be_immutable, deprecated_member_use, file_names, avoid_dynamic_calls

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:sharaf_yabi_ecommerce/components/compackages.dart';
import 'package:sharaf_yabi_ecommerce/models/CartModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/BottomNavBar.dart';
import 'package:sharaf_yabi_ecommerce/widgets/agreeButton.dart';
import 'package:vibration/vibration.dart';

import 'Components/CartWidget.dart';

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

  @override
  void initState() {
    super.initState();
    if (storage.read('data') != null) {
      favCartController.promoLottie.value = false;
      favCartController.promoLottieADDCoin.value = false;
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
                promoCode(),
                dividerr(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "couponCodeDiscount".tr,
                      style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: montserratMedium),
                    ),
                    Obx(() {
                      return Text(
                        "${favCartController.promoDiscount.value}",
                        style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
                      );
                    })
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "total".tr,
                        style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: montserratMedium),
                      ),
                      Obx(() {
                        double price = widget.totalPrice!;

                        price = ((100 - favCartController.promoDiscount.value) / 100) * price;
                        return RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(text: "${price}", style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 20, color: Colors.black)),
                            const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratSemiBold, fontSize: 16, color: Colors.black))
                          ]),
                        );
                      }),
                    ],
                  ),
                ),
                Center(
                  child: AgreeButton(
                    name: "order".tr,
                    onTap: () {
                      if (favCartController.cartList.isEmpty) {
                        completeOrder();
                      } else {
                        final storage = GetStorage();
                        final result = storage.read('data') ?? "[]";
                        if (_form1Key.currentState!.validate()) {
                          Get.find<AuthController>().changeSignInAnimation();
                          OrderModel()
                              .createOrder(
                                  userID: jsonDecode(result)["id"],
                                  phoneNumber: phoneController.text,
                                  address: addressController.text,
                                  name: nameController.text,
                                  coupon: couponController.text,
                                  comment: noteController.text)
                              .then((value) {
                            if (value == true) {
                              completeOrder();
                            }
                          });
                        } else {
                          Vibration.vibrate();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
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
                border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: const BorderSide(color: kPrimaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius10,
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    )),
                focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: const BorderSide(color: kPrimaryColor, width: 2))),
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
                  border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: const BorderSide(color: kPrimaryColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius10,
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      )),
                  focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: const BorderSide(color: kPrimaryColor, width: 2))),
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
                  border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: const BorderSide(color: kPrimaryColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius10,
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      )),
                  focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: const BorderSide(color: kPrimaryColor, width: 2))),
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
                border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: const BorderSide(color: kPrimaryColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius10,
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    )),
                focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: const BorderSide(color: kPrimaryColor, width: 2))),
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
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "couponCode".tr,
            style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
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
                        showSnackBar("Error ", "Error Promo Code", Colors.red);
                      } else {
                        print("men");
                        favCartController.promoLottie.value = true;
                        favCartController.promoDiscount.value = value;
                        Future.delayed(Duration(seconds: 2), () {
                          favCartController.promoLottieADDCoin.value = true;
                        });
                      }
                    });
                  },
                  child: favCartController.promoLottie.value
                      ? favCartController.promoLottieADDCoin.value
                          ? Icon(Icons.done, color: Colors.green)
                          : CircularProgressIndicator()
                      : Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Text(
                            "couponApple".tr,
                            style: TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratSemiBold),
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
                focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: const BorderSide(color: kPrimaryColor, width: 2))),
          );
        }),
      ],
    );
  }
}
