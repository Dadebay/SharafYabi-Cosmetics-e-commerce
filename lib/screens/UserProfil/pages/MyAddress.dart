// ignore_for_file: file_names, duplicate_ignore, deprecated_member_use, use_named_constants

// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/models/AddresModel.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';
import 'package:vibration/vibration.dart';

class MyAddress extends StatefulWidget {
  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  TextEditingController address = TextEditingController();

  TextEditingController comment = TextEditingController();
  final SettingsController settingsController = Get.put(SettingsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        icon: Icons.add,
        onTap: () {},
        backArrow: true,
        iconRemove: false,
        name: "myAddress",
        addName: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<AddressModel>>(
                  future: AddressModel().getAddress(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: spinKit());
                    } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Center(child: emptyData(imagePath: emptyProducts, errorTitle: "myAddress", errorSubtitle: "noAddresses"));
                    } else if (snapshot.hasError) {
                      return errorConnection(onTap: () {
                        AddressModel().getAddress();
                      });
                    }
                    Future.delayed(const Duration(), () {
                      settingsController.addressCount.value = snapshot.data!.length;
                    });
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            Card(
                              elevation: 1,
                              margin: const EdgeInsets.all(8),
                              shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${"orderAddress".tr} : ", style: const TextStyle(color: Colors.black38, fontFamily: montserratRegular, fontSize: 16)),
                                        Expanded(child: Text(snapshot.data![index].address!, maxLines: 4, style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18))),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${"orderNote".tr} : ", style: const TextStyle(color: Colors.black38, fontFamily: montserratRegular, fontSize: 16)),
                                        Expanded(child: Text(snapshot.data![index].comment!, maxLines: 4, style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    final int id = int.parse(snapshot.data![index].id!);
                                    AddressModel().deleteLocation(id).then((value) {
                                      if (value == 200) {
                                        showCustomToast(context, "addressDeleted");
                                        setState(() {});
                                      } else {
                                        showSnackBar("retry", "error404", Colors.red);
                                        Vibration.vibrate();
                                      }
                                    });
                                  },
                                  child: const Icon(CupertinoIcons.xmark_circle, size: 30, color: Colors.black),
                                )),
                          ],
                        );
                      },
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Obx(() {
              return Center(
                child: settingsController.addressCount.value >= 3
                    ? const SizedBox.shrink()
                    : RaisedButton(
                        onPressed: () {
                          Get.defaultDialog(
                              radius: 6,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                              title: "addAddress".tr,
                              titleStyle: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
                              content: Column(
                                children: [
                                  TextField(
                                    controller: address,
                                    maxLines: 3,
                                    cursorColor: kPrimaryColor,
                                    style: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
                                    decoration: InputDecoration(
                                      labelText: "orderAddress".tr,
                                      labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
                                      focusedBorder: const OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                                      enabledBorder: const OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: Colors.grey)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: TextField(
                                      controller: comment,
                                      maxLines: 3,
                                      cursorColor: kPrimaryColor,
                                      style: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
                                      decoration: InputDecoration(
                                        labelText: "orderNoteOrder".tr,
                                        labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
                                        focusedBorder: const OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                                        enabledBorder: const OutlineInputBorder(borderRadius: borderRadius5, borderSide: BorderSide(color: Colors.grey)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.size.width,
                                    child: RaisedButton(
                                      onPressed: () {
                                        AddressModel().addLocation(address.text, comment.text).then((value) {
                                          if (value == true) {
                                            showCustomToast(context, "AddressAdded");

                                            Get.back();

                                            address.clear();
                                            comment.clear();
                                            setState(() {});
                                          } else {
                                            showSnackBar("retry", "errorAddress", Colors.red);
                                          }
                                        });
                                      },
                                      color: kPrimaryColor,
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                      shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                                      child: Text("${"addAddress".tr}   + ", style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 18)),
                                    ),
                                  )
                                ],
                              ));
                        },
                        color: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                        child: Text("${"addAddress".tr}   + ", style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 18)),
                      ),
              );
            }),
          )
        ],
      ),
    );
  }
}
