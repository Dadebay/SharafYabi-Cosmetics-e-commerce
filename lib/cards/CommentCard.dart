// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
// import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
// import 'package:sharaf_yabi_ecommerce/models/UserModels/AuthModel.dart';

// class CommentCard extends StatelessWidget {
//   final bool addReplyButton;
//   final String userName;
//   final String userDescription;

//   const CommentCard({Key? key, required this.addReplyButton,required this.userName,required this.userDescription}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: addReplyButton ? const EdgeInsets.symmetric(vertical: 10) : const EdgeInsets.only(bottom: 15),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             margin: const EdgeInsets.only(right: 5),
//             decoration: BoxDecoration(color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.3), shape: BoxShape.circle),
//             child: Text(userName.substring(0, 1).toUpperCase(), style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 22)),
//           ),
//           Flexible(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration:
//                         const BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(right: 10),
//                           child: Text(userName, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5),
//                           child: Text(userDescription, maxLines: 8, style: const TextStyle(color: Colors.black87, fontFamily: montserratRegular, fontSize: 16)),
//                         )
//                       ],
//                     ),
//                   ),
//                   if (addReplyButton)
//                     GestureDetector(
//                       onTap: () async {
//                         final String? token = await Auth().getToken();
//                         if (token == null) {
//                           showSnackBar("retry", "pleaseLogin", Colors.red);
//                         } else {
//                           Get.defaultDialog(
//                             radius: 4,
//                             title: "writeComment".tr,
//                             titleStyle: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 24),
//                             content: Column(
//                               children: [
//                                 TextFormField(
//                                   controller: controller,
//                                   textCapitalization: TextCapitalization.sentences,
//                                   cursorColor: kPrimaryColor,
//                                   maxLines: 3,
//                                   inputFormatters: [
//                                     LengthLimitingTextInputFormatter(70),
//                                   ],
//                                   style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: montserratMedium),
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       return "errorEmpty".tr;
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   decoration: InputDecoration(
//                                       label: Text("writeComment".tr),
//                                       alignLabelWithHint: true,
//                                       prefixIconConstraints: const BoxConstraints.tightForFinite(),
//                                       labelStyle: const TextStyle(color: Colors.grey, fontFamily: montserratMedium),
//                                       constraints: const BoxConstraints(),
//                                       contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                                       hintStyle: const TextStyle(color: Colors.grey, fontSize: 18, fontFamily: montserratMedium),
//                                       border: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor)),
//                                       enabledBorder: OutlineInputBorder(
//                                           borderRadius: borderRadius10,
//                                           borderSide: BorderSide(
//                                             color: Colors.grey.shade400,
//                                           )),
//                                       focusedBorder: const OutlineInputBorder(borderRadius: borderRadius10, borderSide: BorderSide(color: kPrimaryColor, width: 2))),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 SizedBox(
//                                   width: Get.size.width,
//                                   child: RaisedButton(
//                                       onPressed: () {
//                                         CommentModel().writeSubComment(id: widget.productID, comment: controller.text, commentID: commentIDMine).then((value) {
//                                           if (value == true) {
//                                             Get.back();
//                                             showSnackBar("commentAdded", "commentAddedSubtitle", kPrimaryColor);
//                                             controller.clear();
//                                           } else {
//                                             Vibration.vibrate();
//                                             showSnackBar("retry", "error404", kPrimaryColor);
//                                             controller.clear();
//                                           }
//                                         });
//                                       },
//                                       color: kPrimaryColor,
//                                       child: Text("send".tr, style: const TextStyle(color: Colors.white, fontFamily: montserratSemiBold, fontSize: 20))),
//                                 )
//                               ],
//                             ),
//                           );
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 5),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Padding(
//                               padding: EdgeInsets.only(right: 8),
//                               child: Icon(Icons.comment_outlined, color: Colors.black54, size: 18),
//                             ),
//                             Text("reply".tr, style: const TextStyle(color: Colors.black54, fontFamily: montserratSemiBold, fontSize: 14)),
//                           ],
//                         ),
//                       ),
//                     )
//                   else
//                     const SizedBox.shrink()
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
