// To parse this JSON data, do
//
//     final postStreamService = postStreamServiceFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:inforum/component/GalleryListItem.dart';
import 'package:inforum/component/postListItem.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

PostStreamService postStreamServiceFromJson(String str) =>
    PostStreamService.fromJson(json.decode(str));

String postStreamServiceToJson(PostStreamService data) =>
    json.encode(data.toJson());

Future<List<PostListItem>> getPostStream(int? userID) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  Response res = await Dio().get('$apiServerAddress/getPosts/$userID');
  final PostStreamService pss = postStreamServiceFromJson(res.toString());
  final List<PostRecordset> rs = pss.recordset!.isEmpty ? [] : pss.recordset!;
  for (int i = 0; i < rs.length; i++) {
    for (int j = i + 1; j < rs.length; j++) {
      if (rs[i].postId == rs[j].postId && rs[i].userId != sp.getInt('userID')) {
        rs.removeAt(i);
        j--;
      }
    }
  }
  return convertToPostWidgets(rs);
}

Future<List<PostListItem>> getPostsByID(int? userID, int? currentUserID) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  Response res = await Dio().get(
      '$apiServerAddress/getPostsByUser/$userID?currentUserID=$currentUserID');
  final PostStreamService pss = postStreamServiceFromJson(res.toString());
  final List<PostRecordset> rs = pss.recordset!.isEmpty ? [] : pss.recordset!;
  for (int i = 0; i < rs.length; i++) {
    for (int j = i + 1; j < rs.length; j++) {
      if (rs[i].postId == rs[j].postId) {
        if (rs[j].userId != sp.getInt('userID')) {
          rs.removeAt(j);
        } else {
          rs.removeAt(i);
        }
        j--;
      }
    }
  }
  return convertToPostWidgets(rs);
}

Future<List<GalleryListItem>> getGalleryByUser(
    int? userID, int? currentUserID) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  Response res = await Dio().get(
      '$apiServerAddress/getGalleryByUser/$userID?currentUserID=$currentUserID');
  final PostStreamService pss = postStreamServiceFromJson(res.toString());
  final List<PostRecordset> rs = pss.recordset!.isEmpty ? [] : pss.recordset!;
  for (int i = 0; i < rs.length; i++) {
    for (int j = i + 1; j < rs.length; j++) {
      if (rs[i].postId == rs[j].postId) {
        if (rs[j].userId != sp.getInt('userID')) {
          rs.removeAt(j);
        } else {
          rs.removeAt(i);
        }
        j--;
      }
    }
  }
  return convertToGalleryWidgets(rs);
}

Future<List<PostListItem>> getLikedPostsByUser(
    int? userID, int? currentUserID) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  Response res = await Dio().get(
      '$apiServerAddress/getLikedPostsByUser/$userID?currentUserID=$currentUserID');
  final PostStreamService pss = postStreamServiceFromJson(res.toString());
  final List<PostRecordset> rs = pss.recordset!.isEmpty ? [] : pss.recordset!;
  for (int i = 0; i < rs.length; i++) {
    for (int j = i + 1; j < rs.length; j++) {
      if (rs[i].postId == rs[j].postId) {
        if (rs[j].userId != sp.getInt('userID')) {
          rs.removeAt(j);
        } else {
          rs.removeAt(i);
        }
        j--;
      }
    }
  }
  return convertToPostWidgets(rs);
}

Future<List<PostListItem>> convertToPostWidgets(List<PostRecordset> rs) async {
  List<PostListItem> psis = [];
  rs.asMap().forEach((index, value) {
    String? t = value.tags;
    psis.add(PostListItem(
      postID: value.postId,
      editorID: value.editorId,
      titleText: value.title,
      contentText: value.bodyS,
      likeCount: value.likeCount,
      dislikeCount: value.dislikeCount,
      likeState: value.likeState ?? 0,
      commentCount: value.commentCount,
      collectCount: value.collectCount,
      isCollect: value.isCollected ?? false,
      imgURL: value.imageUrl ?? null,
      authorName: value.nickname??value.editorId.toString(),
      imgAuthor: value.avatarUrl ?? null,
      isAuthor: value.isEditor == 1 ? true : false,
      time: value.lastEditTime.toString(),
      tags: t != null ? t.split(',') : null,
      index: index,
    ));
  });
  return psis;
}

