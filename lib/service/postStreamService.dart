// To parse this JSON data, do
//
//     final postStreamService = postStreamServiceFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:inforum/data/webConfig.dart';

PostStreamService postStreamServiceFromJson(String str) => PostStreamService.fromJson(json.decode(str));

String postStreamServiceToJson(PostStreamService data) => json.encode(data.toJson());

Future<List<Recordset>> getPostStream(String userID) async {
  Response res = await Dio().get('$apiServerAddress/getPosts/$userID');
  final PostStreamService pss = postStreamServiceFromJson(res.toString());
  final List<Recordset> rs = pss.recordset.isEmpty ? [] : pss.recordset;
  return rs;
}

class PostStreamService {
  PostStreamService({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  List<List<Recordset>> recordsets;
  List<Recordset> recordset;
  Output output;
  List<int> rowsAffected;

  factory PostStreamService.fromJson(Map<String, dynamic> json) => PostStreamService(
    recordsets: json["recordsets"] == null ? null : List<List<Recordset>>.from(json["recordsets"].map((x) => List<Recordset>.from(x.map((x) => Recordset.fromJson(x))))),
    recordset: json["recordset"] == null ? null : List<Recordset>.from(json["recordset"].map((x) => Recordset.fromJson(x))),
    output: json["output"] == null ? null : Output.fromJson(json["output"]),
    rowsAffected: json["rowsAffected"] == null ? null : List<int>.from(json["rowsAffected"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "recordsets": recordsets == null ? null : List<dynamic>.from(recordsets.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "recordset": recordset == null ? null : List<dynamic>.from(recordset.map((x) => x.toJson())),
    "output": output == null ? null : output.toJson(),
    "rowsAffected": rowsAffected == null ? null : List<dynamic>.from(rowsAffected.map((x) => x)),
  };
}

class Output {
  Output();

  factory Output.fromJson(Map<String, dynamic> json) => Output(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Recordset {
  Recordset({
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
    this.userId,
    this.isCollected,
    this.likeState,
    this.collectTime,
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
  int editorId;
  int userId;
  bool isCollected;
  int likeState;
  DateTime collectTime;

  factory Recordset.fromJson(Map<String, dynamic> json) => Recordset(
    postId: json["postID"] == null ? null : json["postID"],
    title: json["title"] == null ? null : json["title"],
    bodyS: json["body_S"] == null ? null : json["body_S"],
    imageUrl: json["imageURL"] == null ? null : json["imageURL"],
    lastEditTime: json["lastEditTime"] == null ? null : DateTime.parse(json["lastEditTime"]),
    nickname: json["nickname"] == null ? null : json["nickname"],
    tags: json["tags"] == null ? null : json["tags"],
    avatarUrl: json["avatarURL"] == null ? null : json["avatarURL"],
    likeCount: json["likeCount"] == null ? null : json["likeCount"],
    dislikeCount: json["dislikeCount"] == null ? null : json["dislikeCount"],
    commentCount: json["commentCount"] == null ? null : json["commentCount"],
    collectCount: json["collectCount"] == null ? null : json["collectCount"],
    editorId: json["editorID"] == null ? null : json["editorID"],
    userId: json["user_ID"] == null ? null : json["user_ID"],
    isCollected: json["isCollected"] == null ? null : json["isCollected"],
    likeState: json["like_State"] == null ? null : json["like_State"],
    collectTime: json["collectTime"] == null ? null : DateTime.parse(json["collectTime"]),
  );

  Map<String, dynamic> toJson() => {
    "postID": postId == null ? null : postId,
    "title": title == null ? null : title,
    "body_S": bodyS == null ? null : bodyS,
    "imageURL": imageUrl == null ? null : imageUrl,
    "lastEditTime": lastEditTime == null ? null : lastEditTime.toIso8601String(),
    "nickname": nickname == null ? null : nickname,
    "tags": tags == null ? null : tags,
    "avatarURL": avatarUrl == null ? null : avatarUrl,
    "likeCount": likeCount == null ? null : likeCount,
    "dislikeCount": dislikeCount == null ? null : dislikeCount,
    "commentCount": commentCount == null ? null : commentCount,
    "collectCount": collectCount == null ? null : collectCount,
    "editorID": editorId == null ? null : editorId,
    "user_ID": userId == null ? null : userId,
    "isCollected": isCollected == null ? null : isCollected,
    "like_State": likeState == null ? null : likeState,
    "collectTime": collectTime == null ? null : collectTime.toIso8601String(),
  };
}
