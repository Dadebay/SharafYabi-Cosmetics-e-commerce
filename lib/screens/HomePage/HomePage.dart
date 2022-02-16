// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/ProductCard.dart';
import 'package:sharaf_yabi_ecommerce/components/ShowAllProductsPage.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/models/BannersModel.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductsModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/HomePage/Components/Banners.dart';
import 'package:sharaf_yabi_ecommerce/screens/HomePage/SearchPage/Search.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Future<List<ProductsModel>>? newInComeFuture;
  Future<List<ProductsModel>>? discountsFuture;
  Future<List<ProductsModel>>? getGridView;
  Future<List<BannerModel>>? banners;
  FilterController filterController = Get.put(FilterController());

  @override
  void initState() {
    super.initState();

    discountsFuture = ProductsModel().getProducts(
      parametrs: {
        "page": "1",
        "limit": "30",
        "discounts": "true",
      },
    );
    banners = BannerModel().getBanners();
    getGridView = ProductsModel().getProducts(
      parametrs: {"page": "1", "limit": "30", "recomended": "true"},
    );
    newInComeFuture = ProductsModel().getProducts(
      parametrs: {"page": "1", "limit": "30", "new_in_come": "true"},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor.withOpacity(0.2),
      appBar: MyAppBar(
          icon: IconlyLight.search,
          onTap: () {
            Get.to(() => SearchPage());
          },
          backArrow: false,
          iconRemove: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Banners(banners: banners),
            discountedProducts(),
            newInCome(),
            getGridViewItems(),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }

  Padding getGridViewItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FutureBuilder<List<ProductsModel>>(
          future: getGridView,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(child: spinKit()),
              );
            } else if (snapshot.data!.isEmpty) {
              return emptyData(imagePath: "", errorTitle: "emptyProducts", errorSubtitle: "emptyProductsSubtitle");
            } else if (snapshot.hasError) {
              return errorConnection(onTap: () {
                ProductsModel().getProducts(parametrs: {"page": "1", "limit": "30", "recomended": "true"});
              });
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("popularProducts".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
                        GestureDetector(
                          onTap: () {
                            filterController.producersID.clear();
                            filterController.categoryID.clear();
                            filterController.categoryIDOnlyID.clear();
                            filterController.mainCategoryID.value = 0;
                            Get.to(() => ShowAllProductsPage(
                                  pageName: "popularProducts".tr,
                                  whichFilter: 1,
                                ));
                          },
                          child: Row(
                            children: [
                              Text("all".tr, style: const TextStyle(color: kPrimaryColor, fontFamily: montserratMedium, fontSize: 14)),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(IconlyLight.arrowRightCircle, size: 20, color: kPrimaryColor),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  GridView.builder(
                    itemCount: snapshot.data?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3 / 4),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
                        child: ProductCard(
                          product: snapshot.data?[index],
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              return spinKit();
            }
          }),
    );
  }

  FutureBuilder<List<ProductsModel>> newInCome() {
    return FutureBuilder<List<ProductsModel>>(
        future: newInComeFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    height: 280,
                    margin: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        namePart(
                            name: "newProducts".tr,
                            onTap: () {
                              filterController.producersID.clear();
                              filterController.categoryID.clear();
                              filterController.categoryIDOnlyID.clear();
                              filterController.mainCategoryID.value = 0;
                              Get.to(() => ShowAllProductsPage(
                                    pageName: "newProducts".tr,
                                    whichFilter: 2,
                                  ));
                            }),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: 150,
                                margin: const EdgeInsets.only(left: 15),
                                padding: const EdgeInsets.only(
                                  bottom: 4,
                                ),
                                child: ProductCard(
                                  product: snapshot.data?[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          }
          return shimmerListView();
        });
  }

  FutureBuilder<List<ProductsModel>> discountedProducts() {
    return FutureBuilder<List<ProductsModel>>(
        future: discountsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          } else if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    height: 280,
                    margin: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        namePart(
                            name: "discountedProducts".tr,
                            onTap: () {
                              filterController.producersID.clear();
                              filterController.categoryID.clear();
                              filterController.categoryIDOnlyID.clear();
                              filterController.mainCategoryID.value = 0;
                              Get.to(() => ShowAllProductsPage(
                                    pageName: "discountedProducts".tr,
                                    whichFilter: 3,
                                  ));
                            }),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: 150,
                                margin: const EdgeInsets.only(left: 15),
                                padding: const EdgeInsets.only(
                                  bottom: 4,
                                ),
                                child: ProductCard(
                                  product: snapshot.data?[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          }
          return shimmerListView();
        });
  }

  SizedBox shimmerListView() {
    return SizedBox(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              period: const Duration(seconds: 2),
              highlightColor: Colors.grey.withOpacity(0.1),
              child:
                  Container(color: Colors.white, padding: const EdgeInsets.symmetric(vertical: 5), margin: const EdgeInsets.only(left: 15, top: 20), child: const Text("asdasd;akmsodkasdjkasodasd"))),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return shimmerHomeCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
