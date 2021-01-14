import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({Key key, this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3,vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Color(0xFFFAFAFA),
              brightness: Brightness.light,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(widget.userId,style: new TextStyle(color: Colors.black),),
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 150,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.more_vert_rounded), onPressed: () {})
              ],
              flexibleSpace: new FlexibleSpaceBar(
                background: Image.asset(
                  "images/test.jpg",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SliverList(

              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 50,
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      tabs: <Widget>[
                        Text("帖子和回复",style: black87),
                        Text("媒体",style: black87,),
                        Text("赞",style: black87,)
                      ],
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

  TextStyle black87 = TextStyle(color: Colors.black87);
}
