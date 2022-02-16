// ignore_for_file: deprecated_member_use, file_names, avoid_types_as_parameter_names, non_constant_identifier_names, must_be_immutable, avoid_dynamic_calls, unnecessary_null_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/ProductProfil.dart';
import 'package:sharaf_yabi_ecommerce/components/ShowAllProductsPage.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/models/BannersModel.dart';
import 'package:shimmer/shimmer.dart';

class Banners extends StatefulWidget {
  final Future<List<BannerModel>>? banners;

  const Banners({Key? key, this.banners}) : super(key: key);

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  FilterController filterController = Get.put(FilterController());

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BannerModel>>(
        future: widget.banners,
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
                          return bannerCard(index, snapshot.data![index].itemID, snapshot.data![index].pathID, snapshot.data![index].imagePath);
                        },
                        options: CarouselOptions(
                          onPageChanged: (index, CarouselPageChangedReason) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          aspectRatio: 16 / 8,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                          autoPlayAnimationDuration: const Duration(milliseconds: 2000),
                        ),
                      ),
                      SizedBox(
                          height: 7,
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AnimatedContainer(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  width: selectedIndex == index ? 30 : 7,
                                  decoration: BoxDecoration(color: selectedIndex == index ? kPrimaryColor : Colors.grey[300], borderRadius: borderRadius15),
                                );
                              },
                            ),
                          )),
                    ],
                  );
          }
          return bannerCardShimmer();
        });
  }

  Container bannerCard(int? index, int? itemID, int? pathID, String? image) {
    return Container(
      width: Get.size.width,
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
      child: RaisedButton(
        onPressed: () {
          filterController.categoryID.clear();
          filterController.producersID.value = [];

          final int? id = itemID;

          if (pathID == 2) {
            filterController.mainCategoryID.value = id!;
            Get.to(() => const ShowAllProductsPage(
                  pageName: "Sharafyabi",
                  whichFilter: 0,
                ));
          } else if (pathID == 3) {
            Get.to(() => ProductProfil(
                  id: id,
                  image: '',
                  productName: "",
                ));
          }
        },
        shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
        padding: EdgeInsets.zero,
        disabledColor: Colors.red,
        elevation: 1,
        disabledElevation: 1,
        color: Colors.white,
        child: ClipRRect(
          borderRadius: borderRadius10,
          child: CachedNetworkImage(
              fadeInCurve: Curves.ease,
              imageUrl: "$serverImage/$image-big.webp",
              imageBuilder: (context, imageProvider) => Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
              placeholder: (context, url) => Center(child: spinKit()),
              errorWidget: (context, url, error) => noImage()),
        ),
      ),
    );
  }

  Widget bannerCardShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        period: const Duration(seconds: 2),
        highlightColor: Colors.grey.withOpacity(0.1),
        child: AspectRatio(
          aspectRatio: 16 / 8,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: borderRadius10),
          ),
        ));
  }
}
