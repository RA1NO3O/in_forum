// To parse this JSON data, do
//
//     final postCommentService = postCommentServiceFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:inforum/data/webConfig.dart';

PostCommentService postCommentServiceFromJson(String str) =>
    PostCommentService.fromJson(json.decode(str));

String postCommentServiceToJson(PostCommentService data) =>
    json.encode(data.toJson());

Future<List<Recordset>> getPostComment(int postID) async {
  Response res = await Dio().get('$apiServerAddress/getComment/$postID');
  final PostCommentService pcs = postCommentServiceFromJson(res.toString());
  final List<Recordset> rs = pcs.recordset.isEmpty ? [] : pcs.recordset;
  return rs;
}

class PostCommentService {
  PostCommentService({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  List<List<Recordset>> recordsets;
  List<Recordset> recordset;
  Output output;
  List<int> rowsAffected;

  factory PostCommentService.fromJson(Map<String, dynamic> json) =>
      PostCommentService(
        recordsets: json["recordsets"] == null
            ? null
            : List<List<Recordset>>.from(json["recordsets"].map((x) =>
                List<Recordset>.from(x.map((x) => Recordset.fromJson(x))))),
        recordset: json["recordset"] == null
            ? null
            : List<Recordset>.from(
                json["recordset"].map((x) => Recordset.fromJson(x))),
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

class Recordset {
  Recordset({
    this.postId,
    this.body,
    this.imageUrl,
    this.lastEditTime,
    this.username,
    this.avatarUrl,
    this.nickname,
  });

  int postId;
  String body;
  dynamic imageUrl;
  DateTime lastEditTime;
  String username;
  String avatarUrl;
  String nickname;

  factory Recordset.fromJson(Map<String, dynamic> json) => Recordset(
        postId: json["postID"] == null ? null : json["postID"],
        body: json["body"] == null ? null : json["body"],
        imageUrl: json["imageURL"],
        lastEditTime: json["lastEditTime"] == null
            ? null
            : DateTime.parse(json["lastEditTime"]),
        username: json["username"] == null ? null : json["username"],
        avatarUrl: json["avatarURL"] == null ? null : json["avatarURL"],
        nickname: json["nickname"] == null ? null : json["nickname"],
      );

  Map<String, dynamic> toJson() => {
        "postID": postId == null ? null : postId,
        "body": body == null ? null : body,
        "imageURL": imageUrl,
        "lastEditTime":
            lastEditTime == null ? null : lastEditTime.toIso8601String(),
        "username": username == null ? null : username,
        "avatarURL": avatarUrl == null ? null : avatarUrl,
        "nickname": nickname == null ? null : nickname,
      };
}
