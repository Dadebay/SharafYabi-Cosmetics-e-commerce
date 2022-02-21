// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/ProductCard3.dart';
import 'package:sharaf_yabi_ecommerce/components/ShowAllProductsPage.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';
import 'package:sharaf_yabi_ecommerce/models/BannersModel.dart';
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
  Future<List<BannerModel>>? banners;
  FilterController filterController = Get.put(FilterController());
  final HomePageController _homePageController = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
    _homePageController.fetchDiscountedProducts();
    _homePageController.fetchNewInComeProducts();
    _homePageController.fetchPopularProducts();
    banners = BannerModel().getBanners();
  }

  @override
  Widget build(BuildContext context) {
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor.withOpacity(0.2),
      appBar: PreferredSize(
        preferredSize: sizeWidth > 800 ? const Size.fromHeight(70) : const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(
            icon: IconlyLight.search,
            onTap: () {
              Get.to(() => SearchPage());
            },
            backArrow: false,
            iconRemove: true),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Banners(banners: banners),
            discountedProducts(sizeWidth, sizeHeight),
            newInCome(sizeWidth, sizeHeight),
            getGridViewItems(sizeWidth, sizeHeight),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }

  Widget getGridViewItems(double sizeWidth, double sizeHeight) {
    return Obx(() {
      if (_homePageController.loadingRecomended.value == 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 8, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text("popularProducts".tr, style: TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: sizeWidth > 800 ? 28 : 18)),
                  ),
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
                        Text("all".tr, style: TextStyle(color: kPrimaryColor, fontFamily: montserratMedium, fontSize: sizeWidth > 800 ? 22 : 14)),
                        const SizedBox(
                          width: 8,
                        ),
                        Icon(IconlyLight.arrowRightCircle, size: sizeWidth > 800 ? 25 : 20, color: kPrimaryColor),
                      ],
                    ),
                  )
                ],
              ),
            ),
            GridView.builder(
              itemCount: _homePageController.listRecomended.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: sizeWidth > 800 ? 3 : 2, childAspectRatio: 1.5 / 2.5),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProductCard3(
                    id: _homePageController.listRecomended[index]["id"],
                    name: _homePageController.listRecomended[index]["name"],
                    price: _homePageController.listRecomended[index]["price"],
                    image: _homePageController.listRecomended[index]["image"],
                    discountValue: _homePageController.listRecomended[index]["discountValue"],
                    index: index,
                  ),
                );
              },
            ),
          ],
        );
      } else if (_homePageController.loadingRecomended.value == 3) {
        return retryButton(() {
          _homePageController.fetchPopularProducts();
        });
      } else if (_homePageController.loadingRecomended.value == 0) {
        return Center(
          child: spinKit(),
        );
      }
      return Center(
        child: spinKit(),
      );
    });
  }

  Widget discountedProducts(double sizeWidth, double sizeHeight) {
    return Obx(() {
      if (_homePageController.loading.value == 1) {
        return Container(
          height: sizeWidth > 800 ? 360 : 400,
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              namePart(
                  name: "discountedProducts".tr,
                  sizeHeight: sizeHeight,
                  sizeWidth: sizeWidth,
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
                      itemCount: _homePageController.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: sizeWidth > 800 ? 220 : 180,
                          margin: const EdgeInsets.only(
                            left: 10,
                          ),
                          padding: const EdgeInsets.only(
                            bottom: 4,
                          ),
                          child: ProductCard3(
                            id: _homePageController.list[index]["id"],
                            name: _homePageController.list[index]["name"],
                            price: _homePageController.list[index]["price"],
                            image: _homePageController.list[index]["image"],
                            discountValue: _homePageController.list[index]["discountValue"],
                            index: index,
                          ),
                        );
                      })),
            ],
          ),
        );
      } else if (_homePageController.loading.value == 3) {
        return retryButton(() {
          _homePageController.fetchDiscountedProducts();
        });
      } else if (_homePageController.loading.value == 0) {
        return Center(
          child: spinKit(),
        );
      }
      return Center(
        child: spinKit(),
      );
    });
  }

  Widget newInCome(double sizeWidth, double sizeHeight) {
    return Obx(() {
      if (_homePageController.loadingNewInCome.value == 1) {
        return Container(
          height: sizeWidth > 800 ? 360 : 400,
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              namePart(
                  name: "newProducts".tr,
                  sizeHeight: sizeHeight,
                  sizeWidth: sizeWidth,
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
                      itemCount: _homePageController.listNewInCome.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: sizeWidth > 800 ? 220 : 180,
                          margin: const EdgeInsets.only(
                            left: 10,
                          ),
                          padding: const EdgeInsets.only(
                            bottom: 4,
                          ),
                          child: ProductCard3(
                            id: _homePageController.listNewInCome[index]["id"],
                            name: _homePageController.listNewInCome[index]["name"],
                            price: _homePageController.listNewInCome[index]["price"],
                            image: _homePageController.listNewInCome[index]["image"],
                            discountValue: _homePageController.listNewInCome[index]["discountValue"],
                            index: index,
                          ),
                        );
                      })),
            ],
          ),
        );
      } else if (_homePageController.loadingNewInCome.value == 3) {
        return retryButton(() {
          _homePageController.fetchNewInComeProducts();
        });
      } else if (_homePageController.loadingNewInCome.value == 0) {
        return Center(
          child: spinKit(),
        );
      }
      return Center(
        child: spinKit(),
      );
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