Future<List<GalleryListItem>> convertToGalleryWidgets(
    List<PostRecordset> rs) async {
  List<GalleryListItem> gl = [];
  rs.asMap().forEach((index, value) {
    String? t = value.tags;
    gl.add(GalleryListItem(
      postID: value.postId,
      titleText: value.title,
      contentText: value.bodyS,
      likeCount: value.likeCount,
      dislikeCount: value.dislikeCount,
      likeState: value.likeState ?? 0,
      commentCount: value.commentCount,
      collectCount: value.collectCount,
      isCollect: value.isCollected ?? false,
      imgURL: value.imageUrl ?? null,
      authorName: value.nickname,
      imgAuthor: value.avatarUrl ?? null,
      isAuthor: value.isEditor == 1 ? true : false,
      time: value.lastEditTime.toString(),
      tags: t != null ? t.split(',') : null,
      index: index,
    ));
  });
  return gl;
}

class PostStreamService {
  PostStreamService({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  List<List<PostRecordset>>? recordsets;
  List<PostRecordset>? recordset;
  Output? output;
  List<int>? rowsAffected;

  factory PostStreamService.fromJson(Map<String, dynamic> json) =>
      PostStreamService(
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

  factory Output.fromJson(Map<String, dynamic>? json) => Output();

  Map<String, dynamic> toJson() => {};
}

class PostRecordset {
  PostRecordset({
    this.postId,
    this.title,
    this.bodyS,
    this.imageUrl,
    this.lastEditTime,
    this.nickname,
    this.tags,
    this.avatarUrl,
    this.likeCount,
    this.dislikeCount,
    this.commentCount,
    this.collectCount,
    this.editorId,
    this.isEditor,
    this.userId,
    this.isCollected,
    this.likeState,
    this.collectTime,
  });

  int? postId;
  String? title;
  String? bodyS;
  String? imageUrl;
  DateTime? lastEditTime;
  String? nickname;
  String? tags;
  String? avatarUrl;
  int? likeCount;
  int? dislikeCount;
  int? commentCount;
  int? collectCount;
  int? editorId;
  int? isEditor;
  dynamic userId;
  dynamic isCollected;
  dynamic likeState;
  dynamic collectTime;

  factory PostRecordset.fromJson(Map<String, dynamic> json) => PostRecordset(
        postId: json["postID"] == null ? null : json["postID"],
        title: json["title"] == null ? null : json["title"],
        bodyS: json["body_S"] == null ? null : json["body_S"],
        imageUrl: json["imageURL"] == null ? null : json["imageURL"],
        lastEditTime: json["lastEditTime"] == null
            ? null
            : DateTime.parse(json["lastEditTime"]),
        nickname: json["nickname"] == null ? null : json["nickname"],
        tags: json["tags"] == null ? null : json["tags"],
        avatarUrl: json["avatarURL"] == null ? null : json["avatarURL"],
        likeCount: json["likeCount"] == null ? null : json["likeCount"],
        dislikeCount:
            json["dislikeCount"] == null ? null : json["dislikeCount"],
        commentCount:
            json["commentCount"] == null ? null : json["commentCount"],
        collectCount:
            json["collectCount"] == null ? null : json["collectCount"],
        editorId: json["editorID"] == null ? null : json["editorID"],
        isEditor: json["isEditor"] == null ? null : json["isEditor"],
        userId: json["user_ID"],
        isCollected: json["isCollected"],
        likeState: json["like_State"],
        collectTime: json["collectTime"],
      );

  Map<String, dynamic> toJson() => {
        "postID": postId == null ? null : postId,
        "title": title == null ? null : title,
        "body_S": bodyS == null ? null : bodyS,
        "imageURL": imageUrl == null ? null : imageUrl,
        "lastEditTime":
            lastEditTime == null ? null : lastEditTime!.toIso8601String(),
        "nickname": nickname == null ? null : nickname,
        "tags": tags == null ? null : tags,
        "avatarURL": avatarUrl == null ? null : avatarUrl,
        "likeCount": likeCount == null ? null : likeCount,
        "dislikeCount": dislikeCount == null ? null : dislikeCount,
        "commentCount": commentCount == null ? null : commentCount,
        "collectCount": collectCount == null ? null : collectCount,
        "editorID": editorId == null ? null : editorId,
        "isEditor": isEditor == null ? null : isEditor,
        "user_ID": userId,
        "isCollected": isCollected,
        "like_State": likeState,
        "collectTime": collectTime,
      };
}
