import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inforum/home.dart';
import 'package:inforum/subPage/reg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:inforum/subPage/login.dart';

//主方法
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogin =
      prefs.getBool('isLogin') == null ? false : prefs.getBool('isLogin');
  String userId = prefs.getString('userId');
  print(isLogin);
  runApp(MaterialApp(
    title: 'Inforum',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: isLogin
        ? HomeScreen(
            userId: userId.isEmpty ? 'User' : userId,
          )
        : MainPage(
            title: 'Inforum',
          ),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [const Locale("zh", "CH"), const Locale("en", "US")],
    debugShowCheckedModeBanner: false, //隐藏debug横幅
  ));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isLogin ? Color(0xFFFAFAFA) : Color(0x00000000),
      statusBarIconBrightness: isLogin ? Brightness.dark : Brightness.light));
}

//主界面
class MainPage extends StatefulWidget {
  final String title;

  MainPage({Key key, this.title}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var state = 0; //0代表初始界面,1代表登录,2代表注册
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
              child: Column(
                children: [
                  new Container(
                    child: Hero(
                      tag: 'title',
                      child: Text(
                        'Inforum',
                        textAlign: TextAlign.left,
                        style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.1, //行高
                            fontSize: 50),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Container(
                          child: state==0?Text(
                            '\n来体验一下全新的论坛app\n',
                            textAlign: TextAlign.left,
                            style: new TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                height: 1.1, //行高
                                fontSize: 25),
                          ):null,
                          alignment: Alignment.centerLeft,
                        ),
                        Container(child: state==0?Row(
                          children: [
                            Text(
                              '已有账号? 点此',
                              style: new TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                            Container(
                              width: 40,
                              height: 25,
                              child: FlatButton(
                                onPressed: btnLoginClick,
                                child: Text(
                                  '登录',
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(
                                    fontSize: 15,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                                padding: EdgeInsets.all(0),
                              ),
                            )
                          ],
                        ):null),
                        Container(child: state==1?LoginPage():null,),
                        Container(child: state==2?RegPage():null,)
                      ],
                    ),
                  )
                ],
              )),
        ],
      ),
      floatingActionButton: state == 0
          ? new FloatingActionButton.extended(
              onPressed: btnCreateClick,
              icon: Icon(Icons.arrow_forward),
              label: Text('创建账户'),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }

  //创建账户按钮
  void btnCreateClick() async {
    //写入登录状态
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);

    setState(() {
      state = 2;
    });
  }

  //登录按钮
  void btnLoginClick() {
    setState(() {
      state = 1;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

//动画渐变背景
class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 5),
          ColorTween(begin: Colors.red, end: Colors.green.shade600)),
      Track("color2").add(Duration(seconds: 5),
          ColorTween(begin: Colors.purple, end: Colors.blue.shade600))
    ]);

    return ControlledAnimation(
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
    );
  }
}

//动画波
class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: ControlledAnimation(
            playback: Playback.LOOP,
            duration: Duration(milliseconds: (5000 / speed).round()),
            tween: Tween(begin: 0.0, end: 2 * pi),
            builder: (context, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            }),
      );
    });
  }
}

//自定义波形绘制器
class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
