// To parse this JSON data, do
//
//     final profileService = profileServiceFromJson(jsonString);

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:inforum/data/webConfig.dart';

ProfileService profileServiceFromJson(String str) =>
    ProfileService.fromJson(json.decode(str));

String profileServiceToJson(ProfileService data) => json.encode(data.toJson());

Future<ProfileRecordset?> getProfile(int? id) async {
  Response res = await Dio().get('$apiServerAddress/getProfile/$id');
  final ProfileService ps = profileServiceFromJson(res.toString());
  final ProfileRecordset? rs = ps.recordset!.isEmpty ? null : ps.recordset![0];
  return rs;
}

class ProfileService {
  ProfileService({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  List<List<ProfileRecordset>>? recordsets;
  List<ProfileRecordset>? recordset;
  Output? output;
  List<int>? rowsAffected;

  factory ProfileService.fromJson(Map<String, dynamic> json) => ProfileService(
    recordsets: json["recordsets"] == null ? null : List<List<ProfileRecordset>>.from(json["recordsets"].map((x) => List<ProfileRecordset>.from(x.map((x) => ProfileRecordset.fromJson(x))))),
    recordset: json["recordset"] == null ? null : List<ProfileRecordset>.from(json["recordset"].map((x) => ProfileRecordset.fromJson(x))),
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

class ProfileRecordset {
  ProfileRecordset({
    this.id,
    this.nickname,
    this.username,
    this.birthday,
    this.bio,
    this.location,
    this.avatarUrl,
    this.bannerUrl,
    this.followerCount,
    this.followingCount,
    this.joinDate,
  });

  int? id;
  String? nickname;
  String? username;
  DateTime? birthday;
  String? bio;
  String? location;
  String? avatarUrl;
  String? bannerUrl;
  int? followerCount;
  int? followingCount;
  DateTime? joinDate;

  factory ProfileRecordset.fromJson(Map<String, dynamic> json) => ProfileRecordset(
    id: json["id"] == null ? null : json["id"],
    nickname: json["nickname"] == null ? null : json["nickname"],
    username: json["username"] == null ? null : json["username"],
    birthday: json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
    bio: json["bio"] == null ? null : json["bio"],
    location: json["location"] == null ? null : json["location"],
    avatarUrl: json["avatarURL"] == null ? null : json["avatarURL"],
    bannerUrl: json["bannerURL"] == null ? null : json["bannerURL"],
    followerCount: json["follower_count"] == null ? null : json["follower_count"],
    followingCount: json["following_count"] == null ? null : json["following_count"],
    joinDate: json["joinDate"] == null ? null : DateTime.parse(json["joinDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "nickname": nickname == null ? null : nickname,
    "username": username == null ? null : username,
    "birthday": birthday == null ? null : birthday!.toIso8601String(),
    "bio": bio == null ? null : bio,
    "location": location == null ? null : location,
    "avatarURL": avatarUrl == null ? null : avatarUrl,
    "bannerURL": bannerUrl == null ? null : bannerUrl,
    "follower_count": followerCount == null ? null : followerCount,
    "following_count": followingCount == null ? null : followingCount,
    "joinDate": joinDate == null ? null : joinDate!.toIso8601String(),
  };
}
