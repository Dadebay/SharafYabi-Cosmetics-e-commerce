// ignore_for_file: deprecated_member_use, file_names, avoid_dynamic_calls, unnecessary_null_checks, always_use_package_imports

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sharaf_yabi_ecommerce/cards/ProductCard3.dart';
import 'package:sharaf_yabi_ecommerce/components/agreeButton.dart';
import 'package:sharaf_yabi_ecommerce/components/appBar.dart';
import 'package:sharaf_yabi_ecommerce/components/bottomSheetName.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/shimmers.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/models/CategoryModel.dart';

import '../../../components/filterButton.dart';

class ShowAllProductsPage extends StatefulWidget {
  final String pageName;
  final int whichFilter;
  const ShowAllProductsPage({
    Key? key,
    required this.pageName,
    required this.whichFilter,
  }) : super(key: key);

  @override
  State<ShowAllProductsPage> createState() => _ShowAllProductsPageState();
}

class _ShowAllProductsPageState extends State<ShowAllProductsPage> {
  FilterController filterController = Get.put(FilterController());
  @override
  void initState() {
    super.initState();
    whenPageLoad();
  }

  final RefreshController _refreshController = RefreshController();

  void _onRefresh() {
    filterController.refreshPage();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    filterController.addPage();
    _refreshController.loadComplete();
  }

