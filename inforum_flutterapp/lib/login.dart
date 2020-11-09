import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible;

  @override
  void initState() {
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {

    onBottom(Widget child) => Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        );

    return Scaffold(
      body: Stack(
        children: [
          //动画波&渐变背景
          new Stack(
            children: <Widget>[
              Positioned.fill(child: AnimatedBackground()),
              onBottom(AnimatedWave(
                height: 180,
                speed: 1.0,
              )),
              onBottom(AnimatedWave(
                height: 120,
                speed: 0.9,
                offset: pi,
              )),
              onBottom(AnimatedWave(
                height: 220,
                speed: 1.2,
                offset: pi / 2,
              )),
            ],
          ),
          //布局
          new Container(
            margin: const EdgeInsets.only(
                left: 30.0, top: 50.0, bottom: 30.0, right: 30.0),
            child: Flex(
              direction: Axis.vertical,
              children: [
                //标题
                new Container(
                  child: Text(
                    'Inforum',
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        height: 1.1, //行高
                        fontSize: 50),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                new Expanded(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 500),
                    child: AnimatedContainer(
                      alignment: Alignment.center,
                      width: 350,
                      height: 500,
                      duration: Duration(milliseconds: 500),
                      child: Card(
                        margin: EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            //卡片内容
                            new Container(
                              margin: EdgeInsets.only(top: 40, bottom: 30),
                              child: Text(
                                '登录',
                                style: new TextStyle(fontSize: 25,
                                fontWeight: FontWeight.bold),
                              ),
                            ),
                            //用户名表单
                            new Container(
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, top: 10, bottom: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                initialValue: '', //接收上次登录的用户名.
                                decoration: InputDecoration(
                                    labelText: '用户名,手机或者邮箱地址',
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              ),
                            ),
                            //密码表单
                            new Container(
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, top: 10, bottom: 10),
                              child: TextFormField(
                                obscureText: !passwordVisible,
                                textInputAction: TextInputAction.done,
                                initialValue: '', //接收上次登录的用户名.
                                decoration: InputDecoration(
                                    labelText: '密码',
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: passwordVisible
                                            ? Colors.blue
                                            : Colors.black26,
                                      ),
                                      onPressed: () => setState(() {
                                        passwordVisible = !passwordVisible;
                                      }),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                              ),
                            ),
                            //登录按钮
                            new Container(
                              width: 80,
                              height: 40,
                              margin: EdgeInsets.only(top: 10),
                              child: RaisedButton(
                                color: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Text(
                                  '下一步',
                                  style: new TextStyle(color: Colors.white),
                                ),
                                onPressed: btnNextClick,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void btnNextClick() {
    _incrementCounter() async {
      //写入登录状态
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int counter = (prefs.getInt('counter') ?? 0) + 1;
      await prefs.setInt('counter', counter);
    }

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return HomeScreen();
    }), result: "null");
  }
}
