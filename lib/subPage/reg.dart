import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/home.dart';
import 'package:inforum/service/loginService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPage createState() => _RegPage();
}

class _RegPage extends State<RegPage> {
  String errorCode = '0';
  bool passwordVisible = false;
  final idController = new TextEditingController();
  final phoneNumberController = new TextEditingController();
  final emailController = new TextEditingController();
  final pwdController = new TextEditingController();
  String nickname, bio, gender, location;
  DateTime birthday;

  Future<void> btnRegClick() async {
    bool state;
    if (searchUser(idController.text) != null) {
      errorCode = '1';
      if (searchUser(phoneNumberController.text) != null) {
        errorCode += '2';
        if (searchUser(emailController.text) != null) {
          errorCode += '3';
          state = false;
        }
      }
    } else {
      state = true;
    }

    if (state) {
      //写入登录状态
      Response res = await Dio().post('$apiServerAddress/createAccount/',
          data: FormData.fromMap(
            {
              "username": idController.text,
              "password": pwdController.text,
              "email": emailController.text,
              "phone": phoneNumberController.text,
              "nickname": nickname,
              "birthday": birthday,
              "bio": bio,
              "gender": gender,
              "location": location
            },
          ));
      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', idController.text);
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
              controller: phoneNumberController,
              decoration: InputDecoration(
                  labelText: '电话号码(可选)',
                  prefixIcon: Icon(Icons.person),
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
