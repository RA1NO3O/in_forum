import 'dart:math';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inforum/home.dart';
import 'package:inforum/subPage/reg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:inforum/subPage/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogin =
      prefs.getBool('isLogin') == null ? false : prefs.getBool('isLogin')!;

  if (prefs.getBool('isLogin') == null) {
    prefs.setString('draft_title', '');
    prefs.setString('draft_content', '');
    prefs.setStringList('draft_tags', []);
  }

  runApp(MaterialApp(
    title: 'Inforum',
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    home: isLogin
        ? HomeScreen(
            userID: prefs.getInt('userID'),
            userName: prefs.getString('userName'),
            nickName: prefs.getString('nickName'),
          )
        : MainPage(
            title: 'Inforum',
            state: 0,
          ),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [
      const Locale("zh", "CH"),
      const Locale("en", "US"),
      const Locale("ja", "JP"),
    ],
    debugShowCheckedModeBanner: false, //隐藏debug横幅
  ));
}

//主界面
class MainPage extends StatefulWidget {
  final String? title;
  final int state;
  final String? userName;

  MainPage({
    Key? key,
    this.title,
    required this.state,
    this.userName,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int state = 0; //0代表初始界面,1代表登录,2代表注册
  @override
  void initState() {
    print(widget.userName);
    state = widget.state;
    super.initState();
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
          SafeArea(
            child: Container(
              margin: EdgeInsets.all(30),
              alignment: Alignment.center,
              child: Scaffold(
                appBar: AppBar(
                  title: Hero(
                    tag: 'title',
                    child: Text(
                      widget.title ?? 'Inforum',
                      style: Theme.of(context).primaryTextTheme.headline6,
                    ),
                  ),
                  leading: state != 0
                      ? IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              state = 0;
                            });
                          },
                        )
                      : null,
                ),
                backgroundColor: Colors.transparent,
                body: ListView(
                  children: [
                    PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 500),
                      reverse: state == 0,
                      transitionBuilder:
                          (child, animation, secondaryAnimation) {
                        return SharedAxisTransition(
                          child: child,
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                        );
                      },
                      child: state == 0
                          ? defaultPage()
                          : state == 1
                              ? LoginPage(
                                  userName: widget.userName,
                                )
                              : RegPage(),
                    ),
                  ],
                ),
              ),
            ),
          ),
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

  TextStyle titleTextStyle() => Theme.of(context)
      .primaryTextTheme
      .caption!
      .copyWith(fontSize: 20, fontWeight: FontWeight.bold);

  Widget defaultPage() {
    return Container(
      height: 350,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 100),
            child: Text(
              '这是全新的跨平台论坛App!\n',
              style: new TextStyle(fontSize: 22),
              textAlign: TextAlign.left,
            ),
            alignment: Alignment.center,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('已有账号? 点此'),
                Container(
                  width: 48,
                  height: 40,
                  child: TextButton(
                    onPressed: btnLoginClick,
                    child: Text(
                      '登录',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                        fontSize: 15,
                        color: Colors.lightBlue,
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

enum AniProps { width, height, color, color2 }

//动画渐变背景
class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tween = TimelineTween<AniProps>()
      ..addScene(
              begin: Duration(milliseconds: 0), duration: Duration(seconds: 5))
          .animate(AniProps.color,
              tween: ColorTween(
                begin: Colors.red,
                end: Colors.green.shade600,
              ))
      ..addScene(begin: Duration(milliseconds: 0), end: Duration(seconds: 5))
          .animate(AniProps.color2,
              tween: ColorTween(
                begin: Colors.purple,
                end: Colors.blue.shade600,
              ));

    return CustomAnimation(
      control: CustomAnimationControl.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, child, dynamic value) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              value.get(AniProps.color),
              value.get(AniProps.color2)
            ])),
      ),
    );
  }
}

//动画波
class AnimatedWave extends StatelessWidget {
  final double? height;
  final double? speed;
  final double offset;

  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: CustomAnimation(
          control: CustomAnimationControl.LOOP,
          duration: Duration(milliseconds: (5000 / speed!).round()),
          tween: Tween(begin: 0.0, end: 2 * pi),
          builder: (context, child, dynamic value) => CustomPaint(
            foregroundPainter: CurvePainter(value + offset),
          ),
        ),
      );
    });
  }
}

//自定义波形绘制器
class CurvePainter extends CustomPainter {
  final double? value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(60);
    final path = Path();

    final y1 = sin(value!);
    final y2 = sin(value! + pi / 2);
    final y3 = sin(value! + pi);

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
