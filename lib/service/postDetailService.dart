// To parse this JSON data, do
//
//     final postDetailService = postDetailServiceFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:inforum/data/webConfig.dart';

PostDetailService postDetailServiceFromJson(String str) =>
    PostDetailService.fromJson(json.decode(str));

String postDetailServiceToJson(PostDetailService data) =>
    json.encode(data.toJson());

Future<PostDetailRecordset> getPostDetail(int postID) async {
  Response res = await Dio().get('$apiServerAddress/getPostDetail/$postID');
  final PostDetailService pds = postDetailServiceFromJson(res.toString());
  final PostDetailRecordset rs = pds.recordset.isEmpty ? null : pds.recordset[0];
  return rs;
}

class PostDetailService {
  PostDetailService({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  List<List<PostDetailRecordset>> recordsets;
  List<PostDetailRecordset> recordset;
  Output output;
  List<int> rowsAffected;

  factory PostDetailService.fromJson(Map<String, dynamic> json) =>
      PostDetailService(
        recordsets: json["recordsets"] == null
            ? null
            : List<List<PostDetailRecordset>>.from(json["recordsets"].map((x) =>
                List<PostDetailRecordset>.from(x.map((x) => PostDetailRecordset.fromJson(x))))),
        recordset: json["recordset"] == null
            ? null
            : List<PostDetailRecordset>.from(
                json["recordset"].map((x) => PostDetailRecordset.fromJson(x))),
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

class PostDetailRecordset {
  PostDetailRecordset({
    this.avatarUrl,
    this.nickname,
    this.username,
    this.title,
    this.body,
    this.imageUrl,
    this.tags,
    this.lastEditTime,
    this.postId,
    this.likeCount,
    this.dislikeCount,
    this.commentCount,
    this.collectCount,
    this.editorId,
  });

  String avatarUrl;
  String nickname;
  String username;
  String title;
  String body;
  String imageUrl;
  String tags;
  DateTime lastEditTime;
  int postId;
  int likeCount;
  int dislikeCount;
  int commentCount;
  int collectCount;
  int editorId;

  factory PostDetailRecordset.fromJson(Map<String, dynamic> json) => PostDetailRecordset(
    avatarUrl: json["avatarURL"] == null ? null : json["avatarURL"],
    nickname: json["nickname"] == null ? null : json["nickname"],
    username: json["username"] == null ? null : json["username"],
    title: json["title"] == null ? null : json["title"],
    body: json["body"] == null ? null : json["body"],
    imageUrl: json["imageURL"] == null ? null : json["imageURL"],
    tags: json["tags"] == null ? null : json["tags"],
    lastEditTime: json["lastEditTime"] == null ? null : DateTime.parse(json["lastEditTime"]),
    postId: json["postID"] == null ? null : json["postID"],
    likeCount: json["likeCount"] == null ? null : json["likeCount"],
    dislikeCount: json["dislikeCount"] == null ? null : json["dislikeCount"],
    commentCount: json["commentCount"] == null ? null : json["commentCount"],
    collectCount: json["collectCount"] == null ? null : json["collectCount"],
    editorId: json["editorID"] == null ? null : json["editorID"],
  );

  Map<String, dynamic> toJson() => {
    "avatarURL": avatarUrl == null ? null : avatarUrl,
    "nickname": nickname == null ? null : nickname,
    "username": username == null ? null : username,
    "title": title == null ? null : title,
    "body": body == null ? null : body,
    "imageURL": imageUrl == null ? null : imageUrl,
    "tags": tags == null ? null : tags,
    "lastEditTime": lastEditTime == null ? null : lastEditTime.toIso8601String(),
    "postID": postId == null ? null : postId,
    "likeCount": likeCount == null ? null : likeCount,
    "dislikeCount": dislikeCount == null ? null : dislikeCount,
    "commentCount": commentCount == null ? null : commentCount,
    "collectCount": collectCount == null ? null : collectCount,
    "editorID": editorId == null ? null : editorId,
  };
}
