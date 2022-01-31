// ignore_for_file: must_be_immutable, deprecated_member_use, file_names, avoid_dynamic_calls

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:sharaf_yabi_ecommerce/components/compackages.dart';
import 'package:sharaf_yabi_ecommerce/models/CartModel.dart';
import 'package:sharaf_yabi_ecommerce/widgets/agreeButton.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';
import 'package:vibration/vibration.dart';

class OrderPage extends StatefulWidget {
  final double? totalPrice;
  final int? productCount;

  const OrderPage({Key? key, this.totalPrice, this.productCount}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController couponController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  final _form1Key = GlobalKey<FormState>();
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    if (storage.read('data') != null) {
      final result = storage.read('data');
      nameController.text = jsonDecode(result)["full_name"] ?? "name".tr;
      phoneController.text = jsonDecode(result)["phone"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(icon: Icons.add, onTap: () {}, backArrow: true, iconRemove: false),
        body: SingleChildScrollView(
          child: Container(
            height: Get.size.height - 150,
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Form(
                  key: _form1Key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
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
                            hintText: "name".tr,
                            constraints: const BoxConstraints(),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                            border: OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.3))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: borderRadius10,
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                )),
                            focusedBorder: OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.3), width: 2))),
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
                              border: OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.3))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: borderRadius10,
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  )),
                              focusedBorder: OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.3), width: 2))),
                        ),
                      ),
                      TextFormField(
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
                            hintText: "coupon".tr,
                            constraints: const BoxConstraints(),
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                            border: OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.3))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: borderRadius10,
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                )),
                            focusedBorder: OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.3), width: 2))),
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
                          controller: addressController,
                          cursorColor: kPrimaryColor,
                          style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
                          maxLines: 5,
                          decoration: InputDecoration(
                              hintText: "address".tr,
                              constraints: const BoxConstraints(),
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                              border: OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.3))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: borderRadius10,
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  )),
                              focusedBorder: OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.3), width: 2))),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: dividerr(),
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
                        padding: const EdgeInsets.only(top: 15, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "total".tr,
                              style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: montserratMedium),
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(text: "${widget.totalPrice}", style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 20, color: Colors.black)),
                                const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratSemiBold, fontSize: 16, color: Colors.black))
                              ]),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: AgreeButton(
                          name: "order".tr,
                          onTap: () {
                            final storage = GetStorage();
                            final result = storage.read('data') ?? "[]";
                            if (_form1Key.currentState!.validate()) {
                              Get.find<AuthController>().changeSignInAnimation();
                              OrderModel().createOrder(
                                  userID: jsonDecode(result)["id"], phoneNumber: phoneController.text, address: addressController.text, name: nameController.text, coupon: couponController.text);
                            } else {
                              Vibration.vibrate();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
