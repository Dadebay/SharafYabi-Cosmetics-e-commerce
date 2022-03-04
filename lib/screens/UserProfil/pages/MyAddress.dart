// ignore_for_file: file_names, duplicate_ignore, deprecated_member_use, use_named_constants

// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/cards/MyAddressCard.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/dialogs/diologs.dart';
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
                          customDialog(
                              title: "addAddress",
                              hintText: "orderAddress",
                              controller: comment,
                              secondTextFieldController: address,
                              maxLine: 3,
                              secondTextField: true,
                              maxLength: 100,
                              onTap: () {
                                if (address.text.length > 4) {
                                  Get.find<SettingsController>().dialogsBool.value = !Get.find<SettingsController>().dialogsBool.value;

                                  AddressModel().addLocation(address.text, comment.text).then((value) {
                                    if (value == true) {
                                      showCustomToast(context, "AddressAdded");
                                    } else {
                                      showSnackBar("retry", "errorAddress", Colors.red);
                                    }
                                    Get.find<SettingsController>().dialogsBool.value = !Get.find<SettingsController>().dialogsBool.value;
                                    if (Get.find<SettingsController>().dialogsBool.value == false) {
                                      Get.back();
                                      address.clear();
                                      comment.clear();
                                      setState(() {});
                                    }
                                  });
                                } else {
                                  Vibration.vibrate();
                                  showSnackBar("retry", "addressError", Colors.red);
                                }
                              });
                        },
                        color: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("addAddress".tr, style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 18)),
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(CupertinoIcons.add_circled, color: Colors.white, size: 30),
                            ),
                          ],
                        ),
                      ),
              );
            }),
          )
        ],
      ),
    );
  }
}