  void whenPageLoad() {
    if (widget.whichFilter == 1) {
      filterController.recomended.value = true;
      filterController.discountBool.value = false;
      filterController.newInCome.value = false;
    } else if (widget.whichFilter == 2) {
      filterController.recomended.value = false;
      filterController.discountBool.value = false;
      filterController.newInCome.value = true;
    } else if (widget.whichFilter == 3) {
      filterController.recomended.value = false;
      filterController.discountBool.value = true;
      filterController.newInCome.value = false;
    } else {
      filterController.recomended.value = false;
      filterController.discountBool.value = false;
      filterController.newInCome.value = false;
    }
    filterController.loading.value = 0;
    filterController.sortColumnName.value = "";
    filterController.list.clear();
    filterController.page.value = 1;
    filterController.fetchProducts();
    filterController.page.value = 1;
    filterController.search.value = "";
    filterController.brandList.clear();
    filterController.categoryList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: MyAppBar(
          icon: Icons.add,
          onTap: () {},
          backArrow: true,
          iconRemove: false,
          name: widget.pageName,
          addName: true,
        ),
        body: Column(
          children: [
            const Divider(
              thickness: 1,
              height: 1,
              color: backgroundColor,
            ),
            appBarBottom(),
            Expanded(
              child: SmartRefresher(
                  enablePullUp: true,
                  physics: const BouncingScrollPhysics(),
                  header: const MaterialClassicHeader(
                    color: kPrimaryColor,
                  ),
                  footer: loadMore(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: Obx(() {
                    if (filterController.loading.value == 1) {
                      return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filterController.list.length,
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5 / 2.5),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ProductCard3(
                                  id: filterController.list[index]["id"],
                                  image: filterController.list[index]["image"],
                                  name: filterController.list[index]["name"],
                                  price: filterController.list[index]["price"],
                                  discountValue: filterController.list[index]["discountValue"],
                                ));
                          });
                    } else if (filterController.loading.value == 2) {
                      return GestureDetector(
                        onTap: () {
                          filterController.fetchProducts();
                        },
                        child: Center(child: emptyDataLottie(imagePath: searchNotFound, errorTitle: "emptyProducts", errorSubtitle: "emptyProductsSubtitle")),
                      );
                    } else if (filterController.loading.value == 3) {
                      return retryButton(() {
                        filterController.fetchProducts();
                      });
                    } else if (filterController.loading.value == 0) {
                      return shimmer(10);
                    }
                    return const Text("Loading...", style: TextStyle(color: Colors.black, fontFamily: montserratSemiBold));
                  })),
            ),
          ],
        ));
  }

  Container appBarBottom() {
    return Container(
      color: Colors.white,
      height: 50,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilterButton(
            name: "filter",
            icon: IconlyLight.filter,
            onTap: () {
              filterBottomSheet();
            },
          ),
          Container(
            color: backgroundColor,
            width: 1,
          ),
          FilterButton(
            name: "sort",
            icon: Icons.sort_rounded,
            onTap: () {
              sortBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  int selectedIndex = 0;
  void sortBottomSheet() {
    final List title = [
      "recommended".tr,
      "cheapest".tr,
      "expensive".tr,
    ];
    Get.bottomSheet(StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      int? value;

      return Container(
          color: Colors.white,
          child: Wrap(
            children: [
              const BottomSheetName(name: "sort"),
              const Divider(
                height: 0,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) => RadioListTile(
                  value: index,
                  groupValue: value ?? selectedIndex,
                  activeColor: kPrimaryColor,
                  onChanged: (val) {
                    setState(() {
                      value = index;
                      selectedIndex = index;
                      filterController.loading.value = 0;
                      filterController.list.clear();
                      if (index == 0) {
                        filterController.sortName.value = "";
                        filterController.sortColumnName.value = "";
                      } else if (index == 1) {
                        filterController.sortName.value = "ASC";
                        filterController.sortColumnName.value = "p.price";
                      } else {
                        filterController.sortName.value = "DESC";
                        filterController.sortColumnName.value = "p.price";
                      }
                      filterController.fetchProducts();
                      Get.back();
                    });
                  },
                  title: Text(title[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: montserratRegular,
                        color: Colors.black,
                      )),
                ),
              ),
            ],
          ));
    }));
  }

  void filterBottomSheet() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            const BottomSheetName(
              name: "filter",
            ),
            const Divider(
              height: 0,
            ),
            if (widget.whichFilter == 4) const SizedBox.shrink() else brendFilter(),
            categoryFilter(),
            discountButton(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              child: AgreeButton(
                name: 'agree',
                onTap: () {
                  filterController.loading.value = 0;
                  filterController.list.clear();
                  filterController.fetchProducts();

                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget discountButton() {
    return Obx(() {
      return SwitchListTile.adaptive(
        value: filterController.discountBool.value,
        onChanged: (value) {
          filterController.discountBool.value = value;
        },
        activeColor: kPrimaryColor,
        title: Text(
          "discount".tr,
          style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18),
        ),
      );
    });
  }

  ListTile brendFilter() {
    return ListTile(
      title: Text(
        "brendler".tr,
        style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18),
      ),
      trailing: const Icon(IconlyLight.arrowRightCircle, color: Colors.black),
      onTap: () {
        Get.bottomSheet(Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(children: [
            const BottomSheetName(
              name: "brendler",
            ),
            const Divider(
              height: 1,
            ),
            Expanded(
              child: FutureBuilder<List<CategoryModel>>(
                  future: CategoryModel().getBrand(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          for (final element in snapshot.data!) {
                            filterController.writeBrandList(
                              element.id,
                              element.name,
                            );
                          }
                          if (widget.whichFilter == 1) {
                            return snapshot.data![index].recomended != 0 ? myCheckBoxBrand(index, snapshot) : const SizedBox.shrink();
                          } else if (widget.whichFilter == 2) {
                            return snapshot.data![index].newInCome != 0 ? myCheckBoxBrand(index, snapshot) : const SizedBox.shrink();
                          } else if (widget.whichFilter == 3) {
                            return snapshot.data![index].discount != 0 ? myCheckBoxBrand(index, snapshot) : const SizedBox.shrink();
                          } else {
                            return myCheckBoxBrand(index, snapshot);
                          }
                        },
                      );
                    } else {
                      return Center(
                        child: spinKit(),
                      );
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              child: AgreeButton(
                name: 'agree',
                onTap: () {
                  filterController.loading.value = 0;
                  filterController.list.clear();
                  filterController.fetchProducts();

                  Get.back();

                  Get.back();
                },
              ),
            ),
          ]),
        ));
      },
    );
  }

  StatefulBuilder myCheckBoxBrand(int index, AsyncSnapshot<List<CategoryModel>> snapshot) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Obx(() => CheckboxListTile(
              value: filterController.brandList[index]["value"],
              activeColor: kPrimaryColor,
              onChanged: (value) {
                filterController.brandList[index]["value"] = value;
                if (filterController.brandList[index]["value"] == true) {
                  filterController.producersID.add(filterController.brandList[index]["id"]);
                } else {
                  filterController.producersID.removeWhere((element) => element == filterController.brandList[index]["id"]);
                }
                setState(() {});
              },
              title: Text(
                "${snapshot.data![index].name}",
                style: const TextStyle(fontFamily: montserratRegular),
              ),
            )));
  }

  ListTile categoryFilter() {
    return ListTile(
      title: Text(
        "category".tr,
        style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18),
      ),
      trailing: const Icon(IconlyLight.arrowRightCircle, color: Colors.black),
      onTap: () {
        Get.bottomSheet(Container(
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 25),
          child: Column(
            children: [
              const BottomSheetName(
                name: "category",
              ),
              const Divider(
                height: 1,
              ),
              if (widget.whichFilter == 5)
                Expanded(
                  child: FutureBuilder<List<CategoryModel>>(
                      future: CategoryModel().getCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              for (final element in snapshot.data![index].sub!) {
                                filterController.writeCategoryList(element.id, element.name, snapshot.data![index].id!);
                              }

                              return snapshot.data![index].id == filterController.mainCategoryID.value
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data![index].sub!.length,
                                      itemBuilder: (BuildContext context, int indexx) {
                                        return myCheckBox(indexx, snapshot.data![index].sub![indexx].name, snapshot.data![index].sub![indexx].id);
                                      },
                                    )
                                  : const SizedBox.shrink();
                            },
                          );
                        } else {
                          return Center(
                            child: spinKit(),
                          );
                        }
                      }),
                )
              else
                Expanded(
                  child: FutureBuilder<List<CategoryModel>>(
                      future: CategoryModel().getCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (widget.whichFilter == 1) {
                                return snapshot.data![index].recomended != 0 ? categoryName(snapshot, index) : const SizedBox.shrink();
                              } else if (widget.whichFilter == 2) {
                                return snapshot.data![index].newInCome != 0 ? categoryName(snapshot, index) : const SizedBox.shrink();
                              } else if (widget.whichFilter == 3) {
                                return snapshot.data![index].discount != 0 ? categoryName(snapshot, index) : const SizedBox.shrink();
                              } else {
                                return categoryName(snapshot, index);
                              }
                            },
                          );
                        } else {
                          return Center(
                            child: spinKit(),
                          );
                        }
                      }),
                ),
            ],
          ),
        ));
      },
    );
  }

  ListTile categoryName(AsyncSnapshot<List<CategoryModel>> snapshot, int index) {
    return ListTile(
      title: Text(
        "${snapshot.data![index].name}",
        style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18),
      ),
      trailing: const Icon(IconlyLight.arrowRightCircle, color: Colors.black),
      onTap: () {
        for (final element in snapshot.data![index].sub!) {
          filterController.writeCategoryList(element.id, element.name, snapshot.data![index].id!);
        }

        Get.bottomSheet(Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(children: [
              const BottomSheetName(
                name: "subCategory",
              ),
              const Divider(
                height: 1,
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: snapshot.data![index].sub!.length,
                itemBuilder: (BuildContext context, int indexx) {
                  return myCheckBox(indexx, snapshot.data![index].sub![indexx].name, snapshot.data![index].sub![indexx].id);
                },
              )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                child: AgreeButton(
                  name: 'agree',
                  onTap: () {
                    filterController.loading.value = 0;
                    filterController.list.clear();
                    filterController.fetchProducts();

                    Get.back();
                    Get.back();

                    Get.back();
                  },
                ),
              ),
            ])));
      },
    );
  }

  StatefulBuilder myCheckBox(int index, String? name, int? idd) {
    bool valueMine = false;
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      for (final element in filterController.categoryList) {
        if (element["id"] == idd) {
          valueMine = element["value"];
        }
      }
      return CheckboxListTile(
        value: valueMine,
        activeColor: kPrimaryColor,
        onChanged: (value) {
          for (final element in filterController.categoryList) {
            if (element["id"] == idd) {
              element["value"] = value;
              filterController.mainCategoryID.value = element["mainCategoryID"];
              if (value == true) {
                if (filterController.categoryID.isEmpty) {
                  filterController.categoryID.add({"id": element["id"], "mainCategoryID": element["mainCategoryID"]});
                } else {
                  bool mineValue = false;
                  for (final element3 in filterController.categoryID) {
                    if (element["mainCategoryID"] == element3["mainCategoryID"]) {
                      mineValue = true;
                    }
                  }
                  if (mineValue == true) {
                    filterController.categoryID.add({"id": element["id"], "mainCategoryID": element["mainCategoryID"]});
                  } else {
                    for (final element4 in filterController.categoryList) {
                      element4["value"] = false;
                    }
                    element["value"] = value;
                    filterController.categoryID.clear();
                    filterController.categoryID.add({"id": element["id"], "mainCategoryID": element["mainCategoryID"]});
                  }
                }
              } else {
                filterController.categoryID.removeWhere((element2) => element["id"] == element2["id"]);
              }
            }
          }
          setState(() {});
        },
        title: Text(
          "$name",
          style: const TextStyle(fontFamily: montserratRegular),
        ),
      );
    });
  }
}
