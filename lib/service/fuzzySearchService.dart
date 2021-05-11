import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/followListItem.dart';
import 'package:inforum/component/postListItem.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/postStreamService.dart';
import 'package:inforum/service/profileService.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<List<Widget>>> fuzzySearch(String query) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  Response res = await Dio().get('$apiServerAddress/fuzzySearch/?query=$query');
  final FuzzySearchService fss = fuzzySearchServiceFromJson(res.toString());
  final List<PostRecordset> pors =
      fss.posts!.recordset!.isEmpty ? [] : fss.posts!.recordset!;
  for (int i = 0; i < pors.length; i++) {
    for (int j = i + 1; j < pors.length; j++) {
      if (pors[i].postId == pors[j].postId &&
          pors[i].userId != sp.getInt('userID')) {
        pors.removeAt(i);
        j--;
      }
    }
  }
  final List<ProfileRecordset> pfrs =
      fss.users!.recordset!.isEmpty ? [] : fss.users!.recordset!;
  return convertToSearchResultWidgets(pors, pfrs);
}

List<List<Widget>> convertToSearchResultWidgets(
    List<PostRecordset> pors, List<ProfileRecordset> pfrs) {
  List<Widget> posts = [];
  List<Widget> users = [];
  pors.asMap().forEach((index, value) {
    String? t = value.tags;
    posts.add(PostListItem(
      postID: value.postId,
      editorID: value.editorId,
      titleText: value.title,
      contentText:
          value.bodyS!.length == 100 ? value.bodyS! + '......' : value.bodyS,
      likeCount: value.likeCount,
      dislikeCount: value.dislikeCount,
      likeState: value.likeState ?? 0,
      commentCount: value.commentCount,
      collectCount: value.collectCount,
      isCollect: value.isCollected ?? false,
      imgURL: value.imageUrl ?? null,
      authorName: value.nickname ?? value.editorId.toString(),
      imgAuthor: value.avatarUrl ?? null,
      isAuthor: value.isEditor == 1 ? true : false,
      time: value.lastEditTime.toString(),
      tags: t != null ? t.split(',') : null,
      index: index,
    ));
  });
  pfrs.asMap().forEach((index, value) {
    users.add(FollowListItem(
      userID: value.id!,
      avatarURL: value.avatarUrl,
      nickName: value.nickname!,
      userName: value.username!,
      bio: value.bio,
    ));
    users.add(Divider(
      thickness: 1,
    ));
  });
  List<List<Widget>> sr = [posts, users];
  return sr;
}

FuzzySearchService fuzzySearchServiceFromJson(String str) =>
    FuzzySearchService.fromJson(json.decode(str));

String fuzzySearchServiceToJson(FuzzySearchService data) =>
    json.encode(data.toJson());

class FuzzySearchService {
  FuzzySearchService({
    this.posts,
    this.users,
  });

  final Posts? posts;
  final Users? users;

  factory FuzzySearchService.fromJson(Map<String, dynamic> json) =>
      FuzzySearchService(
        posts: json["posts"] == null ? null : Posts.fromJson(json["posts"]),
        users: json["users"] == null ? null : Users.fromJson(json["users"]),
      );

  Map<String, dynamic> toJson() => {
        "posts": posts == null ? null : posts!.toJson(),
        "users": users == null ? null : users!.toJson(),
      };
}

class Posts {
  Posts({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  final List<List<PostRecordset>>? recordsets;
  final List<PostRecordset>? recordset;
  final Output? output;
  final List<int>? rowsAffected;

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        recordsets: json["recordsets"] == null
            ? null
            : List<List<PostRecordset>>.from(json["recordsets"].map((x) =>
                List<PostRecordset>.from(
                    x.map((x) => PostRecordset.fromJson(x))))),
        recordset: json["recordset"] == null
            ? null
            : List<PostRecordset>.from(
                json["recordset"].map((x) => PostRecordset.fromJson(x))),
        output: json["output"] == null ? null : Output.fromJson(json["output"]),
        rowsAffected: json["rowsAffected"] == null
            ? null
            : List<int>.from(json["rowsAffected"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "recordsets": recordsets == null
            ? null
            : List<dynamic>.from(recordsets!
                .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "recordset": recordset == null
            ? null
            : List<dynamic>.from(recordset!.map((x) => x.toJson())),
        "output": output == null ? null : output!.toJson(),
        "rowsAffected": rowsAffected == null
            ? null
            : List<dynamic>.from(rowsAffected!.map((x) => x)),
      };
}

class Output {
  Output();

  factory Output.fromJson(Map<String, dynamic> json) => Output();

  Map<String, dynamic> toJson() => {};
}

class Users {
  Users({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  final List<List<ProfileRecordset>>? recordsets;
  final List<ProfileRecordset>? recordset;
  final Output? output;
  final List<int>? rowsAffected;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        recordsets: json["recordsets"] == null
            ? null
            : List<List<ProfileRecordset>>.from(json["recordsets"].map((x) =>
                List<ProfileRecordset>.from(
                    x.map((x) => ProfileRecordset.fromJson(x))))),
        recordset: json["recordset"] == null
            ? null
            : List<ProfileRecordset>.from(
                json["recordset"].map((x) => ProfileRecordset.fromJson(x))),
        output: json["output"] == null ? null : Output.fromJson(json["output"]),
        rowsAffected: json["rowsAffected"] == null
            ? null
            : List<int>.from(json["rowsAffected"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "recordsets": recordsets == null
            ? null
            : List<dynamic>.from(recordsets!
                .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "recordset": recordset == null
            ? null
            : List<dynamic>.from(recordset!.map((x) => x.toJson())),
        "output": output == null ? null : output!.toJson(),
        "rowsAffected": rowsAffected == null
            ? null
            : List<dynamic>.from(rowsAffected!.map((x) => x)),
      };
}
