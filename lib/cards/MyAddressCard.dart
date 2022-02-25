import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';

class MyAddressCard extends StatelessWidget {
  final String address;
  final String comment;
  final Function() onDelete;

  const MyAddressCard({Key? key, required this.address, required this.comment, required this.onDelete}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 1,
          margin: const EdgeInsets.all(8),
          shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${"orderAddress".tr} : ", style: const TextStyle(color: Colors.black38, fontFamily: montserratRegular, fontSize: 16)),
                          Expanded(child: Text(address, maxLines: 4, style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18))),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${"orderNote".tr} : ", style: const TextStyle(color: Colors.black38, fontFamily: montserratRegular, fontSize: 16)),
                          Expanded(child: Text(comment, maxLines: 4, style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(onPressed: onDelete, icon: Icon(IconlyBold.delete, size: 30, color: kPrimaryColor))
            ],
          ),
        ),
      ],
    );
  }
}
