import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/home.dart';
import 'package:inforum/service/loginService.dart' as LoginRS;
import 'package:inforum/service/profileService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String? userName;
  final String? password;

  const LoginPage({Key? key, this.userName, this.password}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = new TextEditingController();
  final pwdController = new TextEditingController();
  bool isProcessing = false;
  bool isNotFilled = true;
  bool passwordVisible = false;
  bool isUserFound = false;
  Map user = new Map();

  @override
  void initState() {
    userNameController.text = widget.userName ?? '';
    userNameController.text = widget.password ?? '';
    userNameController.addListener(idListener);
    pwdController.addListener(pwdListener);
    super.initState();
  }

  void pwdListener() {
    setState(() {
      if (pwdController.text.isNotEmpty) {
        isNotFilled = false;
      } else {
        isNotFilled = true;
      }
    });
  }

  void idListener() {
    setState(() {
      if (userNameController.text.trim().isNotEmpty) {
        isNotFilled = false;
      } else {
        isNotFilled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext bc) {
      return Container(
        alignment: Alignment.center,
        height: 350,
        child: Column(
          children: [
            Container(
              height: 5,
              child: isProcessing ? LinearProgressIndicator() : null,
            ),
            //卡片内容
            new Container(
              margin: EdgeInsets.only(top: 40, bottom: 30),
              child: Text(
                isUserFound ? '你好, ${user['userName']}' : '登录',
                style: new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            //用户名字段
            new Container(
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
              child: TextField(
                onEditingComplete: isNotFilled
                    ? null
                    : () async {
                        String r = await btnNextClick();
                        if (r != 'ok') {
                          ScaffoldMessenger.of(bc)
                              .showSnackBar(errorSnackBar(r));
                        }
                      },
                keyboardType: TextInputType.emailAddress,
                controller: userNameController,
                enabled: (!isUserFound) && (!isProcessing),
                decoration: InputDecoration(
                    labelText: '用户名,手机或者邮箱地址',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            //密码字段
            AnimatedContainer(
              curve: Curves.easeOutCubic,
              duration: Duration(milliseconds: 500),
              padding: isUserFound
                  ? EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10)
                  : EdgeInsets.zero,
              child: isUserFound
                  ? TextField(
                      autofocus: true,
                      controller: pwdController,
                      obscureText: !passwordVisible,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: isNotFilled
                          ? null
                          : () async {
                              String r = await btnNextClick();
                              if (r != 'ok') {
                                ScaffoldMessenger.of(bc)
                                    .showSnackBar(errorSnackBar(r));
                              }
                            },
                      decoration: InputDecoration(
                          labelText: '密码',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(() {
                              passwordVisible = !passwordVisible;
                            }),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )
                  : null,
            ),
            //登录按钮
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
                  isUserFound ? '登录' : '下一步',
                ),
                onPressed: (isNotFilled && (!isProcessing))
                    ? null
                    : () async {
                        String r = await btnNextClick();
                        if (r != 'ok') {
                          ScaffoldMessenger.of(bc)
                              .showSnackBar(errorSnackBar(r));
                        }
                      },
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<String> btnNextClick() async {
    setState(() {
      isProcessing = true;
    });

    if (isUserFound) {
      final LoginRS.LoginRecordset? rs =
          await LoginRS.tryLogin(userNameController.text, pwdController.text);

      if (rs != null) {
        ProfileRecordset? rs2 = await getProfile(rs.id);
        String _nickName=rs2?.nickname??'';
        String _userName=rs2?.username??'';
        String _avatarURL=rs2?.avatarUrl??'';
        String _bannerURL=rs2?.avatarUrl??'';
        String _bio=rs2?.bio??'';
        String _location = rs2?.location??'';

        //写入登录状态
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('userID', rs.id!);
        prefs.setString('userName', _userName);
        prefs.setString('nickName', _nickName);
        prefs.setString('avatarURL', _avatarURL);
        prefs.setString('bannerURL', _bannerURL);
        prefs.setString('bio', _bio);
        prefs.setString('location', _location);
        prefs.setBool('isLogin', true);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return HomeScreen(
            userID: rs.id,
            userName: rs.username,
            nickName: _nickName,
          );
        }));
        userNameController.removeListener(idListener);
        setState(() {
          isProcessing = false;
        });

        return 'ok';
      } else {
        setState(() {
          isProcessing = false;
        });
        return '密码错误,请重试.';
      }
    } else {
      try {
        final LoginRS.LoginRecordset? rs =
            await LoginRS.searchUser(userNameController.text);

        if (rs != null) {
          setState(() {
            user['userName'] = rs.username;
            isUserFound = true;
            isProcessing = false;
          });
          return 'ok';
        } else {
          setState(() {
            isProcessing = false;
          });
          return '未找到该用户.';
        }
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      isProcessing = false;
    });
    return 'unknown error';
  }

  @override
  void dispose() {
    userNameController.dispose();
    pwdController.dispose();
    super.dispose();
  }
}
