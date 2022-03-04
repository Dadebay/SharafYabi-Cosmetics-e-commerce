// ignore_for_file: deprecated_member_use, always_declare_return_types, duplicate_ignore, type_annotate_public_apis, avoid_dynamic_calls, file_names, unnecessary_null_checks

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:sharaf_yabi_ecommerce/cards/ProductCard3.dart';
import 'package:sharaf_yabi_ecommerce/components/bottomSheetName.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/shimmers.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/models/CategoryModel.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FilterController filterController = Get.put(FilterController());
  @override
  void initState() {
    super.initState();
    filterController.mainCategoryID.value = 0;
    filterController.loading.value = 0;
    filterController.list.clear();
    filterController.page.value = 1;
    filterController.search.value = "";
    filterController.brandList.clear();
    filterController.categoryID.clear();
    filterController.categoryIDOnlyID.clear();
    filterController.categoryList.clear();
    filterController.recomended.value = false;
    filterController.newInCome.value = false;
    filterController.discountBool.value = false;
  }

  final RefreshController _refreshController = RefreshController();

  void _onRefresh() {
    filterController.refreshPage();
    filterController.search.value = "";
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    filterController.addPage();
    _refreshController.loadComplete();
  }

  Timer? searchOnStoppedTyping;

  _onChangeHandler(String value) {
    const duration = Duration(seconds: 1);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel());
    }
    setState(() => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(String value) {
    filterController.list.clear();
    filterController.loading.value = 0;
    filterController.search.value = value;
    filterController.fetchProducts();
  }

  Widget searchTextField() {
    return TextField(
      controller: textEditingController,
      style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 17),
      cursorColor: kPrimaryColor,
      onEditingComplete: () {
        search(textEditingController.text);
      },
      onChanged: _onChangeHandler,
      decoration: InputDecoration(
        hintText: "search".tr,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        suffixIcon: IconButton(
          icon: const Icon(IconlyLight.search, size: 26, color: Colors.black),
          color: kPrimaryColor,
          onPressed: () {},
        ),
        hintStyle: const TextStyle(color: Colors.black38, fontFamily: montserratMedium),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor, width: 3), borderRadius: borderRadius10),
        filled: true,
        fillColor: Colors.grey[200],
        enabledBorder: OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: Colors.grey.shade200, width: 2)),
      ),
    );
  }

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: searchTextField(),
          leadingWidth: 30,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(IconlyLight.arrowLeft, color: Colors.black)),
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
                  scrollDirection: Axis.vertical,
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
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 4 / 6, mainAxisSpacing: 12, crossAxisSpacing: 12),
                            itemBuilder: (BuildContext context, int index) {
                              return ProductCard3(
                                id: filterController.list[index]["id"],
                                image: filterController.list[index]["image"],
                                name: filterController.list[index]["name"],
                                price: filterController.list[index]["price"],
                                discountValue: filterController.list[index]["discountValue"],
                                stockCount: filterController.list[index]["stockCount"],
                              );
                            }),
                      );
                    } else if (filterController.loading.value == 2) {
                      return SingleChildScrollView(
                        child: Center(child: emptyDataLottie(imagePath: searchNotFound, errorTitle: "emptyProducts", errorSubtitle: "emptyProductsSubtitle")),
                      );
                    } else if (filterController.loading.value == 3) {
                      return retryButton(() {
                        filterController.list.clear();
                        filterController.loading.value = 0;
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
            brendFilter(),
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

                          return myCheckBoxBrand(index, snapshot);
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
              Expanded(
                child: FutureBuilder<List<CategoryModel>>(
                    future: CategoryModel().getCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return categoryName(snapshot, index);
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
