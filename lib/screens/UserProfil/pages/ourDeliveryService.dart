// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';

class OurDeliveryService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        icon: Icons.add,
        onTap: () {},
        backArrow: true,
        iconRemove: false,
        name: "ourDeliveryService",
        addName: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text("deliveryTextTitle".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18)),
              ),
              Text("deliveryText".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
