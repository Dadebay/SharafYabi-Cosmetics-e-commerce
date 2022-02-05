// ignore_for_file: deprecated_member_use, file_names, always_use_package_imports, avoid_dynamic_calls, type_annotate_public_apis, always_declare_return_types, invariant_booleans

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';

import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductProfilModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/HomePage/Components/gridView.dart';
import 'package:share/share.dart';

import 'PhotoView.dart';

class ProductProfil extends StatefulWidget {
  final int? id;
  final String? productName;
  final String? image;

  const ProductProfil({Key? key, required this.id, this.productName, required this.image}) : super(key: key);
  @override
  _ProductProfilState createState() => _ProductProfilState();
}

class _ProductProfilState extends State<ProductProfil> {
  Fav_Cart_Controller favCartController = Get.put(Fav_Cart_Controller());
  FilterController filterController = Get.put(FilterController());
  CartPageController cartPageController = Get.put(CartPageController());
  bool addCart = false;
  String name = "";
  String imageMine = "";
  @override
  void initState() {
    super.initState();
    name = widget.productName ?? "SharafÝabi";
    imageMine = widget.image ?? "asd";
    if (Get.find<Fav_Cart_Controller>().cartList.isNotEmpty) {
      Get.find<Fav_Cart_Controller>().cartList.forEach((element) {
        if (element["id"] == widget.id) {
          addCart = true;
          favCartController.quantity.value = element["count"];
        }
      });
    } else {
      addCart = false;
      favCartController.quantity.value = 1;
    }

    if (Get.find<Fav_Cart_Controller>().favList.isNotEmpty) {
      Get.find<Fav_Cart_Controller>().favList.forEach((element) {
        if (element["id"] == widget.id) {
          favCartController.favBool.value = true;
        } else {
          favCartController.favBool.value = false;
        }
      });
    } else {
      favCartController.favBool.value = false;
    }
  }

  double priceOLD = 0.0;

