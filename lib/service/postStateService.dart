// To parse this JSON data, do
//
//     final postStateService = postStateServiceFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:inforum/data/webConfig.dart';

PostStateService postStateServiceFromJson(String str) =>
    PostStateService.fromJson(json.decode(str));

String postStateServiceToJson(PostStateService data) =>
    json.encode(data.toJson());

Future<PostStateRecordset> getPostState(String userID, int postID) async {
  Response res = await Dio()
      .get('$apiServerAddress/getPostState?userID=$userID&postID=$postID');
  final PostStateService pss = postStateServiceFromJson(res.toString());
  final PostStateRecordset rs = pss.recordset.isEmpty ? null : pss.recordset[0];
  return rs;
}

class PostStateService {
  PostStateService({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  List<List<PostStateRecordset>> recordsets;
  List<PostStateRecordset> recordset;
  Output output;
  List<int> rowsAffected;

  factory PostStateService.fromJson(Map<String, dynamic> json) =>
      PostStateService(
        recordsets: json["recordsets"] == null
            ? null
            : List<List<PostStateRecordset>>.from(json["recordsets"].map((x) =>
                List<PostStateRecordset>.from(x.map((x) => PostStateRecordset.fromJson(x))))),
        recordset: json["recordset"] == null
            ? null
            : List<PostStateRecordset>.from(
                json["recordset"].map((x) => PostStateRecordset.fromJson(x))),
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

class PostStateRecordset {
  PostStateRecordset({
    this.postId,
    this.userId,
    this.isCollected,
    this.likeState,
    this.collectTime,
  });

  int postId;
  int userId;
  bool isCollected;
  int likeState;
  DateTime collectTime;

  factory PostStateRecordset.fromJson(Map<String, dynamic> json) => PostStateRecordset(
        postId: json["post_ID"] == null ? null : json["post_ID"],
        userId: json["user_ID"] == null ? null : json["user_ID"],
        isCollected: json["isCollected"] == null ? null : json["isCollected"],
        likeState: json["like_State"] == null ? null : json["like_State"],
        collectTime: json["collectTime"] == null
            ? null
            : DateTime.parse(json["collectTime"]),
      );

  Map<String, dynamic> toJson() => {
        "post_ID": postId == null ? null : postId,
        "user_ID": userId == null ? null : userId,
        "isCollected": isCollected == null ? null : isCollected,
        "like_State": likeState == null ? null : likeState,
        "collectTime":
            collectTime == null ? null : collectTime.toIso8601String(),
      };
}
