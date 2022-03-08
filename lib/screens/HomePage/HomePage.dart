// ignore_for_file: file_names, always_use_package_imports, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/cards/ProductCard3.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/shimmers.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';
import 'package:sharaf_yabi_ecommerce/models/BannersModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/FilterPage/ShowAllProductsPage.dart';

import 'Banners.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Future<List<BannerModel>>? banners;
  final FilterController filterController = Get.put(FilterController());
  final HomePageController _homePageController = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
    _homePageController.refreshList();
    banners = BannerModel().getBanners();
  }

  @override
  Widget build(BuildContext context) {
    final double sizeHeight = MediaQuery.of(context).size.height;
    final double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(sizeWidth, context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Banners(banners: banners),
            allProducts(
                sizeHeight: sizeHeight,
                sizeWidth: sizeWidth,
                list: _homePageController.list,
                name: "discountedProducts",
                loading: 1,
                onTap: () {
                  filterController.producersID.clear();
                  filterController.categoryID.clear();
                  filterController.categoryIDOnlyID.clear();
                  filterController.mainCategoryID.value = 0;
                  pushNewScreen(
                    context,
                    screen: ShowAllProductsPage(
                      pageName: "discountedProducts".tr,
                      whichFilter: 3,
                      searchPage: false,
                    ),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                retry: () {
                  _homePageController.fetchDiscountedProducts();
                }),
            allProducts(
                sizeHeight: sizeHeight,
                sizeWidth: sizeWidth,
                list: _homePageController.listNewInCome,
                name: "newProducts",
                loading: 2,
                onTap: () {
                  filterController.producersID.clear();
                  filterController.categoryID.clear();
                  filterController.categoryIDOnlyID.clear();
                  filterController.mainCategoryID.value = 0;
                  pushNewScreen(
                    context,
                    screen: ShowAllProductsPage(
                      pageName: "newProducts".tr,
                      whichFilter: 2,
                      searchPage: false,
                    ),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                retry: () {
                  _homePageController.fetchNewInComeProducts();
                }),
            allProducts(
                sizeHeight: sizeHeight,
                sizeWidth: sizeWidth,
                list: _homePageController.listRecomended,
                name: "popularProducts",
                loading: 3,
                onTap: () {
                  filterController.producersID.clear();
                  filterController.categoryID.clear();
                  filterController.categoryIDOnlyID.clear();
                  filterController.mainCategoryID.value = 0;
                  pushNewScreen(
                    context,
                    screen: ShowAllProductsPage(
                      pageName: "popularProducts".tr,
                      whichFilter: 1,
                      searchPage: false,
                    ),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                retry: () {
                  _homePageController.fetchPopularProducts();
                }),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }

  PreferredSize appBar(double sizeWidth, BuildContext context) {
    return PreferredSize(
      preferredSize: sizeWidth > 800 ? const Size.fromHeight(70) : const Size.fromHeight(kToolbarHeight),
      child: MyAppBar(
          icon: IconlyLight.search,
          onTap: () {
            pushNewScreen(
              context,
              screen: ShowAllProductsPage(
                pageName: "Sharafyabi".tr,
                whichFilter: 0,
                searchPage: true,
              ),
              withNavBar: true, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          backArrow: false,
          iconRemove: true),
    );
  }

  Widget allProducts({required double sizeWidth, required double sizeHeight, required String name, required Function() onTap, required List list, required Function() retry, required int loading}) {
    int loadingMine = 0;
    return Obx(() {
      if (loading == 1) {
        loadingMine = _homePageController.loading.value;
      } else if (loading == 2) {
        loadingMine = _homePageController.loadingNewInCome.value;
      } else if (loading == 3) {
        loadingMine = _homePageController.loadingRecomended.value;
      }
      if (loadingMine == 1) {
        return Wrap(
          children: [
            namePart(name: name.tr, sizeHeight: sizeHeight, sizeWidth: sizeWidth, onTap: onTap),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GridView.builder(
                  itemCount: list.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: sizeWidth > 800 ? 3 : 2, childAspectRatio: 1.5 / 2.5),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCard3(
                      id: list[index]["id"],
                      name: list[index]["name"],
                      price: list[index]["price"],
                      image: list[index]["image"],
                      discountValue: list[index]["discountValue"],
                      stockCount: list[index]["stockCount"],
                    );
                  }),
            )
          ],
        );
      } else if (loadingMine == 3) {
        return retryButton(retry);
      } else if (loadingMine == 0) {
        return shimmer(4);
      }
      return SizedBox.shrink();
    });
  }
}
