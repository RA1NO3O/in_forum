import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:inforum/data/webConfig.dart';

UserAccountService userAccountServiceFromJson(String str) =>
    UserAccountService.fromJson(json.decode(str));

String userAccountServiceToJson(UserAccountService data) =>
    json.encode(data.toJson());

Future<UserAccountRecordset?> getUserAccountSettings(int userID) async {
  Response res = await Dio()
      .get('$apiServerAddress/getUserAccountSettings?userID=$userID');
  final UserAccountService uas = userAccountServiceFromJson(res.toString());
  final UserAccountRecordset? uar =
      uas.recordset!.isEmpty ? null : uas.recordset![0];
  return uar;
}

class UserAccountService {
  UserAccountService({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  final List<List<UserAccountRecordset>>? recordsets;
  final List<UserAccountRecordset>? recordset;
  final Output? output;
  final List<int>? rowsAffected;

  factory UserAccountService.fromJson(Map<String, dynamic> json) =>
      UserAccountService(
        recordsets: json["recordsets"] == null
            ? null
            : List<List<UserAccountRecordset>>.from(json["recordsets"].map(
                (x) => List<UserAccountRecordset>.from(
                    x.map((x) => UserAccountRecordset.fromJson(x))))),
        recordset: json["recordset"] == null
            ? null
            : List<UserAccountRecordset>.from(
                json["recordset"].map((x) => UserAccountRecordset.fromJson(x))),
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

class UserAccountRecordset {
  UserAccountRecordset({
    this.username,
    this.email,
    this.phone,
  });

  final String? username;
  final String? email;
  final String? phone;

  factory UserAccountRecordset.fromJson(Map<String, dynamic> json) =>
      UserAccountRecordset(
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        phone: json["phone"] == null ? null : json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "phone": phone == null ? null : phone,
      };
}
