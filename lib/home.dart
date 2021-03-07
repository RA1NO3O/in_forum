import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inforum/service/profileService.dart';
import 'package:inforum/service/randomGenerator.dart';
import 'package:inforum/subPage/collectionPage.dart';
import 'package:inforum/subPage/editPost.dart';
import 'package:inforum/subPage/messagePage.dart';
import 'package:inforum/subPage/primaryPage.dart';
import 'package:inforum/subPage/profilePage.dart';
import 'package:inforum/subPage/searchPage.dart';
import 'package:inforum/subPage/settingsPage/settingsPage.dart';
import 'package:inforum/subPage/notificationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'component/customStyles.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  final int userID;
  final String userName;
  final String nickName;

  const HomeScreen({
    Key key,
    @required this.userID,
    @required this.userName,
    @required this.nickName,
  }) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Color _currentColor = Colors.blue;
  IconData _actionIcon = Icons.post_add;
  PageController _pageController;
  ScrollController _scrollController;
  SharedPreferences sp;
  static ScaffoldMessengerState scaffold;
  String _hintText;
  String _avatarURL;
  String _followerCount = '0';
  String _followingCount = '0';
  String _avatarHeroTag = getRandom(6);

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _scrollController = ScrollController();
    init();
    super.initState();
  }

  void init() async {
    sp = await SharedPreferences.getInstance();
    var rs = await getProfile(widget.userID);
    setState(() {
      _avatarURL = sp.getString('avatarURL');

      _followerCount = rs.followerCount.toString();
      _followingCount = rs.followingCount.toString();
    });

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => scaffold.showSnackBar(welcomeSnackBar(widget.userName)));
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
    void pageChanged() {
      switch (_currentIndex) {
        case 0:
          _currentColor = Colors.blue;
          _actionIcon = Icons.post_add_rounded;
          _hintText = '新建帖子';
          break;
        case 1:
          _currentColor = Colors.pink;
          _actionIcon = Icons.add_comment;
          _hintText = '新私信';
          break;
        case 2:
          _currentColor = Colors.cyan;
          _actionIcon = Icons.search_rounded;
          _hintText = '新搜索';
          break;
        case 3:
          _currentColor = Colors.orange;
          _actionIcon = Icons.edit;
          break;
      }
    }

    return Scaffold(
      drawer: mainDrawer(),
      body: PageTransitionSwitcher(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 2,
                title: InkWell(
                  onDoubleTap: () {
                    setState(() {
                      _scrollController.animateTo(.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    });
                  },
                  child: Tooltip(
                    message: '双击标题回到顶部',
                    child: Hero(
                      tag: 'title',
                      child: Text(
                        'Inforum',
                        style: Theme.of(context).primaryTextTheme.headline5,
                      ),
                    ),
                  ),
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
              PrimaryPage(userID: widget.userID),
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
      floatingActionButton: _currentIndex == 0 ||
              _currentIndex == 1 ||
              _currentIndex == 2
          ? Builder(
              builder: (bc) {
                scaffold = ScaffoldMessenger.of(bc);
                return new FloatingActionButton(
                  foregroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .foregroundColor,
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
                  onPressed: () async {
                    switch (_currentIndex) {
                      case 0:
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditPostScreen(mode: 0)));
                        if (result == '0') {
                          ScaffoldMessenger.of(bc)
                              .showSnackBar(doneSnackBar('  帖子已发布.'));
                        }
                        break;
                      case 1:
                        break;
                      case 2:
                        showSearch(
                            context: context, delegate: CustomSearchDelegate());
                        break;
                    }
                  },
                  tooltip: _hintText,
                );
              },
            )
          : null,
    );
  }

  //抽屉
  Widget mainDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 230,
            child: DrawerHeader(
              child: Column(
                children: [
                  Hero(
                    child: Material(
                      elevation: 2,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: Ink.image(
                        image: _avatarURL != null
                            ? CachedNetworkImageProvider(_avatarURL)
                            : AssetImage('images/default_avatar.png'),
                        fit: BoxFit.cover,
                        width: 85,
                        height: 85,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ProfilePage(
                                userID: widget.userID,
                                avatarHeroTag: _avatarHeroTag,
                                avatarURL: _avatarURL,
                              );
                            }));
                          },
                        ),
                      ),
                    ),
                    tag: _avatarHeroTag,
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      widget.userID == null ? 'Unknown' : widget.nickName,
                      style: new TextStyle(fontSize: 25),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(_followingCount,
                              style: new TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Text('正在关注'),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 10),
                          child: Text(_followerCount,
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
                    shape: roundedRectangleBorder,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => CollectionPage(
                                    userID: widget.userID,
                                  )));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help_rounded),
                    title: Text('帮助'),
                    shape: roundedRectangleBorder,
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('设置'),
                    shape: roundedRectangleBorder,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return SettingsPage();
                      }));
                    },
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
                    shape: roundedRectangleBorder,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  TextStyle titleTextStyle() => Theme.of(context)
      .primaryTextTheme
      .caption
      .copyWith(fontSize: 20, fontWeight: FontWeight.bold);

  Future<bool> logOutDialog() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Icon(
                  Icons.warning_rounded,
                  size: 40,
                ),
                Text('确定要退出账号吗?')
              ],
            ),
            actions: <Widget>[
              TextButton.icon(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.redAccent),
                  ),
                  onPressed: () {
                    sp.setBool('isLogin', false);
                    Navigator.of(context).pop(true);
                  },
                  icon: Icon(Icons.done_rounded),
                  label: Text('是')),
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: Icon(Icons.close_rounded),
                  label: Text('手滑了')),
            ],
          );
        });
    if (result == null) {
      return false;
    }
    return result;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
