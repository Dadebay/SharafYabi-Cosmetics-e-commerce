// ignore_for_file: deprecated_member_use, file_names, always_use_package_imports, avoid_dynamic_calls, type_annotate_public_apis, always_declare_return_types, invariant_booleans, avoid_positional_boolean_parameters, unnecessary_null_comparison, avoid_types_as_parameter_names, non_constant_identifier_names, unnecessary_statements

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/cards/CommentCard.dart';
import 'package:sharaf_yabi_ecommerce/cards/ProductCard3.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/shimmers.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/CartPageController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/HomePageController.dart';
import 'package:sharaf_yabi_ecommerce/models/CommentModel.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductProfilModel.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductsModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/CommentsPage/Comments.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/FilterPage/ShowAllProductsPage.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

import '../../../controllers/ProductProfileController.dart';
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
  bool addCartBool = false;
  bool favBool = false;
  CartPageController cartPageController = Get.put(CartPageController());
  TextEditingController controller = TextEditingController();
  double discountedPrice = 0.0;
  Fav_Cart_Controller favCartController = Get.put(Fav_Cart_Controller());
  FilterController filterController = Get.put(FilterController());
  late Future<CommentModel> getComment;
  late Future<ProductProfilModel> getProduct;
  String imageMine = "";
  String name = "";
  double priceMine = 0.0;
  double priceOLD = 0.0;
  ProductProfilController productProfilController = Get.put(ProductProfilController());
  int selectedIndex = 0;

  final HomePageController _homePageController = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
    whenPageLoad();
    getProduct = ProductProfilModel().getRealEstatesById(widget.id);
    getComment = CommentModel().getComment(id: widget.id);
  }

  whenPageLoad() {
    name = widget.productName ?? "Sharafyabi";
    imageMine = widget.image ?? "asd";
    if (favCartController.cartList.isNotEmpty) {
      bool mine = false;
      for (final element in favCartController.cartList) {
        final int a = element["count"];
        if (a < 0) {
          element["count"] = 1;
        }
        if (element["id"] == widget.id) {
          mine = true;
          addCartBool = true;
          productProfilController.quantity.value = element["count"];
        }
      }
      if (mine == false) {
        addCartBool = false;
        productProfilController.quantity.value = 1;
      }
    } else {
      addCartBool = false;
      productProfilController.quantity.value = 1;
    }

    for (final element in favCartController.favList) {
      if (element["id"] == widget.id) {
        favBool = true;
      }
    }
  }

  Padding specificationTexts({String? text1, String? text2}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(text1!, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontFamily: montserratSemiBold, fontSize: 16))),
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
      leadingWidth: 50,
      titleSpacing: 0.0,
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
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
          child: Image.asset(shareIcon, width: 27, color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            favCartController.toggleFav(widget.id!);
            favBool = !favBool;
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(favBool == true ? IconlyBold.heart : IconlyLight.heart, color: favBool == true ? Colors.red : Colors.black, size: 28),
          ),
        ),
      ],
      title: Text(
        name,
        style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18),
      ),
    );
  }

  Widget bottomSheetMine(String? price) {
    return Container(
        child: addCartBool
            ? Container(
                decoration: const BoxDecoration(
                  borderRadius: borderRadius10,
                  color: kPrimaryColor,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        favCartController.removeCart(widget.id!);
                        _homePageController.searchAndRemove(widget.id!);
                        cartPageController.removeCard(widget.id!);
                        if (productProfilController.quantity.value > 1) {
                          if (filterController.list.isNotEmpty) {
                            for (final element2 in filterController.list) {
                              if (element2["id"] == widget.id) {
                                element2["count"]--;
                              }
                            }
                          }
                          productProfilController.quantity.value--;
                          showCustomToast(
                            context,
                            "productCountAdded".tr,
                          );
                        } else {
                          addCartBool = false;
                          showCustomToast(
                            context,
                            "removedFromCartTitle".tr,
                          );
                        }
                        setState(() {});
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(CupertinoIcons.minus_circled, color: Colors.white, size: 25),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Obx(() {
                        return Text(
                          "${productProfilController.quantity.value}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontFamily: montserratBold, fontSize: 26),
                        );
                      }),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (productProfilController.stockCount.value > (productProfilController.quantity.value + 1)) {
                          favCartController.addCart(widget.id!, price!);
                          cartPageController.addToCard(widget.id!);
                          _homePageController.searchAndAdd(widget.id!, price);
                          productProfilController.quantity.value++;
                          if (filterController.list.isNotEmpty) {
                            for (final element2 in filterController.list) {
                              if (element2["id"] == widget.id) {
                                element2["count"]++;
                              }
                            }
                          }
                          showCustomToast(
                            context,
                            "productCountAdded".tr,
                          );
                        } else {
                          Vibration.vibrate();
                          showCustomToast(
                            context,
                            "emptyStockSubtitle".tr,
                          );
                        }
                        setState(() {});
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(CupertinoIcons.add_circled, color: Colors.white, size: 25),
                      ),
                    ),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () {
                  if (productProfilController.stockCount.value > 2) {
                    if (priceOLD != 0.0) {
                      setState(() {
                        addCartBool = !addCartBool;
                        final int? a = widget.id;
                        favCartController.addCart(a!, price!);
                        showCustomToast(
                          context,
                          "addedToCardSubtitle".tr,
                        );
                      });
                    } else {
                      showSnackBar("retry", "error404", Colors.red);
                    }
                  }
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: borderRadius10,
                    ),
                    child: Text("addCart3".tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontFamily: montserratMedium, fontSize: 18))),
              ));
  }

  Column sameProducts(int? categoryId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 25, bottom: 15),
          child: Text("sameProducts".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
        ),
        FutureBuilder<List<ProductsModel>>(
            future: ProductsModel().getProducts(
              parametrs: {
                "page": "1",
                "limit": "10",
                "product_id": "${widget.id}",
                "main_category_id": "$categoryId",
              },
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return shimmer(10);
              } else if (snapshot.hasData) {
                return snapshot.data.toString() == "[]"
                    ? Center(child: emptyDataLottie(imagePath: searchNotFound, errorSubtitle: "noSameProducts", errorTitle: ""))
                    : GridView.builder(
                        itemCount: snapshot.data?.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5 / 2.5),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProductCard3(
                              id: snapshot.data![index].id,
                              name: snapshot.data![index].productName,
                              price: snapshot.data![index].price,
                              image: snapshot.data![index].imagePath,
                              discountValue: snapshot.data![index].discountValue,
                            ),
                          );
                        },
                      );
              }
              return Center(child: emptyDataLottie(imagePath: searchNotFound, errorSubtitle: "noSameProducts", errorTitle: ""));
            })
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
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(text: priceMine.toStringAsFixed(2), style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 24, color: Colors.black)),
                            const TextSpan(text: " m.", style: TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: Colors.black))
                          ]),
                        ),
                        if (snapshot.data!.discountValue != 0 && snapshot.data!.discountValue != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Stack(
                              children: [
                                Positioned(left: 0, right: 5, top: 10, child: Transform.rotate(angle: pi / -14, child: Container(height: 1, color: Colors.red))),
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(text: "$priceOLD", style: const TextStyle(fontFamily: montserratRegular, fontSize: 18, color: Colors.grey)),
                                    const TextSpan(text: " m.", style: TextStyle(fontFamily: montserratRegular, fontSize: 12, color: Colors.grey))
                                  ]),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  bottomSheetMine(snapshot.data!.price),
                ],
              ),
            ),
            Text("${snapshot.data!.name}", style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18)),
          ],
        ));
  }

  Stack imagePart(AsyncSnapshot<ProductProfilModel> snapshot) {
    return Stack(
      children: [
        if (snapshot.data!.images.toString() == "[]")
          noImage()
        else
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: CarouselSlider.builder(
              itemCount: snapshot.data!.images.length,
              options: CarouselOptions(
                height: Get.size.height / 2.5,
                viewportFraction: 1.0,
                onPageChanged: (index, CarouselPageChangedReason) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return GestureDetector(
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: PhotoViewPage(
                          image: "$serverImage/${snapshot.data!.images[index]["destination"]}-mini.webp",
                        ),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation: PageTransitionAnimation.fade,
                      );
                    },
                    child: CachedNetworkImage(
                        fadeInCurve: Curves.ease,
                        imageUrl: "$serverImage/${snapshot.data!.images[index]["destination"]}-big.webp",
                        imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                        placeholder: (context, url) => Center(child: spinKit()),
                        errorWidget: (context, url, error) => noImage()));
              },
            ),
          ),
        Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: SizedBox(
              height: 7,
              child: Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimatedContainer(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: selectedIndex == index ? 30 : 7,
                      decoration: BoxDecoration(color: selectedIndex == index ? kPrimaryColor : Colors.grey[300], borderRadius: borderRadius15),
                    );
                  },
                ),
              )),
        ),
        if (snapshot.data!.discountValue != 0 && snapshot.data!.discountValue != null)
          Positioned(
              bottom: 10,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius5),
                child: Text("- ${snapshot.data!.discountValue} %", style: const TextStyle(color: Colors.white, fontFamily: montserratRegular, fontSize: 16)),
              ))
        else
          const SizedBox.shrink(),
      ],
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
    favCartController.favList.isNotEmpty ? whenPageLoad() : null;
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar(),
        body: SingleChildScrollView(
          child: FutureBuilder<ProductProfilModel>(
              future: getProduct,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                      height: Get.size.height - 200, padding: const EdgeInsets.symmetric(horizontal: 15), child: emptyData(imagePath: emptyProducts, errorTitle: "retry", errorSubtitle: "error404"));
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
                                pushNewScreen(
                                  context,
                                  screen: ShowAllProductsPage(
                                    pageName: "${snapshot.data!.categoryName}",
                                    whichFilter: 5,
                                  ),
                                  withNavBar: true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation: PageTransitionAnimation.fade,
                                );
                              },
                              child: specificationTexts(text1: "categoryName".tr, text2: "${snapshot.data!.categoryName}")),
                          GestureDetector(
                              onTap: () {
                                filterController.producersID.clear();
                                filterController.categoryID.clear();

                                filterController.producersID.add(snapshot.data!.producerId);
                                pushNewScreen(
                                  context,
                                  screen: ShowAllProductsPage(
                                    pageName: '${snapshot.data!.producerName}',
                                    whichFilter: 4,
                                  ),
                                  withNavBar: true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation: PageTransitionAnimation.fade,
                                );
                              },
                              child: specificationTexts(text1: "brandName".tr, text2: "${snapshot.data!.producerName}")),
                          const SizedBox(
                            height: 30,
                          ),
                          if (snapshot.data!.description == null)
                            const SizedBox.shrink()
                          else
                            Text("description".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 17)),
                          if (snapshot.data!.description == null)
                            const SizedBox.shrink()
                          else
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text("${snapshot.data!.description}", style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 16)),
                            ),
                        ],
                      )),
                      customContainer(ExpansionTile(
                        iconColor: kPrimaryColor,
                        initiallyExpanded: true,
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
                                future: getComment,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                      child: spinKit(),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    return snapshot.data!.comments!.isEmpty
                                        ? noCommentwidget()
                                        : ListView.builder(
                                            physics: const BouncingScrollPhysics(),
                                            itemCount: snapshot.data!.comments!.length > 5 ? 5 : snapshot.data!.comments!.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return CommentCard(
                                                  addReplyButton: false,
                                                  userName: snapshot.data!.comments![index].fullName!,
                                                  userDescription: snapshot.data!.comments![index].commentMine!,
                                                  productID: widget.id!,
                                                  commentID: snapshot.data!.comments![index].id!);
                                            },
                                          );
                                  }
                                  return noCommentwidget();
                                }),
                          )
                        ],
                      )),
                      sameProducts(snapshot.data!.categoryId),
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
