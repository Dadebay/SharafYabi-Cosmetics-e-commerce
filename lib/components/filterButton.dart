// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';

class FilterButton extends StatelessWidget {
  final Function()? onTap;
  final String? name;
  final IconData? icon;
  const FilterButton({Key? key, this.onTap, this.name, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      // ignore: deprecated_member_use
      child: RaisedButton(
        onPressed: onTap,
        color: Colors.white,
        disabledColor: Colors.white,
        elevation: 0,
        splashColor: backgroundColor.withOpacity(0.2),
        disabledElevation: 0,
        highlightElevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(icon, color: Colors.black),
            ),
            Text(
              name!.tr,
              style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold),
            )
          ],
        ),
      ),
    );
  }
}
