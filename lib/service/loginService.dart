// To parse this JSON data, do
//
//     final loginService = loginServiceFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

LoginService loginServiceFromJson(String str) => LoginService.fromJson(json.decode(str));
Recordset recordSetFromJson(String str) => Recordset.fromJson(json.decode(str));
String loginServiceToJson(LoginService data) => json.encode(data.toJson());

@JsonSerializable(explicitToJson: true)
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
    recordsets: List<List<Recordset>>.from(json["recordsets"].map((x) => List<Recordset>.from(x.map((x) => Recordset.fromJson(x))))),
    recordset: List<Recordset>.from(json["recordset"].map((x) => Recordset.fromJson(x))),
    output: Output.fromJson(json["output"]),
    rowsAffected: List<int>.from(json["rowsAffected"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "recordsets": List<dynamic>.from(recordsets.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
    "recordset": List<dynamic>.from(recordset.map((x) => x.toJson())),
    "output": output.toJson(),
    "rowsAffected": List<dynamic>.from(rowsAffected.map((x) => x)),
  };
}
@JsonSerializable(explicitToJson: true)
class Output {
  Output();

  factory Output.fromJson(Map<String, dynamic> json) => Output(
  );

  Map<String, dynamic> toJson() => {
  };
}
@JsonSerializable(explicitToJson: true)
class Recordset {
  Recordset({
    this.id,
    this.username,
  });

  int id;
  String username;

  factory Recordset.fromJson(Map<String, dynamic> json) => Recordset(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}