  changeNameAndImage(ProductProfilModel product) {
    name = product.producerName ?? "SharafÝabi";
    imageMine = product.image ?? " ASD";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
        bottomSheet: bottomSheetMine(),
        body: SingleChildScrollView(
          child: FutureBuilder<ProductProfilModel>(
              future: ProductProfilModel().getRealEstatesById(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                      height: Get.size.height - 200,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: emptyData(imagePath: "assets/icons/svgIcons/EmptyPageIcon.png", errorTitle: "retry", errorSubtitle: "error404"));
                } else if (snapshot.hasData) {
                  double priceMine = double.parse(snapshot.data!.price!);

                  if (snapshot.data!.discountValue != null || snapshot.data!.discountValue != 0) {
                    double price = 0.0;
                    priceOLD = priceMine;
                    final int a = snapshot.data!.discountValue ?? 0;
                    price = (priceMine * a) / 100;
                    priceMine -= price;
                  }
                  if (widget.productName == "") {
                    changeNameAndImage(snapshot.data!);
                  }
                  favCartController.stockCount.value = int.parse("${snapshot.data!.stock}");

                  return Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: Get.size.height / 2.5,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => PhotoViewPage(
                                      image: "$serverImage/${snapshot.data!.image}-large.webp",
                                    ));
                              },
                              child: CachedNetworkImage(
                                  fadeInCurve: Curves.ease,
                                  imageUrl: "$serverImage/${snapshot.data!.image}-mini.webp",
                                  imageBuilder: (context, imageProvider) => Container(
                                        padding: EdgeInsets.zero,
                                        margin: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                  placeholder: (context, url) => Center(child: spinKit()),
                                  errorWidget: (context, url, error) => Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Image.asset(
                                          "assets/appLogo/greyLogo.png",
                                          color: Colors.grey,
                                        ),
                                      )),
                            ),
                          ),
                          if (snapshot.data!.discountValue != 0 && snapshot.data!.discountValue != null)
                            Positioned(
                                bottom: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius5),
                                  child: Text("- ${snapshot.data!.discountValue} %", style: const TextStyle(color: Colors.white, fontFamily: montserratMedium, fontSize: 16)),
                                ))
                          else
                            const SizedBox.shrink(),
                        ],
                      ),
                      Container(
                          width: Get.size.width,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.only(top: 28),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(text: priceMine.toStringAsFixed(2), style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 24, color: Colors.black)),
                                      const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: Colors.black))
                                    ]),
                                  ),
                                  if (snapshot.data!.discountValue != 0 && snapshot.data!.discountValue != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(text: "$priceOLD", style: const TextStyle(decoration: TextDecoration.lineThrough, fontFamily: montserratMedium, fontSize: 20, color: Colors.grey)),
                                          const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratMedium, decoration: TextDecoration.lineThrough, fontSize: 16, color: Colors.grey))
                                        ]),
                                      ),
                                    )
                                  else
                                    const SizedBox.shrink(),
                                ],
                              ),
                              Text("${snapshot.data!.name}", style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18)),
                            ],
                          )),
                      whitePart(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("spesification".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
                          specText(text1: "categoryName".tr, text2: "${snapshot.data!.categoryName}"),
                          specText(text1: "brandName".tr, text2: "${snapshot.data!.producerName}"),
                          const SizedBox(height: 20),
                          Text("description".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
                          Text("${snapshot.data!.description}", style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18)),
                        ],
                      )),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text("sameProducts".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
                          ),
                          gridViewMine(
                            whichFilter: 0,
                            parametrs: {
                              "page": "1",
                              "limit": "20",
                              "product_id": "${widget.id}",
                              "main_category_id": "${snapshot.data!.categoryId}",
                            },
                            removeText: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                    ],
                  );
                }
                return SizedBox(
                  height: Get.size.height,
                  child: Center(child: spinKit()),
                );
              }),
        ));
  }

  Padding specText({String? text1, String? text2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(text1!, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontFamily: montserratMedium, fontSize: 17))),
          Expanded(
              flex: 3,
              child: Text(
                '.' * 100,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              )),
          Expanded(flex: 2, child: Text(text2!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 17))),
        ],
      ),
    );
  }

  Container whitePart(Widget widget) {
    return Container(width: Get.size.width, padding: const EdgeInsets.all(20), margin: const EdgeInsets.only(top: 15), color: Colors.white, child: widget);
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      leadingWidth: 25,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          )),
      actions: [
        GestureDetector(
          onTap: () {
            Share.share(imageMine, subject: 'SharafÝabi programmasy');
          },
          child: Image.asset("assets/icons/share.png", width: 27, color: Colors.black),
        ),
        Obx(() {
          return GestureDetector(
            onTap: () {
              Get.find<Fav_Cart_Controller>().toggleFav(widget.id!);
              favCartController.favBool.value = !favCartController.favBool.value;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(favCartController.favBool.value == true ? IconlyBold.heart : IconlyLight.heart, color: favCartController.favBool.value == true ? Colors.red : Colors.black, size: 28),
            ),
          );
        }),
      ],
      title: Text(
        name,
        style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18),
      ),
    );
  }

  Widget bottomSheetMine() {
    return Container(
      color: kPrimaryColor,
      width: Get.size.width,
      child: addCart
          ? Row(
              children: [
                RaisedButton(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    color: Colors.white,
                    elevation: 2,
                    onPressed: () {
                      Get.find<Fav_Cart_Controller>().cartList.forEach((element) {
                        if (element["id"] == widget.id) {
                          element["count"]--;
                          cartPageController.removeCard(element["id"]);
                          if (filterController.list.isNotEmpty) {
                            for (final element in filterController.list) {
                              if (element["id"] == widget.id) {
                                element["count"]--;
                              }
                            }
                          }
                          if (favCartController.quantity.value == 1) {
                            addCart = false;
                          } else {
                            favCartController.quantity.value--;
                          }
                        }
                      });
                      setState(() {});
                    },
                    child: const Icon(CupertinoIcons.minus_circled, color: kPrimaryColor, size: 34)),
                Expanded(
                  child: Container(
                      color: kPrimaryColor,
                      child: Text(
                        "${favCartController.quantity.value}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontFamily: montserratBold, fontSize: 24),
                      )),
                ),
                RaisedButton(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    color: Colors.white,
                    elevation: 2,
                    onPressed: () {
                      Get.find<Fav_Cart_Controller>().cartList.forEach((element) {
                        if (element["id"] == widget.id) {
                          if (favCartController.stockCount.value > (element["count"] + 1)) {
                            favCartController.quantity.value++;
                            if (filterController.list.isNotEmpty) {
                              for (final element2 in filterController.list) {
                                if (element2["id"] == widget.id) {
                                  element2["count"]++;
                                }
                              }
                            }
                            cartPageController.addToCard(element["id"]);
                            element["count"]++;
                          } else {
                            showSnackBar("emptyStockMin", "emptyStockSubtitle", Colors.red);
                          }
                        }
                      });
                      setState(() {});
                    },
                    child: const Icon(CupertinoIcons.add_circled, color: kPrimaryColor, size: 34)),
              ],
            )
          : RaisedButton(
              onPressed: () {
                setState(() {
                  if (priceOLD != 0.0) {
                    addCart = !addCart;
                    final int? a = widget.id;
                    Get.find<Fav_Cart_Controller>().addCart(a!);
                  } else {
                    showSnackBar("retry", "error404", Colors.red);
                  }
                });
              },
              color: kPrimaryColor.withOpacity(0.8),
              disabledColor: kPrimaryColor.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(vertical: 15),
              highlightColor: Colors.white.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(IconlyLight.buy, size: 28, color: Colors.white),
                  ),
                  Text("addCart3".tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 20)),
                ],
              )),
    );
  }
}
