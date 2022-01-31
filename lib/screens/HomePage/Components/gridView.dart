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
            if (snapshot.hasError) {
              return removeText == false ? const SizedBox.shrink() : errorConnection(buttonText: "retry", onTap: () {});
            } else if (snapshot.data!.isEmpty) {
              return removeText == false ? const SizedBox.shrink() : emptyData(imagePath: "", errorTitle: "emptyProducts", errorSubtitle: "emptyProductsSubtitle");
            } else if (snapshot.hasData) {
              if (whichFilter == 1) {
                filterController.recomended.value = true;
                filterController.discountBool.value = false;
                filterController.newInCome.value = false;
              } else if (whichFilter == 2) {
                filterController.recomended.value = false;
                filterController.discountBool.value = false;
                filterController.newInCome.value = true;
              } else if (whichFilter == 3) {
                filterController.recomended.value = false;
                filterController.discountBool.value = true;
                filterController.newInCome.value = false;
              }

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
