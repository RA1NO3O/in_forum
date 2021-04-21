import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/home.dart';
import 'package:inforum/main.dart';
import 'package:inforum/service/loginService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPage createState() => _RegPage();
}

class _RegPage extends State<RegPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = false, processing = false;
  final userNameController = new TextEditingController(),
      phoneController = new TextEditingController(),
      emailController = new TextEditingController(),
      pwdController = new TextEditingController();
  String? nickname, bio, gender, location;
  DateTime? birthday;

  Future<void> btnRegClick() async {
    bool regPassed = false;
    String errorCode = '0';
    if (_formKey.currentState!.validate()) {
      LoginRecordset? rs = await searchUser(userNameController.text);
      if (rs == null) {
        rs = await searchUser(emailController.text);
        if (rs == null) {
          rs = await searchUser(phoneController.text);
          if (rs == null && errorCode == '0') {
            regPassed = true;
          } else {
            errorCode += '4';
          }
        } else {
          errorCode += '3';
        }
      } else {
        errorCode += '2';
      }
    }
    if (errorCode != '0') {
      var msg = '注册失败,';
      if (errorCode.contains('3')) {
        msg += '\n该邮箱地址可能已被注册,请更换一个邮箱地址.';
      }
      if (errorCode.contains('4')) {
        msg += '\n该电话号码可能已被注册,请更换一个电话号码.';
      }
      if (errorCode.contains('2')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(Icons.warning_rounded),
              ),
              Text('注册失败,该用户名可能已经存在.\n您想要使用这个账号登录吗?'),
            ],
          ),
          backgroundColor: Colors.yellow,
          action: SnackBarAction(
            label: '登录',
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(
                  state: 1,
                  title: 'Inforum',
                  userName: userNameController.text,
                ),
              ),
            ),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar(msg));
      }
    }

    if (regPassed) {
      //写入登录状态
      Response res = await Dio().post(
        '$apiServerAddress/createAccount/',
        options: new Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          "username": userNameController.text,
          "password": pwdController.text,
          "email": emailController.text.isEmpty ? 'null' : emailController.text,
          "phone": phoneController.text.isEmpty ? 'null' : phoneController.text,
          "nickname": userNameController.text,
        },
      );
      if (res.data == 'success.') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        LoginRecordset recordset = (await searchUser(userNameController.text))!;
        await prefs.setInt('userID', recordset.id!);
        await prefs.setString('nickName', userNameController.text);
        await prefs.setString('userName', userNameController.text);
        await prefs.setBool('isLogin', true);
        await prefs.setBool('isJustLogin', true);
        LoginRecordset rs =
            (await searchUser(userNameController.text)) ?? new LoginRecordset();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(
                      userID: rs.id,
                      userName: userNameController.text,
                      nickName: nickname ?? userNameController.text,
                    )),
            result: "null");
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 350,
        height: 600,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              new Container(
                margin: EdgeInsets.only(top: 40, bottom: 30),
                child: Text(
                  '注册',
                  style:
                      new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              //用户名字段
              new Container(
                margin:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: TextFormField(
                  maxLength: 10,
                  validator: (value) => value!.isEmpty ? '此字段为必填项.' : null,
                  keyboardType: TextInputType.name,
                  autofillHints: [AutofillHints.newUsername],
                  controller: userNameController,
                  decoration: InputDecoration(
                      labelText: '用户名',
                      prefixIcon: Icon(Icons.person),
                      border: inputBorder),
                ),
              ),
              //电子邮箱字段
              new Container(
                margin:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: TextFormField(
                  maxLength: 30,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                  controller: emailController,
                  decoration: InputDecoration(
                      labelText: '电子邮箱地址(可选)',
                      hintText: 'someone@example.com',
                      prefixIcon: Icon(Icons.mail_rounded),
                      border: inputBorder),
                ),
              ),
              new Container(
                margin:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: TextFormField(
                  maxLength: 14,
                  keyboardType: TextInputType.phone,
                  autofillHints: [AutofillHints.telephoneNumber],
                  controller: phoneController,
                  decoration: InputDecoration(
                      labelText: '电话号码(可选)',
                      prefixIcon: Icon(Icons.phone),
                      border: inputBorder),
                ),
              ),
              //密码字段
              new Container(
                margin:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: TextFormField(
                  maxLength: 20,
                  validator: (value) => value!.isEmpty ? '此字段为必填项.' : null,
                  controller: pwdController,
                  obscureText: !passwordVisible,
                  textInputAction: TextInputAction.done,
                  autofillHints: [AutofillHints.newPassword],
                  decoration: InputDecoration(
                      labelText: '密码',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: passwordVisible ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () => setState(() {
                          passwordVisible = !passwordVisible;
                        }),
                      ),
                      border: inputBorder),
                ),
              ),
              new Container(
                width: 80,
                height: 40,
                margin: EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  )),
                  child: Text(
                    '注册',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: btnRegClick,
                ),
              )
            ],
          ),
        ));
  }
}
