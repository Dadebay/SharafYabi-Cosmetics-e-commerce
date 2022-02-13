// ignore_for_file: deprecated_member_use, file_names, always_use_package_imports, avoid_dynamic_calls, type_annotate_public_apis, always_declare_return_types, invariant_booleans, avoid_positional_boolean_parameters, unnecessary_null_comparison

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/components/Comments.dart';
import 'package:sharaf_yabi_ecommerce/components/ShowAllProductsPage.dart';

import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/models/CommentModel.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductProfilModel.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/AuthModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/HomePage/Components/gridView.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

import '../controllers/ProductProfileController.dart';
import 'PhotoView.dart';

class ProductProfil extends StatefulWidget {
  const ProductProfil({Key? key, required this.id, this.productName, required this.image}) : super(key: key);

  final int? id;
  final String? image;
  final String? productName;

  @override
  _ProductProfilState createState() => _ProductProfilState();
}

class _ProductProfilState extends State<ProductProfil> {
  CartPageController cartPageController = Get.put(CartPageController());
  TextEditingController controller = TextEditingController();
  Fav_Cart_Controller favCartController = Get.put(Fav_Cart_Controller());
  FilterController filterController = Get.put(FilterController());
  ProductProfilController productProfilController = Get.put(ProductProfilController());

  String imageMine = "";
  String name = "";
  double priceMine = 0.0;
  double priceOLD = 0.0;
  double discountedPrice = 0.0;

  @override
  void initState() {
    super.initState();
    whenPageLoad();
  }

  whenPageLoad() {
    name = widget.productName ?? "SharafÝabi";
    imageMine = widget.image ?? "asd";
    if (favCartController.cartList.isNotEmpty) {
      for (final element in favCartController.cartList) {
        final int a = element["count"];
        if (a < 0) {
          element["count"] = 1;
        }
        if (element["id"] == widget.id) {
          productProfilController.addCartBool.value = true;
          productProfilController.quantity.value = element["count"];
        }
      }
    } else {
      productProfilController.addCartBool.value = false;
      productProfilController.quantity.value = 1;
    }
    if (favCartController.favList.isNotEmpty) {
      for (final element in favCartController.favList) {
        if (element["id"] == widget.id) {
          productProfilController.favBool.value = true;
        } else {
          productProfilController.favBool.value = false;
        }
      }
    } else {
      productProfilController.favBool.value = false;
    }
  }

