import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inforum/component/actionButton.dart';
import 'package:inforum/subPage/editPost.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumDetailPage extends StatefulWidget {
  final int forumID;
  final String titleText;
  final String contentText;
  final int likeCount;
  final int dislikeCount;
  final int likeState;
  final int commentCount;
  final String imgThumbnail;
  final bool isCollect;
  final String authorName;
  final String imgAuthor;
  final bool isAuthor;
  final List<String> tags;

  const ForumDetailPage(
      {Key key,
      this.titleText,
      this.contentText,
      this.likeCount,
      this.dislikeCount,
      this.commentCount,
      this.imgThumbnail,
      this.isCollect,
      this.likeState,
      this.authorName,
      this.imgAuthor,
      this.isAuthor,
      this.forumID,
      this.tags})
      : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  bool isCollect;
  int likeState = 0; //0缺省,1为点赞,2为踩
  int likeCount;
  int dislikeCount;
  int commentCount;
  SharedPreferences sp;
  bool isAuthor;
  List<String> tagStrings;
  List<Widget> tagWidgets;

  @override
  void initState() {
    isAuthor = widget.isAuthor;
    isCollect = widget.isCollect;
    likeCount = widget.likeCount;
    dislikeCount = widget.dislikeCount;
    likeState = widget.likeState;
    commentCount = widget.commentCount;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getTagWidgets();
    List<Widget> forumDetailUI = [
      Container(
        height: 70,
        margin: EdgeInsets.only(top: 10, left: 22, right: 10),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            CircleAvatar(
              radius: 33,
              backgroundImage: AssetImage(widget.imgAuthor),
            ),
            Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 15, left: 10),
                      child: Text(
                        widget.authorName,
                        style: new TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
                Container(
                  height: 25,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    '@ra1n7246',
                    style: new TextStyle(color: Colors.black54),
                  ),
                )
              ],
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_down_rounded),
              //TODO:用户下拉菜单
              onPressed: () {},
            )
          ],
        ),
      ),
      new Container(
        margin: EdgeInsets.only(
          top: 10,
          left: 25,
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.titleText,
          style: new TextStyle(
              color: Color(0xFF000000),
              fontSize: 25,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ),
      new Container(
          margin: EdgeInsets.only(top: 10, left: 25, right: 25),
          child: Text(
            widget.contentText,
            style: new TextStyle(fontSize: 18),
          )),
      new Container(
        margin: EdgeInsets.only(left: 25, right: 25,top: 5,bottom: 5),
        alignment: Alignment.centerLeft,
        child: tagWidgets != null
            ? Wrap(
                spacing: 5,
                runSpacing: 1,
                children: tagWidgets,
              )
            : null,
      ),
      Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 5),
        width: widget.imgThumbnail != null ? 400 : 0,
        child: widget.imgThumbnail != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Hero(
                  tag: 'img',
                  child: Image.asset(
                    widget.imgThumbnail,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              )
            : null,
      ),
      Divider(thickness: 2),
      Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        height: 40,
        child: Flex(direction: Axis.horizontal, children: [
          Expanded(
            flex: 1,
            child: ActionButton(
                fun: () => _likeButtonClick(),
                ico: likeState == 0 || likeState == 2
                    ? Icon(Icons.thumb_up_outlined)
                    : Icon(Icons.thumb_up),
                txt: likeCount.toString()),
          ),
          Expanded(
            flex: 1,
            child: ActionButton(
                fun: () => _dislikeButtonClick(),
                ico: likeState == 0 || likeState == 1
                    ? Icon(Icons.thumb_down_outlined)
                    : Icon(Icons.thumb_down),
                txt: dislikeCount.toString()),
          ),
          Expanded(
              flex: 1,
              child: ActionButton(
                  //TODO:实现评论按钮
                  fun: () => print('clicked comment button'),
                  ico: Icon(Icons.mode_comment_outlined),
                  txt: commentCount.toString())),
          Expanded(
            flex: 0,
            child: ActionButton(
              //TODO:实现分享按钮
              fun: () => print('clicked Share button'),
              ico: Icon(Icons.share_outlined),
            ),
          ),
        ]),
      ),
      Divider(thickness: 2),
    ];
    getComments();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Color(0xFFFAFAFA),
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text('帖子', style: TextStyle(color: Colors.black)),
        actions: [
          isAuthor
              ? new Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      tooltip: '编辑',
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return EditPostScreen(
                          titleText: widget.titleText,
                          contentText: widget.contentText,
                          tags: widget.tags,
                          mode: 1,
                        );
                      })),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_rounded),
                      tooltip: '删除',
                      onPressed: () {},
                    )
                  ],
                )
              : Container(),
          new IconButton(
            icon: isCollect ? Icon(Icons.star) : Icon(Icons.star_border),
            onPressed: () => _starButtonClick(),
            tooltip: isCollect ? '取消收藏' : '收藏',
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {},
        child: Scrollbar(
          radius: Radius.circular(5),
          child: ListView(
            children: forumDetailUI,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //退出时切换状态栏UI前景色
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    super.dispose();
  }

  void _starButtonClick() {
    //TODO:异步收藏
    setState(() {
      isCollect = !isCollect;
    });
  }

  void _likeButtonClick() {
    print('clicked like button');
    //TODO:异步点赞
    setState(() {
      switch (likeState) {
        case 0:
          likeState = 1;
          likeCount++;
          break;
        case 1:
          likeState = 0;
          if (likeCount != 0) {
            likeCount--;
          }
          break;
        case 2:
          likeState = 1;
          if (dislikeCount != 0) {
            dislikeCount--;
          }
          likeCount++;
          break;
      }
    });
  }

  void _dislikeButtonClick() {
    //TODO:异步踩
    print('clicked dislike button');
    setState(() {
      switch (likeState) {
        case 0:
          likeState = 2;
          dislikeCount++;
          break;
        case 1:
          likeState = 2;
          if (likeCount != 0) {
            likeCount--;
          }
          dislikeCount++;
          break;
        case 2:
          likeState = 0;
          if (dislikeCount != 0) {
            dislikeCount--;
          }
          break;
      }
    });
  }

  void _getTagWidgets() {
    tagWidgets = [];
    tagStrings = widget.tags;
    if (tagStrings != null) {
      tagWidgets.addAll(tagStrings
          .map((e) => Container(
                height: 32,
                child: Chip(
                  avatar: const Icon(
                    Icons.tag,
                    color: Colors.blue,
                  ),
                  label: Text(
                    '$e',
                    style: new TextStyle(color: Colors.blue),
                  ),
                  backgroundColor: Color(0xffF8F8F8),
                ),
              ))
          .toList());
    }
  }

  void getComments() {
    //TODO:获取回复List
  }
}
