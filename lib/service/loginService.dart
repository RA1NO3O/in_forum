// To parse this JSON data, do
//
//     final loginService = loginServiceFromJson(jsonString);

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:inforum/data/webConfig.dart';

LoginService loginServiceFromJson(String str) =>
    LoginService.fromJson(json.decode(str));

String loginServiceToJson(LoginService data) => json.encode(data.toJson());

Future<Recordset> tryLogin(String userName, String password) async {
  Response res = await Dio().get('$apiServerAddress/login'
      '?username=$userName&password=$password');
  final LoginService loginService = loginServiceFromJson(res.toString());
  final Recordset rs =
      loginService.recordset.isEmpty ? null : loginService.recordset[0];
  return rs;
}

Future<Recordset> searchUser(String userName) async {
  Response res = await Dio().get('$apiServerAddress/searchUser'
      '?username=$userName');
  final LoginService loginService = loginServiceFromJson(res.toString());
  final Recordset rs =
      loginService.recordset.isEmpty ? null : loginService.recordset[0];
  return rs;
}

class LoginService {
  LoginService({
    this.recordsets,
    this.recordset,
    this.output,
    this.rowsAffected,
  });

  List<List<Recordset>> recordsets;
  List<Recordset> recordset;
  Output output;
  List<int> rowsAffected;

  factory LoginService.fromJson(Map<String, dynamic> json) => LoginService(
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
    this.id,
    this.username,
  });

  int id;
  String username;

  factory Recordset.fromJson(Map<String, dynamic> json) => Recordset(
        id: json["id"] == null ? null : json["id"],
        username: json["username"] == null ? null : json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "username": username == null ? null : username,
      };
}