  Padding specificationTexts({String? text1, String? text2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(text1!, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontFamily: montserratMedium, fontSize: 16))),
          Expanded(flex: 2, child: Text(text2!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16))),
        ],
      ),
    );
  }

  Container customContainer(Widget widget) {
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
            Share.share(imageMine, subject: 'Sharafyabi programmasy');
          },
          child: Image.asset("assets/icons/share.png", width: 27, color: Colors.black),
        ),
        Obx(() {
          return GestureDetector(
            onTap: () {
              favCartController.toggleFav(widget.id!);
              productProfilController.favBool.value = !productProfilController.favBool.value;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(productProfilController.favBool.value == true ? IconlyBold.heart : IconlyLight.heart,
                  color: productProfilController.favBool.value == true ? Colors.red : Colors.black, size: 28),
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
    return Obx(() {
      return Container(
        color: kPrimaryColor,
        width: Get.size.width,
        child: productProfilController.addCartBool.value
            ? Row(
                children: [
                  RaisedButton(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: Colors.white,
                      elevation: 2,
                      onPressed: () {
                        favCartController.removeCart(widget.id!);
                        cartPageController.removeCard(widget.id!);
                        if (productProfilController.quantity.value > 1) {
                          productProfilController.quantity.value--;
                        } else {
                          productProfilController.addCartBool.value = false;
                        }
                      },
                      child: const Icon(CupertinoIcons.minus_circled, color: kPrimaryColor, size: 34)),
                  Expanded(
                    child: Container(
                        color: kPrimaryColor,
                        child: Text(
                          "${productProfilController.quantity.value}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontFamily: montserratBold, fontSize: 24),
                        )),
                  ),
                  RaisedButton(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: Colors.white,
                      elevation: 2,
                      onPressed: () {
                        if (productProfilController.stockCount.value > (productProfilController.quantity.value + 1)) {
                          favCartController.addCart(widget.id!);
                          cartPageController.addToCard(widget.id!);

                          productProfilController.quantity.value++;
                          if (filterController.list.isNotEmpty) {
                            for (final element2 in filterController.list) {
                              if (element2["id"] == widget.id) {
                                element2["count"]++;
                              }
                            }
                          }
                        }
                        {
                          Vibration.vibrate();
                          showSnackBar("emptyStockMin", "emptyStockSubtitle", Colors.red);
                        }
                      },
                      child: const Icon(CupertinoIcons.add_circled, color: kPrimaryColor, size: 34)),
                ],
              )
            : RaisedButton(
                onPressed: () {
                  if (priceOLD != 0.0) {
                    productProfilController.addCartBool.value = !productProfilController.addCartBool.value;
                    final int? a = widget.id;
                    favCartController.addCart(a!);
                  } else {
                    showSnackBar("retry", "error404", Colors.red);
                  }
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
    });
  }

  Column sameProducts(AsyncSnapshot<ProductProfilModel> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 25, bottom: 15),
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
    );
  }

  Container namePArt(double priceMine, AsyncSnapshot<ProductProfilModel> snapshot) {
    return Container(
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
                  RotationTransition(
                    turns: const AlwaysStoppedAnimation(-2 / 360),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("$priceOLD" + " TMT", style: const TextStyle(decoration: TextDecoration.lineThrough, fontFamily: montserratRegular, fontSize: 18, color: Colors.grey))),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
            Text("${snapshot.data!.name}", style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18)),
          ],
        ));
  }

  Stack imagePart(AsyncSnapshot<ProductProfilModel> snapshot) {
    return Stack(
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
                errorWidget: (context, url, error) => noImage()),
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
    );
  }

  Widget commentCard(String? userName, String? userDescription, bool addReply, int? commentIDMine) {
    return Padding(
      padding: addReply ? const EdgeInsets.symmetric(vertical: 10) : const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.3), shape: BoxShape.circle),
            child: Text(userName!.substring(0, 1).toUpperCase(), style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 22)),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration:
                        const BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(userName, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(userDescription!, maxLines: 8, style: const TextStyle(color: Colors.black87, fontFamily: montserratRegular, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                  if (addReply)
                    GestureDetector(
                      onTap: () async {
                        final String? token = await Auth().getToken();
                        if (token == null) {
                          showSnackBar("retry", "pleaseLogin", Colors.red);
                        } else {
                          Get.defaultDialog(
                            radius: 4,
                            title: "writeComment".tr,
                            titleStyle: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 24),
                            content: Column(
                              children: [
                                TextFormField(
                                  controller: controller,
                                  textCapitalization: TextCapitalization.sentences,
                                  cursorColor: kPrimaryColor,
                                  maxLines: 3,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(70),
                                  ],
                                  style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "errorEmpty".tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      label: Text("writeComment".tr),
                                      alignLabelWithHint: true,
                                      prefixIconConstraints: const BoxConstraints.tightForFinite(),
                                      labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
                                      constraints: const BoxConstraints(),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
                                      border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: borderRadius10,
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                          )),
                                      focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2))),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: Get.size.width,
                                  child: RaisedButton(
                                      onPressed: () {
                                        CommentModel().writeSubComment(id: widget.id, comment: controller.text, commentID: commentIDMine).then((value) {
                                          if (value == true) {
                                            Get.back();
                                            showSnackBar("commentAdded", "commentAddedSubtitle", kPrimaryColor);
                                            controller.clear();
                                          } else {
                                            Vibration.vibrate();
                                            showSnackBar("retry", "error404", kPrimaryColor);
                                            controller.clear();
                                          }
                                        });
                                      },
                                      color: kPrimaryColor,
                                      child: Text("send".tr, style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 20))),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.comment_outlined, color: Colors.black54, size: 18),
                            ),
                            Text("reply".tr, style: const TextStyle(color: Colors.black54, fontFamily: montserratSemiBold, fontSize: 14)),
                          ],
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  whenDataComesBacked({String? price, required String? stockCount, required int? discountValue}) {
    priceMine = double.parse(price!);

    if (discountValue != null || discountValue != 0) {
      priceOLD = priceMine;
      final int a = discountValue!;
      discountedPrice = (priceMine * a) / 100;
      priceMine -= discountedPrice;
    }

    productProfilController.stockCount.value = int.parse(stockCount!);
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
                      child: emptyData(imagePath: "assets/emptyState/emptyProducts.png", errorTitle: "retry", errorSubtitle: "error404"));
                } else if (snapshot.hasData) {
                  whenDataComesBacked(price: snapshot.data!.price, stockCount: snapshot.data!.stock, discountValue: snapshot.data!.discountValue);
                  return Column(
                    children: [
                      imagePart(snapshot),
                      namePArt(priceMine, snapshot),
                      customContainer(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("spesification".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 17)),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                              onTap: () {
                                filterController.categoryID.clear();
                                filterController.producersID.value = [];
                                final int? id = snapshot.data!.categoryId;
                                filterController.mainCategoryID.value = id!;
                                Get.to(() => ShowAllProductsPage(
                                      pageName: "${snapshot.data!.categoryName}",
                                      whichFilter: 5,
                                    ));
                              },
                              child: specificationTexts(text1: "categoryName".tr, text2: "${snapshot.data!.categoryName}")),
                          GestureDetector(
                              onTap: () {
                                filterController.producersID.clear();
                                filterController.categoryID.clear();

                                filterController.producersID.add(snapshot.data!.producerId);

                                Get.to(() => ShowAllProductsPage(
                                      pageName: '${snapshot.data!.producerName}',
                                      whichFilter: 4,
                                    ));
                              },
                              child: specificationTexts(text1: "brandName".tr, text2: "${snapshot.data!.producerName}")),
                          const SizedBox(
                            height: 30,
                          ),
                          Text("description".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 17)),
                          Text("${snapshot.data!.description}", style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 16)),
                        ],
                      )),
                      customContainer(ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => CommentsPage(
                                      productID: widget.id!,
                                    )));
                          },
                          child: Text("comments".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
                        ),
                        children: [
                          SizedBox(
                            height: 400,
                            child: FutureBuilder<CommentModel>(
                                future: CommentModel().getComment(id: widget.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                      child: spinKit(),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    return snapshot.data!.comments!.isEmpty
                                        ? Center(child: Text("nocomment".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold)))
                                        : ListView.builder(
                                            physics: const BouncingScrollPhysics(),
                                            itemCount: snapshot.data!.comments!.length > 5 ? 5 : snapshot.data!.comments!.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return commentCard(snapshot.data!.comments![index].fullName, snapshot.data!.comments![index].commentMine, true, snapshot.data!.comments![index].id);
                                            },
                                          );
                                  }
                                  return Center(child: Text("nocomment".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold)));
                                }),
                          )
                        ],
                      )),
                      sameProducts(snapshot),
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
}
