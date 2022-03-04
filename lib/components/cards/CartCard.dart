// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
// import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
// import 'package:sharaf_yabi_ecommerce/components/constants/widgets.dart';
// import 'package:sharaf_yabi_ecommerce/screens/Others/ProductProfilPage/ProductProfil.dart';
// import 'package:vibration/vibration.dart';

// class CartCard extends StatelessWidget {
//   final int index;

//   const CartCard({Key? key,required this.index}) : super(key: key);

// // 



//   @override
//   Widget build(BuildContext context) {
    
//     return GestureDetector(
//       onTap: () {
//         pushNewScreen(
//           context,
//           screen: ProductProfil(
//             id: cartPageController.list[index]["id"],
//             productName: cartPageController.list[index]["name"],
//             image: "$serverImage/${cartPageController.list[index]["image"]}-mini.webp",
//           ),
//           withNavBar: true, // OPTIONAL VALUE. True by default.
//           pageTransitionAnimation: PageTransitionAnimation.fade,
//         );
//       },
//       child: Container(
//         height: 140,
//         margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//         decoration: const BoxDecoration(color: Colors.white, borderRadius: borderRadius20),
//         child: Row(
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.all(8.0),
//                     padding: const EdgeInsets.all(8.0),
//                     decoration: const BoxDecoration(borderRadius: borderRadius15, color: Colors.white),
//                     child: CachedNetworkImage(
//                         fadeInCurve: Curves.ease,
//                         imageUrl: "$serverImage/${cartPageController.list[index]["image"]}-mini.webp",
//                         imageBuilder: (context, imageProvider) => Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: borderRadius20,
//                                 image: DecorationImage(
//                                   image: imageProvider,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                             ),
//                         placeholder: (context, url) => Center(child: spinKit()),
//                         errorWidget: (context, url, error) => noImage()),
//                   ),
//                   if (discountValue != 0)
//                     Positioned(
//                       bottom: 15,
//                       right: 15,
//                       child: discountText("$discountValue"),
//                     )
//                   else
//                     const SizedBox.shrink()
//                 ],
//               ),
//             ),
//             Expanded(
//                 flex: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("${cartPageController.list[index]["name"]}",
//                           overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.start, style: const TextStyle(color: Colors.black, fontFamily: montserratMedium, fontSize: 16)),
//                       if (discountValue > 0)
//                         Row(
//                           children: [
//                             RichText(
//                               overflow: TextOverflow.ellipsis,
//                               text: TextSpan(children: <TextSpan>[
//                                 TextSpan(text: "${priceMine.toStringAsFixed(2)}", style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 20, color: Colors.black)),
//                                 const TextSpan(text: "  m.", style: TextStyle(fontFamily: montserratMedium, fontSize: 16, color: Colors.black))
//                               ]),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 8),
//                               child: Stack(
//                                 children: [
//                                   Positioned(left: 0, right: 5, top: 10, child: Transform.rotate(angle: pi / -14, child: Container(height: 1, color: Colors.red))),
//                                   RichText(
//                                     overflow: TextOverflow.ellipsis,
//                                     text: TextSpan(children: <TextSpan>[
//                                       TextSpan(text: "$priceOLD", style: const TextStyle(fontFamily: montserratRegular, fontSize: 18, color: Colors.grey)),
//                                       const TextSpan(text: " m.", style: TextStyle(fontFamily: montserratRegular, fontSize: 12, color: Colors.grey))
//                                     ]),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         )
//                       else
//                         Text(
//                           "${cartPageController.list[index]["price"]} m.",
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 4,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(fontFamily: montserratSemiBold, fontSize: 18, color: Colors.black),
//                         ),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               final int id = cartPageController.list[index]["id"];
//                               cartPageController.removeCard(id);
//                               favCartController.removeCart(id);
//                               _homePageController.searchAndRemove(
//                                 cartPageController.list[index]["id"],
//                               );

//                               showCustomToast(
//                                 context,
//                                 "productCountAdded".tr,
//                               );

//                               setState(() {});
//                             },
//                             child: Container(
//                                 padding: const EdgeInsets.all(4),
//                                 decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
//                                 child: cartPageController.list[index]["count"] == 1
//                                     ? const Icon(
//                                         IconlyLight.delete,
//                                         color: Colors.grey,
//                                       )
//                                     : const Icon(CupertinoIcons.minus)),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: Text(
//                               "${cartPageController.list[index]["count"]}",
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(color: Colors.black, fontFamily: montserratBold, fontSize: 18),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               final int stockCount = cartPageController.list[index]["count"];
//                               final int quantity = cartPageController.list[index]["count"] + 1;
//                               if (stockCount > quantity) {
//                                 showCustomToast(
//                                   context,
//                                   "productCountAdded".tr,
//                                 );
//                                 _homePageController.searchAndAdd(cartPageController.list[index]["id"], "$priceMine");
//                                 cartPageController.addToCard(cartPageController.list[index]["id"]);
//                                 favCartController.addCart(cartPageController.list[index]["id"], "$priceMine");
//                               } else {
//                                 Vibration.vibrate();
//                                 showCustomToast(
//                                   context,
//                                   "emptyStockCount".tr,
//                                 );
//                               }
//                             },
//                             child: Container(
//                                 padding: const EdgeInsets.all(4),
//                                 decoration: const BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
//                                 child: const Icon(CupertinoIcons.add, color: Colors.white)),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
