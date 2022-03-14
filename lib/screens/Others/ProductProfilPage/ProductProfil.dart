// ignore_for_file: deprecated_member_use, file_names, always_use_package_imports, avoid_dynamic_calls, type_annotate_public_apis, always_declare_return_types, invariant_booleans, avoid_positional_boolean_parameters, unnecessary_null_comparison, avoid_types_as_parameter_names, non_constant_identifier_names, unnecessary_statements

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sharaf_yabi_ecommerce/components/buttons/FavButton.dart';
import 'package:sharaf_yabi_ecommerce/components/buttons/addOrRemoveButton.dart';
import 'package:sharaf_yabi_ecommerce/components/cards/CommentCard.dart';
import 'package:sharaf_yabi_ecommerce/components/cards/ProductCard3.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/shimmers.dart';
import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/components/dialogs/diologs.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';
import 'package:sharaf_yabi_ecommerce/controllers/SettingsController.dart';
import 'package:sharaf_yabi_ecommerce/models/CommentModel.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductProfilModel.dart';
import 'package:sharaf_yabi_ecommerce/models/ProductsModel.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/AuthModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/CommentsPage/Comments.dart';
import 'package:sharaf_yabi_ecommerce/screens/Others/FilterPage/ShowAllProductsPage.dart';
import 'package:sharaf_yabi_ecommerce/screens/UserProfil/Auth/LoginPage.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

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
  final storage = GetStorage();

  double discountedPrice = 0.0;
  String imageMine = "";
  String name = "";
  double priceMine = 0.0;
  double priceOLD = 0.0;

  late Future<CommentModel> getComment;
  late Future<ProductProfilModel> getProduct;
  late Future<List<ProductsModel>> getSameProducts;

  @override
  void initState() {
    super.initState();
    name = widget.productName!;
    imageMine = widget.image!;
    getProduct = ProductProfilModel().getRealEstatesById(widget.id);
    getComment = CommentModel().getComment(id: widget.id ?? 0);
  }

  Padding specificationTexts({String? text1, String? text2, Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text(text1!, overflow: TextOverflow.ellipsis, maxLines: 3, style: TextStyle(color: Colors.grey[600], fontFamily: montserratSemiBold, fontSize: 16))),
          Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: onTap,
                child: Text(text2!, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16)),
              )),
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
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          )),
      actions: [
        IconButton(
          onPressed: () {
            Share.share(imageMine, subject: 'Sharafyabi programmasy');
          },
          icon: Icon(Icons.share, color: Colors.black),
        )
      ],
      title: Text(
        name,
        style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 18),
      ),
    );
  }

  Container namePart({required int discountValue, required int stockCount, required String name}) {
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
                        if (discountValue != 0 && discountValue != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Stack(
                              children: [
                                Positioned(left: 0, right: 5, top: 12, child: Transform.rotate(angle: pi / -14, child: Container(height: 1, color: Colors.red))),
                                Text("$priceOLD", style: const TextStyle(fontFamily: montserratRegular, fontSize: 18, color: Colors.grey)),
                              ],
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  AddOrRemoveButton(
                    id: widget.id!,
                    price: "$priceMine",
                    stockCount: stockCount,
                    sizeWidth: false,
                  ),
                ],
              ),
            ),
            Text("$name", style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 18)),
          ],
        ));
  }

  Column sameProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 25, bottom: 15),
          child: Text("sameProducts".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
        ),
        FutureBuilder<List<ProductsModel>>(
            future: getSameProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return shimmer(4);
              } else if (snapshot.hasData) {
                return snapshot.data.toString() == "[]"
                    ? Center(child: emptyDataLottie(imagePath: searchNotFound, errorSubtitle: "noSameProducts", errorTitle: ""))
                    : GridView.builder(
                        itemCount: snapshot.data?.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5 / 2.5),
                        itemBuilder: (BuildContext context, int index) {
                          return ProductCard3(
                            id: snapshot.data![index].id,
                            name: snapshot.data![index].productName,
                            price: snapshot.data![index].price,
                            image: snapshot.data![index].imagePath,
                            discountValue: snapshot.data![index].discountValue,
                            inOrder: false,
                            stockCount: snapshot.data![index].stockCount ?? 0,
                          );
                        },
                      );
              }
              return Center(child: emptyDataLottie(imagePath: searchNotFound, errorSubtitle: "noSameProducts", errorTitle: ""));
            })
      ],
    );
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
                  Get.find<SettingsController>().productProfilSelectedIndex.value = index;
                },
              ),
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return GestureDetector(
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: PhotoViewPage(
                          image: "$serverImage/${snapshot.data!.images[index]["destination"]}-big.webp",
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
                    return Obx(() {
                      return AnimatedContainer(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        width: Get.find<SettingsController>().productProfilSelectedIndex.value == index ? 30 : 7,
                        decoration: BoxDecoration(color: Get.find<SettingsController>().productProfilSelectedIndex.value == index ? kPrimaryColor : Colors.grey[300], borderRadius: borderRadius15),
                      );
                    });
                  },
                ),
              )),
        ),
        Positioned(
            top: 10,
            right: 5,
            child: FavButton(
              id: widget.id!,
            ))
      ],
    );
  }

  whenDataComesBacked({String? price, required int? discountValue, int? categoryID}) {
    priceMine = double.parse(price!);
    getSameProducts = ProductsModel().getProducts(
      parametrs: {
        "page": "1",
        "limit": "4",
        "product_id": "${widget.id}",
        "main_category_id": "$categoryID",
      },
    );
    if (discountValue != null || discountValue != 0) {
      priceOLD = priceMine;
      final int a = discountValue!;
      discountedPrice = (priceMine * a) / 100;
      priceMine -= discountedPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  whenDataComesBacked(price: snapshot.data!.price, discountValue: snapshot.data!.discountValue, categoryID: snapshot.data!.categoryId);
                  name = snapshot.data!.name!;
                  imageMine = "$serverImage/${snapshot.data!.images[0]["destination"]}-big.webp";
                  return Column(
                    children: [
                      imagePart(snapshot),
                      namePart(discountValue: snapshot.data!.discountValue!, name: snapshot.data!.name!, stockCount: int.parse(snapshot.data!.stock!)),
                      customContainer(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("spesification".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 17)),
                          const SizedBox(
                            height: 20,
                          ),
                          specificationTexts(
                              text1: "categoryName".tr,
                              text2: "${snapshot.data!.categoryName}",
                              onTap: () {
                                Get.find<FilterController>().categoryID.clear();
                                Get.find<FilterController>().producersID.value = [];
                                final int? id = snapshot.data!.categoryId;
                                Get.find<FilterController>().mainCategoryID.value = id!;
                                pushNewScreen(
                                  context,
                                  screen: ShowAllProductsPage(
                                    pageName: "${snapshot.data!.categoryName}",
                                    whichFilter: 5,
                                    searchPage: false,
                                  ),
                                  withNavBar: true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation: PageTransitionAnimation.fade,
                                );
                              }),
                          specificationTexts(
                              text1: "brandName".tr,
                              text2: "${snapshot.data!.producerName}",
                              onTap: () {
                                Get.find<FilterController>().producersID.clear();
                                Get.find<FilterController>().categoryID.clear();
                                Get.find<FilterController>().producersID.add(snapshot.data!.producerId);
                                pushNewScreen(
                                  context,
                                  screen: ShowAllProductsPage(
                                    pageName: '${snapshot.data!.producerName}',
                                    searchPage: false,
                                    whichFilter: 4,
                                  ),
                                  withNavBar: true, // OPTIONAL VALUE. True by default.
                                  pageTransitionAnimation: PageTransitionAnimation.fade,
                                );
                              }),
                          const SizedBox(
                            height: 30,
                          ),
                          if (snapshot.data!.description != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("description".tr, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 17)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text("${snapshot.data!.description}", style: const TextStyle(color: Colors.black, fontFamily: montserratRegular, fontSize: 16)),
                                ),
                              ],
                            ),
                        ],
                      )),
                      commentsPart(context),
                      sameProducts(),
                      const SizedBox(height: 60),
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

  Container commentsPart(BuildContext context) {
    return customContainer(ExpansionTile(
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
        Stack(
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
                          ? Container(margin: EdgeInsets.all(80), padding: EdgeInsets.only(bottom: 40), child: Lottie.asset(noCommentJson, height: 100, animate: true))
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
                    return Container(
                      margin: EdgeInsets.all(80),
                      padding: EdgeInsets.only(bottom: 40),
                      child: Lottie.asset(noCommentJson, height: 200, animate: true),
                    );
                  }),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: storage.read("AccessToken") == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.size.width,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: borderRadius5,
                            color: backgroundColor,
                          ),
                          child: Text(
                            "pleaseLogin".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kPrimaryColor, fontFamily: montserratRegular),
                          ),
                        ),
                        addCommentButton()
                      ],
                    )
                  : addCommentButton(),
            )
          ],
        )
      ],
    ));
  }

  TextEditingController controller = TextEditingController();

  SizedBox addCommentButton() {
    return SizedBox(
      width: Get.size.width,
      child: RaisedButton(
          onPressed: () async {
            final String? token = await Auth().getToken();
            if (token == null) {
              Get.to(() => LoginPage());
            } else {
              customDialog(
                controller: controller,
                secondTextFieldController: controller,
                hintText: "writeComment",
                maxLength: 70,
                maxLine: 3,
                secondTextField: false,
                title: "writeComment",
                onTap: () {
                  Get.find<SettingsController>().dialogsBool.value = !Get.find<SettingsController>().dialogsBool.value;
                  CommentModel().writeComment(id: widget.id, comment: controller.text).then((value) {
                    if (value == true) {
                      Get.back();
                      showSnackBar("commentAdded", "commentAddedSubtitle", kPrimaryColor);
                      controller.clear();
                    } else {
                      Vibration.vibrate();
                      showSnackBar("retry", "error404", kPrimaryColor);
                      controller.clear();
                    }
                    Get.find<SettingsController>().dialogsBool.value = !Get.find<SettingsController>().dialogsBool.value;
                  });
                },
              );
            }
          },
          color: kPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: borderRadius5),
          child: Text(
            storage.read("AccessToken") == null ? "login".tr : "writeComment".tr,
            style: TextStyle(
              color: Colors.white,
              fontFamily: montserratMedium,
            ),
          )),
    );
  }
}
