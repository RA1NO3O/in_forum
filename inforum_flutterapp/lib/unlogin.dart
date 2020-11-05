import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inforum_app/home.dart';
import 'package:simple_animations/simple_animations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inforum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(title: 'Inforum'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Colors.yellow, end: Colors.green)),
      Track("color2").add(
          Duration(seconds: 3), ColorTween(begin: Colors.red, end: Colors.blue))
    ]);
    return Scaffold(
      body: Stack(
        children: [
          new Container(
            child: ControlledAnimation(
              playback: Playback.MIRROR,
              tween: tween,
              duration: tween.duration,
              builder: (context, animation) {
                return Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [animation["color1"], animation["color2"]])),
                );
              },
            ),
          ),
          new Container(
              margin:
                  const EdgeInsets.only(left: 30.0, top: 50.0, bottom: 30.0, right: 30.0),
              child: Column(
                children: [
                  new Container(
                    child: Text(
                      'HelloWorld',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  new Row(
                    children: [
                      new Text('已有账号? 点此'),
                      new Container(
                        width: 40,
                        height: 25,
                        child: FlatButton(
                          onPressed: btnStart_click,
                          child: Text(
                            '登录',
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                color: Colors.lightBlue,
                            ),
                          ),
                          padding: EdgeInsets.all(0),
                        ),
                      )
                    ],
                  )
                ],
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        //扩展版浮动按钮
        onPressed: btnStart_click,
        icon: Icon(Icons.arrow_forward),
        label: Text('入门'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void btnStart_click() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context){
          return HomePage();
        }),result:"null");
  }
}
