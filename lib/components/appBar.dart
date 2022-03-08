// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors, avoid_implementing_value_types

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

import 'constants/constants.dart';

class MyAppBar extends StatelessWidget implements PreferredSize {
  final IconData icon;
  final Function() onTap;
  final bool backArrow;
  final bool iconRemove;
  final String? name;
  final bool? addName;
  const MyAppBar({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.backArrow,
    required this.iconRemove,
    this.name,
    this.addName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      leading: backArrow
          ? IconButton(
              icon: Icon(
                IconlyLight.arrowLeft2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : SizedBox.shrink(),
      actions: [
        if (iconRemove == false)
          SizedBox.shrink()
        else
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(icon, color: Colors.grey[200], size: sizeWidth > 800 ? 36 : 26),
            ),
          )
      ],
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      title: addName ?? false
          ? Text(
              name!.tr,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: sizeWidth > 800 ? 30 : 20),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(appLogo, height: sizeWidth > 800 ? 65 : 45, width: sizeWidth > 800 ? 65 : 45, color: Colors.white),
                Text(
                  "Sharafyabi",
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, letterSpacing: 2.0, fontFamily: montserratBold, fontSize: sizeWidth > 800 ? 30 : 18),
                ),
                SizedBox(
                  width: iconRemove == false ? 70 : 35,
                )
              ],
            ),
    );
  }

  @override
  Widget get child => Text("ad");

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
