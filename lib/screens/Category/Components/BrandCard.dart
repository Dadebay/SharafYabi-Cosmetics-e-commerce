// ignore_for_file: file_names, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/ShowAllProductsPage.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/models/CategoryModel.dart';

class BrandCard extends StatelessWidget {
  final CategoryModel brand;

  BrandCard(this.brand);
  FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // ignore: deprecated_member_use
      child: RaisedButton(
        onPressed: () {
          filterController.producersID.clear();
          filterController.categoryID.clear();

          filterController.producersID.add(brand.id);

          Get.to(() => ShowAllProductsPage(
                pageName: '${brand.name}',
                whichFilter: 4,
              ));
        },
        padding: EdgeInsets.zero,
        color: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
        elevation: 1,
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                  fadeInCurve: Curves.ease,
                  imageUrl: "$serverImage/${brand.imagePath}-mini.webp",
                  imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius20,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
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
            Container(
              width: Get.size.width,
              height: 1,
              color: backgroundColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "${brand.name}",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(color: Colors.black, fontFamily: montserratMedium),
              ),
            )
          ],
        ),
      ),
    );
  }
}
