// ignore_for_file: file_names, deprecated_member_use, always_use_package_imports, avoid_bool_literals_in_conditional_expressions, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sharaf_yabi_ecommerce/components/ProductProfil.dart';
import 'package:sharaf_yabi_ecommerce/models/FavoriteModel.dart';
import 'package:sharaf_yabi_ecommerce/screens/HomePage/Components/packages.dart';
import 'package:sharaf_yabi_ecommerce/widgets/addCartButton.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';

import 'Components/FavCardShimmer.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(
            icon: IconlyLight.delete,
            addName: true,
            name: "favorite",
            onTap: () {
              Get.find<Fav_Cart_Controller>().clearFavList();
              setState(() {});
            },
            backArrow: true,
            iconRemove: Get.find<Fav_Cart_Controller>().favList.isNotEmpty ? true : false),
        body: Get.find<Fav_Cart_Controller>().favList.isEmpty
            ? GestureDetector(onTap: () {}, child: emptyData(imagePath: "assets/emptyState/emptyFav.png", errorTitle: "emptyFavoriteTitle", errorSubtitle: "emptyFavoriteSubtitle"))
            : FutureBuilder<List<FavoriteModel>>(
                future: FavoriteModel().getFavorites(parametrs: {"products": jsonEncode(Get.find<Fav_Cart_Controller>().favList)}),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return errorConnection(onTap: () {
                      FavoriteModel().getFavorites(parametrs: {"products": jsonEncode(Get.find<Fav_Cart_Controller>().favList)});
                    });
                  } else if (snapshot.data!.isEmpty) {
                    return emptyData(imagePath: "assets/emptyState/emptyFav.png", errorTitle: "emptyFavoriteTitle", errorSubtitle: "emptyFavoriteSubtitle");
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CardMine(snapshot.data![index]);
                      },
                    );
                  }
                  return FavCardShimmer();
                }));
  }

  Container CardMine(FavoriteModel product) {
    return Container(
      height: 150,
      margin: const EdgeInsets.all(10),
      child: RaisedButton(
        color: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
        padding: EdgeInsets.zero,
        disabledColor: Colors.white,
        highlightColor: backgroundColor,
        elevation: 0,
        onPressed: () {
          Get.to(() => ProductProfil(
                id: product.id,
                productName: product.productName,
                image: "$serverImage/${product.imagePath}-mini.webp",
              ));
        },
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: backgroundColor.withOpacity(0.4), borderRadius: borderRadius15),
                      child: CachedNetworkImage(
                          fadeInCurve: Curves.ease,
                          imageUrl: "$serverImage/${product.imagePath}-mini.webp",
                          imageBuilder: (context, imageProvider) => Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  borderRadius: borderRadius10,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
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
                  Positioned(
                    top: 15,
                    left: 15,
                    child: GestureDetector(
                      onTap: () {
                        Get.find<Fav_Cart_Controller>().toggleFav(product.id!);
                        setState(() {});
                      },
                      child: PhysicalModel(
                        elevation: 1,
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(IconlyBold.heart, size: 20, color: Colors.red)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 10, 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text("${product.productName}",
                                    overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 17))),
                            GestureDetector(
                              onTap: () {
                                Get.find<Fav_Cart_Controller>().toggleFav(product.id!);
                                setState(() {});
                              },
                              child: const Icon(CupertinoIcons.xmark_circle, color: Colors.black, size: 24),
                            ),
                          ],
                        ),
                      ),
                      Text("${product.description}", overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(color: Colors.grey[400], fontFamily: montserratMedium, fontSize: 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(text: "${product.price}", style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 20, color: Colors.black)),
                              const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratSemiBold, fontSize: 16, color: Colors.black))
                            ]),
                          ),
                          AddCartButton(
                            id: product.id,
                          )
                        ],
                      ),
                      // Text("addCart2".tr, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(color: Colors.white, fontFamily: montserratMedium, fontSize: 16)),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
