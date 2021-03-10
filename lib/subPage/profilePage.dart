import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:inforum/component/GalleryListItem.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/component/imageViewer.dart';
import 'package:inforum/component/postListItem.dart';
import 'package:inforum/service/dateTimeFormat.dart';
import 'package:inforum/service/postStreamService.dart';
import 'package:inforum/service/profileService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final int? userID;
  final String? avatarURL;
  final String? avatarHeroTag;

  const ProfilePage(
      {Key? key,
      required this.userID,
      required this.avatarHeroTag,
      this.avatarURL})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  String? _userName = '';
  String? _nickName = '';
  String? _birthday;
  String? _bio = '';
  String? _location = '';
  String? _avatarURL;
  String? _avatarHeroTag;
  String? _bannerURL;
  String _followerCount = '0';
  String _followingCount = '0';
  String? _joinTime;
  List<PostListItem> _postListItems = [];
  List<GalleryListItem> _galleryListItems = [];
  List<PostListItem> _likedPostItems = [];
  bool _loadState = false;

  @override
  void initState() {
    _avatarURL = widget.avatarURL;
    _avatarHeroTag = widget.avatarHeroTag;
    _refresh();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  _refresh() async {
    setState(() {
      _loadState = true;
      _postListItems.clear();
      _galleryListItems.clear();
    });
    SharedPreferences sp = await SharedPreferences.getInstance();
    var rs = await getProfile(widget.userID);
    _postListItems
        .addAll(await getPostsByID(widget.userID, sp.getInt('userID')));
    _galleryListItems
        .addAll(await getGalleryByUser(widget.userID, sp.getInt('userID')));
    _likedPostItems
        .addAll(await getLikedPostsByUser(widget.userID, sp.getInt('userID')));
    setState(() {
      if (widget.userID == sp.getInt('userID')) {
        _userName = sp.getString('userName');
        _nickName = sp.getString('nickName');
        _avatarURL = sp.getString('avatarURL');
        _bannerURL = sp.getString('bannerURL');
        _bio = sp.getString('bio');
        _location = sp.getString('location');
        _birthday = sp.getString('birthday');
        _joinTime = sp.getString('joinTime');
      }
      _userName = rs!.username ?? 'unknown';
      _nickName = rs.nickname ?? 'unknown';
      _birthday = rs.birthday.toString();
      _bio = rs.bio ?? '此用户没有填写个人简介';
      _location = rs.location ?? 'unknown';
      _avatarURL = rs.avatarUrl;
      _bannerURL = rs.bannerUrl;
      _followerCount = rs.followerCount.toString();
      _followingCount = rs.followingCount.toString();
      _joinTime = rs.joinDate.toString();
      _loadState = false;
    });
    if (widget.userID == sp.getInt('userID')) {
      sp.setString('userName', _userName??'');
      sp.setString('nickName', _nickName??'');
      sp.setString('avatarURL', _avatarURL??'');
      sp.setString('bannerURL', _bannerURL??'');
      sp.setString('bio', _bio??'');
      sp.setString('location', _location??'');
      sp.setString('birthday', _birthday??'');
      sp.setString('joinTime', _joinTime??'');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('@$_userName'),
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 330,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.more_vert_rounded), onPressed: () {})
              ],
              flexibleSpace: new FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          flex: 0,
                          child: _bannerURL != null
                              ? CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.broken_image_rounded),
                                  imageUrl: _bannerURL!,
                                  fit: BoxFit.cover,
                                  height: 150,
                                )
                              : Container(
                                  height: 150,
                                ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 25),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                        top: 10, left: 90, right: 10),
                                    child: Row(
                                      children: [
                                        Text(_nickName!, style: titleFontStyle),
                                        Text('  @$_userName'),
                                      ],
                                    )),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, right: 10),
                                  alignment: Alignment.topLeft,
                                  child: Text(_bio!, maxLines: 3),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.cake_rounded),
                                    Text(
                                        '  ${_birthday != null ? convertBasicDateFormat(_birthday!) : ''}   '),
                                    Icon(Icons.date_range_rounded),
                                    Text(
                                        '  ${_joinTime != null ? convertBasicDateFormat(_joinTime!) : ''} 加入'),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_rounded),
                                      Text('  $_location  '),
                                      TextButton(
                                        child: Text(
                                          ' $_followerCount 关注者  ',
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {},
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          '$_followingCount 正在关注 ',
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 105, left: 20),
                      child: Hero(
                        child: Material(
                          elevation: 1,
                          shape: CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.transparent,
                          child: Ink.image(
                            image: (_avatarURL != null
                                    ? CachedNetworkImageProvider(_avatarURL!)
                                    : AssetImage('images/default_avatar.png'))
                                as ImageProvider<Object>,
                            fit: BoxFit.contain,
                            width: 80,
                            height: 80,
                            child: InkWell(
                              onTap: () {
                                if (_avatarURL != null) {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ImageViewer(
                                      imgURL: _avatarURL,
                                      heroTag: _avatarHeroTag,
                                    );
                                  }));
                                }
                              },
                            ),
                          ),
                        ),
                        tag: _avatarHeroTag!,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        border: Border.all(
                          width: 5,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    child: TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      controller: _tabController,
                      tabs: <Widget>[
                        Container(
                            height: 40,
                            padding: EdgeInsets.only(top: 10),
                            child: Text('帖子')),
                        Container(
                            height: 40,
                            padding: EdgeInsets.only(top: 10),
                            child: Text('照片')),
                        Container(
                            height: 40,
                            padding: EdgeInsets.only(top: 10),
                            child: Text('赞')),
                      ],
                    ),
                  )
                ],
              ),
            )
          ];
        },
        body: RefreshIndicator(
            strokeWidth: 2.5,
            child: Scrollbar(
              radius: Radius.circular(5),
              child: TabBarView(
                controller: _tabController,
                children: [
                  !_loadState
                      ? StaggeredGridView.extentBuilder(
                          maxCrossAxisExtent: 240,
                          itemCount: _postListItems.length,
                          itemBuilder: (context, index) =>
                              _postListItems[index],
                          staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                        )
                      : emptyHint(),
                  //媒体
                  !_loadState
                      ? GridView.extent(
                          primary: false,
                          // mainAxisSpacing: 1,
                          // crossAxisSpacing: 1,
                          maxCrossAxisExtent: 100,
                          children: _galleryListItems,
                        )
                      : emptyHint(),
                  //赞
                  !_loadState
                      ? StaggeredGridView.extentBuilder(
                          maxCrossAxisExtent: 240,
                          itemCount: _likedPostItems.length,
                          itemBuilder: (context, index) =>
                              _likedPostItems[index],
                          staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                        )
                      : emptyHint(),
                ],
              ),
            ),
            onRefresh: () async {
              await _refresh();
              return;
            }),
      ),
    );
  }
}
