// To parse this JSON data, do
//
//     final postCollectionService = postCollectionServiceFromJson(jsonString);

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:inforum/data/webConfig.dart';

PostCollectionService postCollectionServiceFromJson(String str) =>
    PostCollectionService.fromJson(json.decode(str));

String postCollectionServiceToJson(PostCollectionService data) =>
    json.encode(data.toJson());

Future<List<CollectionRecordset>?> getPostCollection(int? userID) async {
  Response res = await Dio().get('$apiServerAddress/getCollection/$userID');
  final PostCollectionService pcs =
      postCollectionServiceFromJson(res.toString());
  final List<CollectionRecordset>? rs = pcs.recordset!.isEmpty ? [] : pcs.recordset;
  return rs;
}

class PostCollectionService {
    PostCollectionService({
        this.recordsets,
        this.recordset,
        this.output,
        this.rowsAffected,
    });

    List<List<CollectionRecordset>>? recordsets;
    List<CollectionRecordset>? recordset;
    Output? output;
    List<int>? rowsAffected;

    factory PostCollectionService.fromJson(Map<String, dynamic> json) => PostCollectionService(
        recordsets: json["recordsets"] == null ? null : List<List<CollectionRecordset>>.from(json["recordsets"].map((x) => List<CollectionRecordset>.from(x.map((x) => CollectionRecordset.fromJson(x))))),
        recordset: json["recordset"] == null ? null : List<CollectionRecordset>.from(json["recordset"].map((x) => CollectionRecordset.fromJson(x))),
        output: json["output"] == null ? null : Output.fromJson(json["output"]),
        rowsAffected: json["rowsAffected"] == null ? null : List<int>.from(json["rowsAffected"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "recordsets": recordsets == null ? null : List<dynamic>.from(recordsets!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "recordset": recordset == null ? null : List<dynamic>.from(recordset!.map((x) => x.toJson())),
        "output": output == null ? null : output!.toJson(),
        "rowsAffected": rowsAffected == null ? null : List<dynamic>.from(rowsAffected!.map((x) => x)),
    };
}

class Output {
    Output();

    factory Output.fromJson(Map<String, dynamic>? json) => Output(
    );

    Map<String, dynamic> toJson() => {
    };
}

class CollectionRecordset {
    CollectionRecordset({
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
    int? userId;
    bool? isCollected;
    int? likeState;
    DateTime? collectTime;

    factory CollectionRecordset.fromJson(Map<String, dynamic> json) => CollectionRecordset(
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
        isEditor: json["isEditor"] == null ? null : json["isEditor"],
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
        "lastEditTime": lastEditTime == null ? null : lastEditTime!.toIso8601String(),
        "nickname": nickname == null ? null : nickname,
        "tags": tags == null ? null : tags,
        "avatarURL": avatarUrl == null ? null : avatarUrl,
        "likeCount": likeCount == null ? null : likeCount,
        "dislikeCount": dislikeCount == null ? null : dislikeCount,
        "commentCount": commentCount == null ? null : commentCount,
        "collectCount": collectCount == null ? null : collectCount,
        "editorID": editorId == null ? null : editorId,
        "isEditor": isEditor == null ? null : isEditor,
        "user_ID": userId == null ? null : userId,
        "isCollected": isCollected == null ? null : isCollected,
        "like_State": likeState == null ? null : likeState,
        "collectTime": collectTime == null ? null : collectTime!.toIso8601String(),
    };
}
