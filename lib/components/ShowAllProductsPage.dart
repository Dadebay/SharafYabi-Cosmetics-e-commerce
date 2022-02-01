// ignore_for_file: deprecated_member_use, file_names, avoid_dynamic_calls, unnecessary_null_checks

import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sharaf_yabi_ecommerce/components/ProductCard2.dart';
import 'package:sharaf_yabi_ecommerce/components/compackages.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/models/CategoryModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/SearchPage/Search.dart';
import 'package:sharaf_yabi_ecommerce/widgets/bottomSheetName.dart';

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
    filterController.list.clear();
    filterController.fetchProducts();
    filterController.page.value = 1;
    filterController.search.value = "";
    filterController.brandList.clear();
    filterController.categoryList.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.pageName,
            style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(IconlyLight.arrowLeft, color: Colors.black)),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => SearchPage());
                },
                icon: const Icon(IconlyLight.search, color: Colors.black)),
          ],
          elevation: 0,
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filterController.list.length,
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 4 / 6),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ProductCard2(
                                  id: filterController.list[index]["id"],
                                  name: filterController.list[index]["name"],
                                  price: filterController.list[index]["price"],
                                  image: filterController.list[index]["image"],
                                  discountValue: filterController.list[index]["discountValue"],
                                  quantity: filterController.list[index]["count"],
                                ),
                              );
                            }),
                      );
                    } else if (filterController.loading.value == 2) {
                      return emptyDataLottie(imagePath: "assets/lottie/searchNotFound.json", errorTitle: "emptyProducts", errorSubtitle: "emptyProductsSubtitle");
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
          Expanded(
            child: RaisedButton(
              onPressed: () {
                filterBottomSheet();
              },
              color: Colors.white,
              disabledColor: Colors.white,
              elevation: 0,
              splashColor: backgroundColor.withOpacity(0.2),
              disabledElevation: 0,
              highlightElevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(IconlyLight.filter, color: Colors.black),
                  ),
                  Text(
                    "filter".tr,
                    style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: backgroundColor,
            width: 1,
          ),
          Expanded(
            child: RaisedButton(
              onPressed: () {
                sortBottomSheet();
              },
              color: Colors.white,
              disabledColor: Colors.white,
              elevation: 0,
              splashColor: backgroundColor.withOpacity(0.2),
              disabledElevation: 0,
              highlightElevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.sort_rounded,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "sort".tr,
                    style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold),
                  )
                ],
              ),
            ),
          )
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
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          int? value;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => Container(
                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          Text(
                            "sort".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(CupertinoIcons.xmark_circle, color: Colors.black))
                        ],
                      ),
                    ),
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
                )),
          );
        });
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
            Obx(() {
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
            }),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: Get.size.width,
              child: RaisedButton(
                onPressed: () {
                  filterController.loading.value = 0;
                  filterController.list.clear();
                  filterController.fetchProducts();
                  Get.back();
                },
                color: kPrimaryColor,
                shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                disabledColor: kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 8),
                elevation: 1,
                child: Text(
                  "agree".tr,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: montserratSemiBold),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
          padding: const EdgeInsets.only(bottom: 25),
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
            )
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
                )
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
            padding: const EdgeInsets.only(bottom: 25),
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
              ))
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
