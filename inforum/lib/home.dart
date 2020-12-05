import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inforum/subPage/editPost.dart';
import 'package:inforum/subPage/messagePage.dart';
import 'package:inforum/subPage/primaryPage.dart';
import 'package:inforum/subPage/searchPage.dart';
import 'package:inforum/subPage/userPage.dart';

// import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key key, this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xAAFAFAFA),
        systemNavigationBarColor: Color(0xFFFAFAFA),
        statusBarIconBrightness: Brightness.dark));
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Color _currentColor = Colors.blue;
  IconData _actionIcon = Icons.post_add;
  PageController _pageController;
  ScrollController _scrollController;

  void pageChanged() {
    switch (_currentIndex) {
      case 0:
        _currentColor = Colors.blue;
        _actionIcon = Icons.post_add;
        break;
      case 1:
        _currentColor = Colors.pink;
        _actionIcon = Icons.add_comment;
        break;
      case 2:
        _currentColor = Colors.cyan;
        _actionIcon = Icons.more_horiz;
        break;
      case 3:
        _currentColor = Colors.orange;
        _actionIcon = Icons.edit;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _scrollController = ScrollController();
    _scrollController.addListener(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context0) {
    var bottomNavigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          size: 30,
          color: Colors.blue,
        ),
        label: '首页',
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.local_post_office,
            size: 30,
            color: Colors.pink,
          ),
          label: '私信'),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            size: 30,
            color: Colors.cyan,
          ),
          label: '搜索'),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications,
            size: 30,
            color: Colors.orange,
          ),
          label: '通知')
    ];

    return Scaffold(
      drawer: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 230,
              child: DrawerHeader(
                child: Column(
                  children: [
                    Material(
                      elevation: 3,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: Ink.image(
                        image: AssetImage('images/test.jpg'),
                        fit: BoxFit.cover,
                        width: 85,
                        height: 85,
                        child: InkWell(
                          onTap: () {},
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        widget.userId.isEmpty ? 'User' : widget.userId,
                        style: new TextStyle(fontSize: 32),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text('123',
                                style: new TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Text('正在关注'),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 10),
                            child: Text('98',
                                style: new TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Text('关注者')
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.star_rounded),
                      title: Text('收藏'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.help_rounded),
                      title: Text('帮助'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('设置'),
                      onTap: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    ListTile(
                      leading: Icon(Icons.login_rounded),
                      title: Text('登出'),
                      onTap: () async {
                        bool i = await logOutDialog();
                        if (i) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => MainPage(
                                        title: 'Inforum',
                                      )));
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                )),
          ],
        ),
      ),
      body: PageTransitionSwitcher(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Color(0xFFFAFAFA),
                brightness: Brightness.light,
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 5,
                title: Text(
                  'Inforum',
                  style: TextStyle(color: Colors.black),
                ),
                snap: true,
                centerTitle: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
              ),
            ];
          },
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                pageChanged();
              });
            },
            children: <Widget>[
              PrimaryPage(userId: widget.userId.isEmpty ? '' : widget.userId),
              MessagePage(),
              SearchPage(),
              NotificationPage(),
            ],
          ),
        ),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            child: child,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: _currentColor,
        currentIndex: _currentIndex,
        items: bottomNavigationBarItems,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
            pageChanged();
          });
        },
      ),
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1
          ? new FloatingActionButton(
              backgroundColor: _currentColor,
              child: AnimatedSwitcher(
                transitionBuilder: (Widget child, Animation<double> anim) {
                  return FadeScaleTransition(
                    animation: anim,
                    child: child,
                  );
                },
                duration: Duration(milliseconds: 200),
                child: Icon(_actionIcon, key: ValueKey(_actionIcon)),
              ),
              onPressed: () {
                switch (_currentIndex) {
                  case 0:
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return EditPostScreen(mode: 0);
                    }));
                    break;
                  case 1:
                    print(_currentIndex);
                    break;
                }
              },
              tooltip: _currentIndex == 0 ? '新建帖子' : '新私信',
            )
          : null,
    );
  }

  Future<bool> logOutDialog() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool result = await showDialog<bool>(
        context: context,
        barrierDismissible: true, //是否可点按空白处退出对话框
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Icon(
                  Icons.warning_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
                Text('确定要退出账号吗?')
              ],
            ),
            actions: <Widget>[
              FlatButton.icon(
                  textColor: Colors.redAccent,
                  onPressed: () {
                    sp.setBool('isLogin', false);
                    Navigator.of(context).pop(true);
                  },
                  icon: Icon(Icons.done_rounded),
                  label: Text('是')),
              FlatButton.icon(
                  textColor: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: Icon(Icons.close_rounded),
                  label: Text('手滑了')),
            ],
          );
        });
    return result;
  }
}
