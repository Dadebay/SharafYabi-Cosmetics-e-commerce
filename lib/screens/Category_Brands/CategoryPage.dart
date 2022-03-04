// ignore_for_file: file_names, must_be_immutable, unnecessary_null_comparison, always_use_package_imports

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sharaf_yabi_ecommerce/cards/BrandCard.dart';
import 'package:sharaf_yabi_ecommerce/cards/CategoryCard.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/shimmers.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/CategoryModel.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double sizeWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: sizeWidth > 800 ? const Size.fromHeight(70) : const Size.fromHeight(kToolbarHeight),
            child: MyAppBar(icon: IconlyLight.search, onTap: () {}, backArrow: false, iconRemove: false)),
        body: Column(
          children: [
            TabBar(
                labelPadding: sizeWidth > 800 ? const EdgeInsets.symmetric(vertical: 8) : EdgeInsets.zero,
                labelStyle: TextStyle(fontFamily: montserratMedium, fontSize: sizeWidth > 800 ? 24 : 17),
                unselectedLabelStyle: TextStyle(fontFamily: montserratRegular, fontSize: sizeWidth > 800 ? 24 : 17),
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: kPrimaryColor,
                tabs: [
                  Tab(
                    text: "category".tr,
                  ),
                  Tab(
                    text: "brendler".tr,
                  ),
                ]),
            Expanded(
              child: TabBarView(
                children: [
                  FutureBuilder<List<CategoryModel>>(
                      future: CategoryModel().getCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return errorConnection(
                              onTap: () {
                                CategoryModel().getCategory();
                              },
                              sizeWidth: sizeWidth);
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return CategoryCard(category: snapshot.data?[index]);
                            },
                          );
                        }
                        return shimmerCategory();
                      }),
                  Container(
                    color: backgroundColor,
                    child: FutureBuilder<List<CategoryModel>>(
                        future: CategoryModel().getBrand(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return errorConnection(
                                onTap: () {
                                  CategoryModel().getBrand();
                                },
                                sizeWidth: sizeWidth);
                          } else if (snapshot.hasData) {
                            return GridView.builder(
                              itemCount: snapshot.data?.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: sizeWidth > 800 ? 4 : 3, childAspectRatio: 3 / 3.2),
                              itemBuilder: (BuildContext context, int index) {
                                return BrandCard(snapshot.data![index]);
                              },
                            );
                          }
                          return shimmerBrand();
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
