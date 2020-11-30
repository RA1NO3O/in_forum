import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:inforum/subPage/editPost.dart';
import 'package:inforum/subPage/messagePage.dart';
import 'package:inforum/subPage/primaryPage.dart';
import 'package:inforum/subPage/searchPage.dart';
import 'package:inforum/subPage/userPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({Key key, this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Color _currentColor = Colors.blue;
  IconData _actionIcon = Icons.post_add;
  PageController _pageController;

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
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          label: '我')
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
          child: PageTransitionSwitcher(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              pageChanged();
            });
          },
          children: <Widget>[
            PrimaryPage(
              userId: widget.userId,
            ),
            MessagePage(),
            SearchPage(),
            NotificationPage()
          ],
        ),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            child: child,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
          );
        },
      )),
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
                      return EditPostScreen(mode: 0,);
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
}
