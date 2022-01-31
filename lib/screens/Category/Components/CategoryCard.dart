// ignore_for_file: file_names, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/ShowAllProductsPage.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/models/CategoryModel.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel? category;
  CategoryCard({Key? key, this.category}) : super(key: key);
  FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        filterController.categoryID.clear();
        filterController.producersID.value = [];
        final int? id = category!.id;
        filterController.mainCategoryID.value = id!;
        Get.to(() => ShowAllProductsPage(
              pageName: "${category!.name}",
              whichFilter: 5,
            ));
      },
      child: Container(
        height: 120,
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
              width: 85,
              child: CachedNetworkImage(
                  fadeInCurve: Curves.ease,
                  imageUrl: "$serverImage/${category!.imagePath}-mini.webp",
                  imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius20,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                  placeholder: (context, url) => Center(child: spinKit()),
                  errorWidget: (context, url, error) => Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/appLogo/greyLogo.png",
                          color: Colors.grey.withOpacity(0.4),
                          fit: BoxFit.fill,
                        ),
                      )),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14, bottom: 5),
                    child: Text(
                      "${category!.name}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: montserratSemiBold,
                      ),
                    ),
                  ),
                  Text("${category!.count}", maxLines: 2, style: TextStyle(color: Colors.grey.withOpacity(0.6), fontFamily: montserratRegular, fontSize: 16)),
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
