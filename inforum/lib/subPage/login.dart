import 'package:flutter/material.dart';
import 'package:inforum/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idController = new TextEditingController();
  bool passwordVisible = false;
  String userID = "unknown";
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                  style:
                      new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              //用户名表单
              new Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: idController,

                  decoration: InputDecoration(
                      labelText: '用户名,手机或者邮箱地址',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              //密码表单
              new Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: TextField(
                  obscureText: !passwordVisible,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      labelText: '密码',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: passwordVisible ? Colors.blue : Colors.black26,
                        ),
                        onPressed: () => setState(() {
                          passwordVisible = !passwordVisible;
                        }),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
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
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
    );
  }
  @override
  void dispose(){
    idController.dispose();
    super.dispose();
  }

  void btnNextClick() async {
    //写入登录状态
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', idController.text);
    await prefs.setBool('isLogin', true);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return HomeScreen();
    }), result: "null");
  }
}
