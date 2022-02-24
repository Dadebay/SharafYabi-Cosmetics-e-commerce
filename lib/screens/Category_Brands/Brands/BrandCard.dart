// ignore_for_file: file_names, must_be_immutable, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/FilterPage/ShowAllProductsPage.dart';
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
    final double sizeWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          filterController.producersID.clear();
          filterController.categoryID.clear();

          filterController.producersID.add(brand.id);
          pushNewScreen(
            context,
            screen: ShowAllProductsPage(
              pageName: '${brand.name}',
              whichFilter: 4,
            ),
            withNavBar: true, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
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
                  errorWidget: (context, url, error) => noImage()),
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
                style: TextStyle(color: Colors.black, fontSize: sizeWidth > 800 ? 26 : 18, fontFamily: montserratMedium),
              ),
            )
          ],
        ),
      ),
    );
  }
}
