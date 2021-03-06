// To parse this JSON data, do
//
//     final postStreamService = postStreamServiceFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:inforum/component/postListItem.dart';
import 'package:inforum/data/webConfig.dart';

PostStreamService postStreamServiceFromJson(String str) =>
    PostStreamService.fromJson(json.decode(str));

String postStreamServiceToJson(PostStreamService data) =>
    json.encode(data.toJson());

Future<List<PostListItem>> getPostStream(int userID) async {
  Response res = await Dio().get('$apiServerAddress/getPosts/$userID');
  final PostStreamService pss = postStreamServiceFromJson(res.toString());
  final List<PostRecordset> rs = pss.recordset.isEmpty ? [] : pss.recordset;
  for (int i = 0; i < rs.length; i++) {
    for (int j = i + 1; j < rs.length; j++) {
      if (rs[i].postId == rs[j].postId) {
        rs.removeAt(j);
        j--;
      }
    }
  }
  return convertListToWidgets(rs);
}

Future<List<PostListItem>> getPostsByID(int userID,int currentUserID) async {
  Response res = await Dio().get('$apiServerAddress/getPostsByUser/$userID?currentUserID=$currentUserID');
  final PostStreamService pss = postStreamServiceFromJson(res.toString());
  final List<PostRecordset> rs = pss.recordset.isEmpty ? [] : pss.recordset;
  for (int i = 0; i < rs.length; i++) {
    for (int j = i + 1; j < rs.length; j++) {
      if (rs[i].postId == rs[j].postId) {
        rs.removeAt(j);
        j--;
      }
    }
  }
  return convertListToWidgets(rs);
}

Future<List<PostListItem>> convertListToWidgets(List<PostRecordset> rs) async {
  List<PostListItem> psis = [];
  rs.asMap().forEach((index, value) {
    String t = value.tags;
    psis.add(PostListItem(
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
  return psis;
}

class PostStreamService {
  PostStreamService({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  List<List<PostRecordset>> recordsets;
  List<PostRecordset> recordset;
  Output output;
  List<int> rowsAffected;

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
            : List<dynamic>.from(recordsets
                .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "recordset": recordset == null
            ? null
            : List<dynamic>.from(recordset.map((x) => x.toJson())),
        "output": output == null ? null : output.toJson(),
        "rowsAffected": rowsAffected == null
            ? null
            : List<dynamic>.from(rowsAffected.map((x) => x)),
      };
}

class Output {
  Output();

  factory Output.fromJson(Map<String, dynamic> json) => Output();

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
    this.isEditor,
    this.isCollected,
    this.likeState,
  });

  int postId;
  String title;
  String bodyS;
  String imageUrl;
  DateTime lastEditTime;
  String nickname;
  String tags;
  String avatarUrl;
  int likeCount;
  int dislikeCount;
  int commentCount;
  int collectCount;
  int isEditor;
  bool isCollected;
  int likeState;

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
        isEditor: json["isEditor"] == null ? null : json["isEditor"],
        isCollected: json["isCollected"] == null ? null : json["isCollected"],
        likeState: json["like_State"] == null ? null : json["like_State"],
      );

  Map<String, dynamic> toJson() => {
        "postID": postId == null ? null : postId,
        "title": title == null ? null : title,
        "body_S": bodyS == null ? null : bodyS,
        "imageURL": imageUrl == null ? null : imageUrl,
        "lastEditTime":
            lastEditTime == null ? null : lastEditTime.toIso8601String(),
        "nickname": nickname == null ? null : nickname,
        "tags": tags == null ? null : tags,
        "avatarURL": avatarUrl == null ? null : avatarUrl,
        "likeCount": likeCount == null ? null : likeCount,
        "dislikeCount": dislikeCount == null ? null : dislikeCount,
        "commentCount": commentCount == null ? null : commentCount,
        "collectCount": collectCount == null ? null : collectCount,
        "isEditor": isEditor == null ? null : isEditor,
        "isCollected": isCollected == null ? null : isCollected,
        "like_State": likeState == null ? null : likeState,
      };
}
