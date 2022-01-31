// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:sharaf_yabi_ecommerce/components/compackages.dart';

class BottomSheetName extends StatelessWidget {
  final String? name;

  const BottomSheetName({Key? key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Text(
            name!.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(CupertinoIcons.xmark_circle, color: Colors.black)),
        ],
      ),
    );
  }
}
