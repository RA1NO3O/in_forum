// To parse this JSON data, do
//
//     final profileService = profileServiceFromJson(jsonString);

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:inforum/data/webConfig.dart';

ProfileService profileServiceFromJson(String str) =>
    ProfileService.fromJson(json.decode(str));

String profileServiceToJson(ProfileService data) => json.encode(data.toJson());

Future<Recordset> getProfile(String id) async {
  Response res = await Dio().get('$apiServerAddress/getProfile/$id');
  final ProfileService ps = profileServiceFromJson(res.toString());
  final Recordset rs = ps.recordset.isEmpty ? null : ps.recordset[0];
  return rs;
}

class ProfileService {
  ProfileService({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  List<List<Recordset>> recordsets;
  List<Recordset> recordset;
  Output output;
  List<int> rowsAffected;

  factory ProfileService.fromJson(Map<String, dynamic> json) => ProfileService(
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
    this.nickname,
    this.username,
    this.birthday,
    this.bio,
    this.location,
    this.avatarUrl,
    this.bannerUrl,
    this.followerCount,
    this.followingCount,
  });

  String nickname;
  String username;
  DateTime birthday;
  String bio;
  String location;
  String avatarUrl;
  String bannerUrl;
  int followerCount;
  int followingCount;

  factory Recordset.fromJson(Map<String, dynamic> json) => Recordset(
        nickname: json["nickname"] == null ? null : json["nickname"],
        username: json["username"] == null ? null : json["username"],
        birthday:
            json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
        bio: json["bio"] == null ? null : json["bio"],
        location: json["location"] == null ? null : json["location"],
        avatarUrl: json["avatarURL"] == null ? null : json["avatarURL"],
        bannerUrl: json["bannerURL"] == null ? null : json["bannerURL"],
        followerCount:
            json["follower_count"] == null ? null : json["follower_count"],
        followingCount:
            json["following_count"] == null ? null : json["following_count"],
      );

  Map<String, dynamic> toJson() => {
        "nickname": nickname == null ? null : nickname,
        "username": username == null ? null : username,
        "birthday": birthday == null ? null : birthday.toIso8601String(),
        "bio": bio == null ? null : bio,
        "location": location == null ? null : location,
        "avatarURL": avatarUrl == null ? null : avatarUrl,
        "bannerURL": bannerUrl == null ? null : bannerUrl,
        "follower_count": followerCount == null ? null : followerCount,
        "following_count": followingCount == null ? null : followingCount,
      };
}
