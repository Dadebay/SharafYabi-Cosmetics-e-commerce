// ignore_for_file: file_names, must_be_immutable, avoid_positional_boolean_parameters, always_use_package_imports, deprecated_member_use, duplicate_ignore

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sharaf_yabi_ecommerce/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/constants/widgets.dart';
import 'package:sharaf_yabi_ecommerce/models/CommentModel.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/AuthModel.dart';
import 'package:sharaf_yabi_ecommerce/widgets/appBar.dart';
import 'package:vibration/vibration.dart';

import '../controllers/SettingsController.dart';

class CommentsPage extends StatefulWidget {
  final int productID;

  const CommentsPage({Key? key, required this.productID}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController controller = TextEditingController();

  SettingsController settingsController = Get.put(SettingsController());

  @override
  void initState() {
    super.initState();
    settingsController.commentID.value = 0;
    settingsController.commentBool.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        icon: Icons.comment_outlined,
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
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                        onPressed: () {
                          CommentModel()
                              .writeComment(
                            id: widget.productID,
                            comment: controller.text,
                          )
                              .then((value) {
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
        backArrow: true,
        iconRemove: true,
        name: "comments",
        addName: true,
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: FutureBuilder<CommentModel>(
              future: CommentModel().getComment(id: widget.productID),
              builder: (context, snapshot) {
                if (snapshot.hasData == true) {
                  return ListView.builder(
                    itemCount: snapshot.data!.comments!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Wrap(
                        direction: Axis.vertical,
                        children: [
                          commentCard("${snapshot.data!.comments![index].fullName}", "${snapshot.data!.comments![index].commentMine}", true, snapshot.data!.comments![index].id),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(snapshot.data!.comments![index].subComment!.length, (indexx) {
                                return commentCard("${snapshot.data!.comments![index].subComment![indexx].fullName}", "${snapshot.data!.comments![index].subComment![indexx].commentMine}", false,
                                    snapshot.data!.comments![index].id);
                              }),
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: spinKit(),
                  );
                }
                return Center(
                  child: spinKit(),
                );
              })),
    );
  }

  Widget commentCard(String userName, String userDescription, bool addReply, int? commentIDMine) {
    return Padding(
      padding: addReply ? const EdgeInsets.symmetric(vertical: 10) : const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.3), shape: BoxShape.circle),
            child: Text(userName.substring(0, 1).toUpperCase(), style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 22)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration:
                      const BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(userName, style: const TextStyle(color: Colors.black, fontFamily: montserratSemiBold, fontSize: 18)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(userDescription, maxLines: 8, style: const TextStyle(color: Colors.black87, fontFamily: montserratRegular, fontSize: 16)),
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
                                      CommentModel().writeSubComment(id: widget.productID, comment: controller.text, commentID: commentIDMine).then((value) {
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
        ],
      ),
    );
  }
}
