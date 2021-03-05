import 'package:flutter/material.dart';
import 'package:inforum/service/profileService.dart';

class ProfilePage extends StatefulWidget {
  final String userID;

  const ProfilePage({Key key, this.userID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  String _userName;
  String _nickName;
  DateTime _birthday;
  String _bio;
  String _location;
  String _avatarURL;
  String _bannerURL;
  String _followerCount = '0';
  String _followingCount = '0';

  @override
  void initState() {
    _refresh();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(widget.userID),
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 150,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.more_vert_rounded), onPressed: () {})
              ],
              flexibleSpace: new FlexibleSpaceBar(
                //TODO:接入banner
                background: Image.asset(
                  "images/test.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 50,
                    child: TabBar(
                      controller: _tabController,
                      tabs: <Widget>[Text("帖子和回复"), Text("媒体"), Text("赞")],
                    ),
                  )
                ],
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            //帖子和回复
            ListView(
              children: [],
            ),
            //媒体
            ListView(
              children: [],
            ),
            //赞
            ListView(
              children: [],
            ),
          ],
        ),
      ),
    );
  }

  void _refresh() async {
    var rs = await getProfile(widget.userID);
    setState(() {
      _userName = rs.username;
      _nickName = rs.nickname;
      _birthday = rs.birthday;
      _bio = rs.bio;
      _location = rs.location;
      _avatarURL = rs.avatarUrl;
      _bannerURL = rs.bannerUrl;
      _followerCount = rs.followerCount.toString();
      _followingCount = rs.followingCount.toString();
    });
  }
}
