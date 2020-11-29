import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPage createState() => _RegPage();
}

class _RegPage extends State<RegPage> {
  bool passwordVisible = false;

  void btnRegClick() {}
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
                  '注册',
                  style:
                      new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              //用户名表单
              new Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: '邮箱地址',
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              //密码表单
              new Container(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: TextFormField(
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
                  onPressed: btnRegClick,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
