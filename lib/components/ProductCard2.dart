// ignore_for_file: deprecated_member_use, file_names, avoid_dynamic_calls, invariant_booleans, always_use_package_imports

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/controllers/Fav_Cart_Controller.dart';
import 'package:sharaf_yabi_ecommerce/controllers/FilterController.dart';

class ProductCard2 extends StatefulWidget {
  final int indexx;
  const ProductCard2({
    Key? key,
    required this.indexx,
  }) : super(key: key);
  @override
  _ProductCard2State createState() => _ProductCard2State();
}

class _ProductCard2State extends State<ProductCard2> {
  late FilterController _filterController;
  late Fav_Cart_Controller favCartController;
  @override
  void initState() {
    super.initState();
    favCartController = Get.put<Fav_Cart_Controller>(Fav_Cart_Controller());
    _filterController = Get.put<FilterController>(FilterController());

    if (favCartController.favList.isNotEmpty) {
      for (final element in favCartController.favList) {
        if (element["id"] == _filterController.list[widget.indexx]!["id"]) {
          _filterController.favButton.value = true;
        }
      }
    } else {
      _filterController.favButton.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        // Get.to(() => ProductProfil(
        //       id: _filterController.list[widget.indexx]!["id"],
        //       productName: _filterController.list[widget.indexx]["name"],
        //       image: "$serverImage/${_filterController.list[widget.indexx]["image"]}-mini.webp",
        //     ));
      },
      shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
      color: Colors.white,
      disabledColor: Colors.white,
      padding: EdgeInsets.zero,
      elevation: 1,
      highlightColor: backgroundColor.withOpacity(0.2),
      highlightElevation: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          imageExpanded(),
          Padding(
            padding: const EdgeInsets.only(left: 7, right: 7, bottom: 3, top: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _filterController.list[widget.indexx]["name"],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontFamily: montserratMedium, fontSize: 16),
                ),
                Text(
                  "description",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontFamily: montserratMedium, fontSize: 14, color: Colors.grey[400]),
                ),
                RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(text: _filterController.list[widget.indexx]["price"], style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 20, color: kPrimaryColor)),
                    const TextSpan(text: " TMT", style: TextStyle(fontFamily: montserratMedium, fontSize: 16, color: kPrimaryColor))
                  ]),
                ),
                SizedBox(
                  width: Get.size.width,
                  child: _filterController.list[widget.indexx]["count"] != 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (final element in favCartController.cartList) {
                                      if (element["id"] == _filterController.list[widget.indexx]["id"]) {
                                        element["count"]--;
                                        if (_filterController.list.isNotEmpty) {
                                          for (final element in _filterController.list) {
                                            if (element["id"] == _filterController.list[widget.indexx]["id"]) {
                                              element["count"]--;
                                            }
                                          }
                                        }
                                      }
                                    }
                                  });
                                },
                                child: PhysicalModel(
                                  elevation: 1,
                                  color: Colors.transparent,
                                  borderRadius: borderRadius5,
                                  child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(borderRadius: borderRadius5, color: kPrimaryColor),
                                      child: const Icon(
                                        CupertinoIcons.minus,
                                        size: 22,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              GetX<FilterController>(
                                init: FilterController(),
                                initState: (_) {},
                                builder: (_) {
                                  return Text(
                                    "${_filterController.list[widget.indexx]["count"]}",
                                    style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratSemiBold),
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    for (final element2 in _filterController.list) {
                                      if (element2["id"] == _filterController.list[widget.indexx]["id"]) {
                                        element2["count"]++;
                                      }
                                    }
                                    favCartController.addCart(_filterController.list[widget.indexx]["id"]);
                                  });
                                },
                                child: PhysicalModel(
                                  elevation: 1,
                                  borderRadius: borderRadius5,
                                  color: Colors.transparent,
                                  child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(borderRadius: borderRadius5, color: kPrimaryColor),
                                      child: const Icon(
                                        CupertinoIcons.add,
                                        size: 22,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )
                      : RaisedButton(
                          onPressed: () {
                            setState(() {
                              favCartController.addCart(_filterController.list[widget.indexx]["id"]);
                              for (final element2 in _filterController.list) {
                                if (element2["id"] == _filterController.list[widget.indexx]["id"]) {
                                  element2["count"]++;
                                }
                              }
                            });
                          },
                          elevation: 0,
                          disabledElevation: 0,
                          shape: const RoundedRectangleBorder(borderRadius: borderRadius5),
                          color: kPrimaryColor,
                          child: Text(
                            "addCart".tr,
                            style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded imageExpanded() {
    return Expanded(
      flex: 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
              fadeInCurve: Curves.ease,
              imageUrl: "$serverImage/${_filterController.list[widget.indexx]["image"]}-mini.webp",
              imageBuilder: (context, imageProvider) => Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
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
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                _filterController.favButton.value = !_filterController.favButton.value;
                favCartController.toggleFav(_filterController.list[widget.indexx]["id"]);
              },
              child: PhysicalModel(
                elevation: 2,
                color: Colors.transparent,
                shape: BoxShape.circle,
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Obx(() {
                      return Icon(_filterController.favButton.value ? IconlyBold.heart : IconlyLight.heart, color: Colors.red);
                    })),
              ),
            ),
          ),
          if (_filterController.list[widget.indexx]["discountValue"] != 0)
            Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius5),
                  child: Text("${_filterController.list[widget.indexx]["discountValue"]} %", style: const TextStyle(color: Colors.white, fontFamily: montserratRegular, fontSize: 14)),
                ))
          else
            const SizedBox.shrink()
        ],
      ),
    );
  }
}
