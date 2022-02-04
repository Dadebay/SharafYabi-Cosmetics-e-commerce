// ignore_for_file: file_names, camel_case_types, must_be_immutable

import 'package:sharaf_yabi_ecommerce/components/ProductCard.dart';
import 'package:sharaf_yabi_ecommerce/components/ShowAllProductsPage.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/screens/HomePage/Components/packages.dart';

class gridViewMine extends StatelessWidget {
  final Map<String, String>? parametrs;
  final int whichFilter;
  final bool? removeText;
  FilterController filterController = Get.put(FilterController());

  gridViewMine({Key? key, this.parametrs, this.removeText, required this.whichFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: FutureBuilder<List<ProductsModel>>(
          future: ProductsModel().getProducts(parametrs: parametrs),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(child: spinKit()),
              );
            } else if (snapshot.data!.isEmpty) {
              return removeText == false ? const SizedBox.shrink() : emptyData(imagePath: "", errorTitle: "emptyProducts", errorSubtitle: "emptyProductsSubtitle");
            } else if (snapshot.hasError) {
              return removeText == false
                  ? const SizedBox.shrink()
                  : errorConnection(onTap: () {
                      ProductsModel().getProducts(parametrs: parametrs);
                    });
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  if (removeText == false)
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
                    )
                  else
                    const SizedBox.shrink(),
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
}
