// ignore_for_file: file_names, deprecated_member_use, avoid_print, avoid_void_async

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/cards/ProductCard3.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/models/OrdersModel.dart';

class Orders extends StatefulWidget {
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final SettingsController settings = Get.put(SettingsController());
  @override
  void initState() {
    super.initState();
    settings.returnOrderList();
  }

  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: MyAppBar(
        icon: Icons.add,
        onTap: () {},
        backArrow: true,
        iconRemove: false,
        addName: true,
        name: "orders",
      ),
      body: FutureBuilder<List<OrdersModel>>(
          future: storage.read("AccessToken") == null ? OrdersModel().getOrdersNotLogin(parametrs: {"ord": jsonEncode(settings.orderList)}) : OrdersModel().getOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: spinKit());
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return emptyData(imagePath: emptyProducts, errorTitle: "orderEmpty", errorSubtitle: "orderEmptySubtitle");
            } else if (snapshot.hasError) {
              return errorConnection(onTap: () {
                OrdersModel().getOrders();
              });
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              reverse: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                  child: RaisedButton(
                    shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                    color: Colors.white,
                    disabledColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    onPressed: () {
                      pushNewScreen(
                        context,
                        screen: OrderProfile(
                          id: snapshot.data![index].id,
                        ),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("${"orderHistory".tr} ${index + 1}",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontFamily: montserratSemiBold,
                                color: Colors.black,
                              )),
                        ),
                        Expanded(
                          child: Text("${snapshot.data![index].createdAT}".substring(0, 10), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontFamily: montserratRegular)),
                        ),
                        Expanded(
                          child: Text(
                            "${snapshot.data![index].totalPrice} " + "m.",
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontFamily: montserratMedium, color: Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(
                              IconlyLight.arrowRightCircle,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

class OrderProfile extends StatelessWidget {
  final int? id;
  final storage = GetStorage();

  OrderProfile({Key? key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(icon: Icons.add, onTap: () {}, backArrow: true, iconRemove: false),
        body: FutureBuilder<List<OrdersModelById>>(
            future: storage.read("AccessToken") == null ? OrdersModelById().getOrderByIdNotLogin(id: id) : OrdersModelById().getOrderById(id: id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data?.length,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2 / 3),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCard3(
                      id: snapshot.data![index].id,
                      name: snapshot.data![index].productName,
                      price: snapshot.data![index].price,
                      image: snapshot.data![index].imagePath,
                      discountValue: snapshot.data![index].discountValue,
                      addCart: false,
                      inOrder: true,
                      stockCount: 0,
                    );
                  },
                );
              } else {
                return Center(child: spinKit());
              }
            }));
  }
}
