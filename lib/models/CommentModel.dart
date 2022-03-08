// ignore_for_file: file_names, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sharaf_yabi_ecommerce/components/constants/constants.dart';
import 'package:sharaf_yabi_ecommerce/models/UserModels/AuthModel.dart';

class CommentModel extends ChangeNotifier {
  CommentModel({
    this.count,
    this.comments,
  });

  factory CommentModel.fromJson(Map<dynamic, dynamic> json) {
    return CommentModel(
      count: json["count"],
      comments: ((json['comments'] ?? []) as List).map((json) => Comment.fromJson(json)).toList(),
    );
  }
  final int? count;
  final List<Comment>? comments;

  Future<CommentModel> getComment({required int id}) async {
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/$lang/get-comments/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      return CommentModel.fromJson(jsonDecode(response.body)["rows"]);
    } else {
      return CommentModel();
    }
  }

  Future writeComment({int? id, String? comment}) async {
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final token = await Auth().getToken();

    final response = await http.post(
        Uri.parse(
          "$serverURL/api/user/$lang/create-comment/$id",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          "comment": comment!,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future writeSubComment({int? id, String? comment, int? commentID}) async {
    String lang = Get.locale!.languageCode;
    if (lang == "tr") lang = "tm";
    final token = await Auth().getToken();

    final response = await http.post(
        Uri.parse(
          "$serverURL/api/user/$lang/create-sub-comment/$id/$commentID",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          "comment_sub": comment!,
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class Comment {
  String? fullName;
  String? createdAt;
  String? commentMine;
  int? id;
  List<SubComment>? subComment;

  Comment({this.fullName, this.subComment, this.id, this.createdAt, this.commentMine});

  Comment.fromJson(Map<String, dynamic> json) {
    commentMine = json['comment'];
    createdAt = json['created_at'];
    fullName = json['full_name'];
    id = json['id'];
    subComment = ((json['sub_comments'] ?? []) as List).map((json) => SubComment.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["sub_comments"] = subComment;
    data['comment'] = commentMine;
    data['created_at'] = createdAt;
    data['full_name'] = fullName;
    data['id'] = id;
    return data;
  }
}

class SubComment {
  String? fullName;
  String? createdAt;
  String? commentMine;

  SubComment({this.fullName, this.createdAt, this.commentMine});

  SubComment.fromJson(Map<String, dynamic> json) {
    commentMine = json['comment'];
    createdAt = json['created_at'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = commentMine;
    data['created_at'] = createdAt;
    data['full_name'] = fullName;
    return data;
  }
}
