// ignore_for_file: file_names, must_be_immutable, avoid_dynamic_calls, unnecessary_null_checks

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/models/CategoryModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/FilterPage/ShowAllProductsPage.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel? category;
  CategoryCard({Key? key, this.category}) : super(key: key);
  FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        filterController.categoryID.clear();
        filterController.producersID.value = [];
        final int? id = category!.id;
        filterController.mainCategoryID.value = id!;

        pushNewScreen(
          context,
          screen: ShowAllProductsPage(
            pageName: "${category!.name}",
            whichFilter: 5,
            searchPage: false,
          ),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        height: sizeWidth > 800 ? 150 : 120,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.25)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: backgroundColor.withOpacity(0.4),
              ),
              margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              width: sizeWidth > 800 ? 100 : 85,
              child: cachedMyImage("$serverImage/${category!.imagePath}-mini.webp"),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${category!.name}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeWidth > 800 ? 26 : 17,
                      fontFamily: montserratMedium,
                    ),
                  ),
                  Text("${category!.count}", maxLines: 2, style: TextStyle(color: Colors.grey.withOpacity(0.6), fontFamily: montserratRegular, fontSize: sizeWidth > 800 ? 24 : 16)),
                ],
              ),
            ),
            const Icon(IconlyLight.arrowRightCircle)
          ],
        ),
      ),
    );
  }
}
