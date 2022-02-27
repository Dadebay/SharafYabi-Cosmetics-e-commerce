// ignore_for_file: file_names, duplicate_ignore, deprecated_member_use, use_named_constants

// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/cards/MyAddressCard.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/models/AddresModel.dart';
import 'package:vibration/vibration.dart';

class MyAddress extends StatefulWidget {
  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  TextEditingController address = TextEditingController();
  TextEditingController comment = TextEditingController();
  final SettingsController settingsController = Get.put(SettingsController());

  bool buttonLoading = false;
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
                        return MyAddressCard(
                          address: snapshot.data![index].address!,
                          comment: snapshot.data![index].comment!,
                          onDelete: () {
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
                                  Container(
                                    width: Get.size.width,
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
                                  StatefulBuilder(builder: (BuildContext context, StateSetter setStates) {
                                    return SizedBox(
                                      width: buttonLoading ? 70 : Get.size.width - 50,
                                      child: RaisedButton(
                                        onPressed: () {
                                          setStates(() {
                                            buttonLoading = true;
                                          });
                                          if (address.text.length > 4) {
                                            AddressModel().addLocation(address.text, comment.text).then((value) {
                                              if (value == true) {
                                                showCustomToast(context, "AddressAdded");
                                                Get.back();
                                                address.clear();
                                                comment.clear();
                                              } else {
                                                showSnackBar("retry", "errorAddress", Colors.red);
                                              }
                                              setState(() {
                                                buttonLoading = false;
                                              });
                                            });
                                          } else {
                                            Vibration.vibrate();
                                            showSnackBar("retry", "addressError", Colors.red);
                                          }
                                        },
                                        color: kPrimaryColor,
                                        padding: EdgeInsets.symmetric(vertical: buttonLoading ? 8 : 12, horizontal: 12),
                                        shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                                        child: buttonLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : Text("${"addAddress".tr}   + ", style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 18)),
                                      ),
                                    );
                                  })
                                ],
                              ));
                        },
                        color: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
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
