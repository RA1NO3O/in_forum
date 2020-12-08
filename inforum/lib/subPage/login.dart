import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inforum/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final idController = new TextEditingController();
  final pwdController = new TextEditingController();
  bool isNotFilled=true;
  bool passwordVisible = false;
  bool isUserFound = false;

  @override
  void initState() {
    idController.addListener(idListener);
    pwdController.addListener(pwdListener);
    super.initState();
  }

  void pwdListener() {
    setState(() {
      if(pwdController.text.isNotEmpty){
        isNotFilled = false;
      }else{
        isNotFilled = true;
      }
    });
  }

  void idListener() {
    setState(() {
      if (idController.text.trim().isNotEmpty) {
        isNotFilled = false;
      } else {
        isNotFilled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 350,
      height: 350,
      child: Column(
        children: [
          //卡片内容
          new Container(
            margin: EdgeInsets.only(top: 40, bottom: 30),
            child: Text(
              isUserFound ? '欢迎回来,${idController.text}' : '登录',
              style: new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          //用户名表单
          new Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            child: TextField(
              onEditingComplete: isNotFilled?(){}:btnNextClick,
              keyboardType: TextInputType.emailAddress,
              controller: idController,
              enabled: !isUserFound,
              decoration: InputDecoration(
                  labelText: '用户名,手机或者邮箱地址',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),
          ),
          //密码表单
          Container(
            padding: isUserFound
                ? EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10)
                : EdgeInsets.zero,
            child: isUserFound
                ? TextField(
                    controller: pwdController,
                    obscureText: !passwordVisible,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: isNotFilled? (){} :btnNextClick,
                    decoration: InputDecoration(
                        labelText: '密码',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color:
                                passwordVisible ? Colors.blue : Colors.black54,
                          ),
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
            child: RaisedButton(
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Text(
                isUserFound ? '登录' : '下一步',
                style: new TextStyle(color: Colors.white),
              ),
              onPressed: isNotFilled ? null : btnNextClick,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    idController.dispose();
    super.dispose();
  }

  Future<void> btnNextClick() async {
    if (isUserFound) {
      //写入登录状态
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', idController.text);
      await prefs.setBool('isLogin', true);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return HomeScreen(
          userId: idController.text,
        );
      }), result: "null");
      idController.removeListener(idListener);
    } else {
      //TODO:API查找用户
      setState(() {
        isUserFound = true;
      });
    }
  }
}
