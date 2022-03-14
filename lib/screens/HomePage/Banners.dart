// ignore_for_file: deprecated_member_use, file_names, avoid_types_as_parameter_names, non_constant_identifier_names, must_be_immutable, avoid_dynamic_calls, unnecessary_null_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/shimmers.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/models/BannersModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/FilterPage/ShowAllProductsPage.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/ProductProfilPage/ProductProfil.dart';

class Banners extends StatelessWidget {
  Banners({Key? key, this.banners}) : super(key: key);

  final Future<List<BannerModel>>? banners;

  @override
  Widget build(BuildContext context) {
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<List<BannerModel>>(
        future: banners,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return bannerCardShimmer();
          } else if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          } else if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index, count) {
                          return Container(
                            margin: const EdgeInsets.all(8),
                            child: RaisedButton(
                              onPressed: () {
                                Get.find<FilterController>().categoryID.clear();
                                Get.find<FilterController>().producersID.clear();
                                final int? itemID = snapshot.data![index].itemID;
                                final int? pathID = snapshot.data![index].pathID;
                                final int? id = itemID;
                                if (pathID == 2) {
                                  Get.find<FilterController>().mainCategoryID.value = id!;
                                  pushNewScreen(
                                    context,
                                    screen: const ShowAllProductsPage(
                                      pageName: "Sharafyabi",
                                      whichFilter: 0,
                                      searchPage: false,
                                    ),
                                    withNavBar: true,
                                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                  );
                                } else if (pathID == 3) {
                                  pushNewScreen(
                                    context,
                                    screen: ProductProfil(
                                      id: id,
                                      image: '',
                                      productName: "",
                                    ),
                                    withNavBar: true, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                  );
                                } else if (pathID == 4) {
                                  Get.find<FilterController>().mainCategoryID.value = 0;
                                  Get.find<FilterController>().categoryID.add({"id": itemID, "mainCategoryID": 0});
                                  pushNewScreen(
                                    context,
                                    screen: const ShowAllProductsPage(
                                      pageName: "Sharafyabi",
                                      whichFilter: 0,
                                      searchPage: false,
                                    ),
                                    withNavBar: true,
                                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                  );
                                }
                              },
                              shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                              padding: EdgeInsets.zero,
                              disabledColor: Colors.red,
                              elevation: 0,
                              disabledElevation: 1,
                              color: Colors.white,
                              child: CachedNetworkImage(
                                  fadeInCurve: Curves.ease,
                                  imageUrl: "$serverImage/${snapshot.data![index].imagePath}-big.webp",
                                  imageBuilder: (context, imageProvider) => Container(
                                        width: Get.size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: borderRadius5,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                  placeholder: (context, url) => Center(child: spinKit()),
                                  errorWidget: (context, url, error) => noImage()),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          onPageChanged: (index, CarouselPageChangedReason) {
                            Get.find<SettingsController>().bannerSelectedIndex.value = index;
                          },
                          height: sizeWidth > 800 ? sizeHeight / 3.4 : sizeHeight / 4,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                          autoPlayAnimationDuration: const Duration(milliseconds: 2000),
                        ),
                      ),
                      if (sizeWidth > 800)
                        const SizedBox(
                          height: 15,
                        )
                      else
                        const SizedBox.shrink(),
                      SizedBox(
                          height: sizeWidth > 800 ? 15 : 7,
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Obx(() {
                                  return AnimatedContainer(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    width: sizeWidth > 800
                                        ? Get.find<SettingsController>().bannerSelectedIndex.value == index
                                            ? 45
                                            : 15
                                        : Get.find<SettingsController>().bannerSelectedIndex.value == index
                                            ? 30
                                            : 7,
                                    decoration:
                                        BoxDecoration(color: Get.find<SettingsController>().bannerSelectedIndex.value == index ? kPrimaryColor : Colors.grey[300], borderRadius: borderRadius15),
                                  );
                                });
                              },
                            ),
                          )),
                    ],
                  );
          }
          return bannerCardShimmer();
        });
  }
}
