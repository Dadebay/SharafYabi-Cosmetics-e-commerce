// ignore_for_file: file_names, must_be_immutable, unnecessary_null_comparison, always_use_package_imports

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/CategoryModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/Category/Components/CategoryCard.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

import 'Components/BrandCard.dart';
import 'Components/ShimmerBrands.dart';
import 'Components/ShimmerCategory.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<List<CategoryModel>>? getCategory;
  Future<List<CategoryModel>>? getBrand;
  @override
  void initState() {
    super.initState();
    getCategory = CategoryModel().getCategory();
    getBrand = CategoryModel().getBrand();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(icon: IconlyLight.search, onTap: () {}, backArrow: false, iconRemove: false),
        body: Column(
          children: [
            Container(
              color: kPrimaryColor,
              child: TabBar(
                  labelStyle: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18),
                  unselectedLabelStyle: const TextStyle(fontFamily: montserratMedium, fontSize: 18),
                  labelColor: kPrimaryColor,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.white,
                  indicator: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      )),
                  tabs: [
                    Tab(
                      text: "category".tr,
                    ),
                    Tab(
                      text: "brendler".tr,
                    ),
                  ]),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FutureBuilder<List<CategoryModel>>(
                      future: getCategory,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return errorConnection(onTap: () {
                            CategoryModel().getCategory();
                          });
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return CategoryCard(category: snapshot.data?[index]);
                            },
                          );
                        }
                        return const ShimmerCategory();
                      }),
                  FutureBuilder<List<CategoryModel>>(
                      future: getBrand,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return errorConnection(onTap: () {
                            CategoryModel().getBrand();
                          });
                        } else if (snapshot.hasData) {
                          return GridView.builder(
                            itemCount: snapshot.data?.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 3 / 3.2),
                            itemBuilder: (BuildContext context, int index) {
                              return BrandCard(snapshot.data![index]);
                            },
                          );
                        }
                        return const ShimmerCategoryPart2();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
