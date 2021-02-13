import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/home.dart';
import 'package:inforum/service/loginService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPage createState() => _RegPage();
}

class _RegPage extends State<RegPage> {
  bool passwordVisible = false, processing = false;
  final idController = new TextEditingController(),
      phoneController = new TextEditingController(),
      emailController = new TextEditingController(),
      pwdController = new TextEditingController();
  String nickname, bio, gender, location;
  DateTime birthday;

  Future<void> btnRegClick() async {
    bool regPassed = false;
    String errorCode = '0';
    if (idController.text.isNotEmpty && pwdController.text.isNotEmpty) {
      Recordset rs = await searchUser(idController.text);
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
    } else {
      errorCode = '1';
    }
    if (errorCode != '0') {
      var msg = '注册失败,';
      if (errorCode == '1') {
        msg = '未填写所有必填字段.';
      }
      if (errorCode.contains('2')) {
        msg += '\n该用户名已存在.';
      }
      if (errorCode.contains('3')) {
        msg += '\n该邮箱地址已被注册.';
      }
      if (errorCode.contains('4')) {
        msg += '\n该电话号码已被注册.';
      }
      print(msg);
      Scaffold.of(context).showSnackBar(errorSnackBar(msg));
    }

    if (regPassed) {
      //写入登录状态
      Response res = await Dio().post(
        '$apiServerAddress/createAccount/',
        data: {
          "username": idController.text,
          "password": pwdController.text,
          "email": emailController.text.isEmpty ? 'null' : emailController.text,
          "phone": phoneController.text.isEmpty ? 'null' : phoneController.text,
          // "nickname": nickname,
          // "birthday": birthday,
          // "bio": bio,
          // "gender": gender,
          // "location": location
        },
        options: new Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (res.statusCode == 200) {
        Toast.show('欢迎,${idController.text}', context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Recordset recordset = await searchUser(idController.text);
        await prefs.setString('userID', recordset.id.toString());
        await prefs.setString('userName', idController.text);
        await prefs.setBool('isLogin', true);
        Recordset rs = await searchUser(idController.text);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return HomeScreen(
            userId: rs.id.toString(),
            userName: idController.text,
          );
        }), result: "null");
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 350,
      height: 600,
      child: Column(
        children: [
          //卡片内容
          new Container(
            margin: EdgeInsets.only(top: 40, bottom: 30),
            child: Text(
              '注册',
              style: new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          //用户名字段
          new Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            child: TextField(
              keyboardType: TextInputType.name,
              controller: idController,
              decoration: InputDecoration(
                  labelText: '用户名',
                  hintText: '可用于登录和查找用户.',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
          ),
          //电子邮箱字段
          new Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: InputDecoration(
                  labelText: '电子邮箱地址(可选)',
                  hintText: 'someone@example.com',
                  prefixIcon: Icon(Icons.mail_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
          ),
          new Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            child: TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                  labelText: '电话号码(可选)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
          ),
          //密码字段
          new Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            child: TextField(
              controller: pwdController,
              obscureText: !passwordVisible,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  labelText: '密码',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: passwordVisible ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => setState(() {
                      passwordVisible = !passwordVisible;
                    }),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
          ),
          //注册
          new Container(
            width: 80,
            height: 40,
            margin: EdgeInsets.only(top: 10),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Text(
                '注册',
                style: new TextStyle(color: Colors.white),
              ),
              onPressed: btnRegClick,
            ),
          )
        ],
      ),
    );
  }
}
