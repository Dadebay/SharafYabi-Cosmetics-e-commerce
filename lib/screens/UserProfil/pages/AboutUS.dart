// ignore_for_file: file_names, type_annotate_public_apis

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

class AboutUS extends StatelessWidget {
  Widget text(String name, name1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name.tr,
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold),
          ),
        ),
        const SizedBox(
          width: 20, //size.width / 16,
        ),
        Expanded(
          child: Text(
            name1,
            maxLines: 2,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: kPrimaryColor, fontFamily: montserratMedium),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: MyAppBar(icon: Icons.add, onTap: () {}, backArrow: true, iconRemove: false),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              text("phoneNumber", "+993 63-14-31-11"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: text("phoneNumber", "+993 12 57 57 81 (82)"),
              ),
              text("email", "order@sharafyabi.com"),
              const SizedBox(
                height: 60,
              ),
              Text(
                "aboutUsTitle".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(color: kPrimaryColor, fontFamily: montserratMedium, fontSize: 18),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Text(
                  "aboutUsSubtitle".tr,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: kPrimaryColor, fontFamily: montserratMedium, fontSize: 18),
                ),
              ),
            ],
          ),
        ));
  }
}
