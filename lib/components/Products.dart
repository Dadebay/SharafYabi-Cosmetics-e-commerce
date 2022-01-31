// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

import 'package:sharaf_yabi_ecommerce/components/compackages.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        backArrow: false,
        iconRemove: false,
        icon: CupertinoIcons.square_stack_3d_down_right_fill,
        onTap: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: GridView.builder(
          itemCount: 13,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3 / 4, mainAxisSpacing: 15, crossAxisSpacing: 15),
          itemBuilder: (BuildContext context, int index) {
            // ignore: deprecated_member_use
            return RaisedButton(
              onPressed: () {},
              shape: const RoundedRectangleBorder(borderRadius: borderRadius15),
              color: Colors.white,
              disabledColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        "assets/images/products/${index + 1}.png",
                        fit: BoxFit.contain,
                        width: Get.size.width,
                        height: Get.size.height,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 6,
                      bottom: 6,
                    ),
                    child: Text(
                      "Kategoriýa ady",
                      style: TextStyle(fontFamily: montserratSemiBold, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 6,
                      left: 6,
                    ),
                    child: Text(
                      "Harytlar : 78",
                      style: TextStyle(fontFamily: montserratMedium, color: Colors.grey[400], fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
