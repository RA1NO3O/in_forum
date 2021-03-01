import 'dart:ui';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:inforum/component/actionButton.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/component/imageViewer.dart';
import 'package:inforum/data/postCommentStream.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/dateTimeFormat.dart';
import 'package:inforum/service/imageShareService.dart';
import 'package:inforum/service/postDetailService.dart';
import 'package:inforum/subPage/editPost.dart';
import 'package:inforum/subPage/newComment.dart';
import 'package:inforum/subPage/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumDetailPage extends StatefulWidget {
  final int postID;
  final String titleText;
  final String contentShortText;
  final int likeCount;
  final int dislikeCount;
  final int likeState;
  final int commentCount;
  final String imgURL;
  final bool isCollect;
  final String authorName;
  final String imgAuthor;
  final bool isAuthor;
  final List<String> tags;
  final String time;
  final String heroTag;

  const ForumDetailPage({
    Key key,
    this.titleText,
    this.likeCount,
    this.dislikeCount,
    this.commentCount,
    this.imgURL,
    this.isCollect,
    this.likeState,
    this.authorName,
    this.imgAuthor,
    this.isAuthor,
    this.postID,
    this.tags,
    this.time,
    this.heroTag,
    this.contentShortText,
  }) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  String fullText;
  bool isCollect;
  int likeState = 0; //0缺省,1为点赞,2为踩
  int likeCount;
  int dislikeCount;
  int commentCount;
  SharedPreferences sp;
  String authorUserName = '';
  bool isAuthor;
  List<String> tagStrings;
  List<Widget> tagWidgets;
  List<Widget> commentList = [];
  bool loadState = false;
  TextEditingController _commentController;
  DateTime dt;
  String _time;

  @override
  void initState() {
    _time = widget.time;
    isAuthor = widget.isAuthor;
    isCollect = widget.isCollect;
    likeCount = widget.likeCount;
    dislikeCount = widget.dislikeCount;
    likeState = widget.likeState;
    commentCount = widget.commentCount;
    _commentController = new TextEditingController();
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getTagWidgets();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('帖子'),
        actions: [
          isAuthor
              ? new Row(
                  children: [
                    Builder(
                      builder: (bc) => IconButton(
                        icon: Icon(Icons.edit),
                        tooltip: '编辑',
                        onPressed: () async {
                          final result = await Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return EditPostScreen(
                              titleText: widget.titleText,
                              contentText: fullText,
                              tags: widget.tags,
                              imgURL: widget.imgURL,
                              mode: 1,
                              postID: widget.postID,
                              heroTag: widget.heroTag,
                            );
                          }));
                          if (result == '0') {
                            Scaffold.of(bc)
                                .showSnackBar(doneSnackBar('  帖子已修改.'));
                            _refresh();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_rounded),
                      tooltip: '删除',
                      onPressed: () => deleteConfirmDialog(),
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
      body: Builder(builder: (BuildContext c) {
        return RefreshIndicator(
          strokeWidth: 2.5,
          onRefresh: _refresh,
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 1,
                child: Scrollbar(
                  radius: Radius.circular(5),
                  child: ListView(children: [
                    Container(
                      height: 70,
                      margin: EdgeInsets.only(top: 10, left: 22, right: 10),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Material(
                            elevation: 3,
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            color: Colors.transparent,
                            child: Ink.image(
                              image: widget.imgAuthor != null
                                  ? CachedNetworkImageProvider(widget.imgAuthor)
                                  : AssetImage('images/test.jpg'),
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ProfilePage(
                                      userID: widget.authorName,
                                    );
                                  }));
                                },
                              ),
                            ),
                          ),
                          Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10, left: 10),
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    widget.authorName,
                                    style: new TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 25,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(authorUserName),
                                ),
                              ),
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
                        style: titleFontStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    new Container(
                        margin: EdgeInsets.only(top: 10, left: 25, right: 25),
                        child: Text(
                          fullText ?? widget.contentShortText,
                          style: new TextStyle(fontSize: 18),
                        )),
                    new Container(
                      margin: EdgeInsets.only(
                        left: 25,
                        right: 25,
                        top: 10,
                        bottom: 10,
                      ),
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
                      margin: widget.imgURL != null
                          ? EdgeInsets.only(left: 25, right: 25, bottom: 5)
                          : EdgeInsets.all(0),
                      child: widget.imgURL != null
                          ? Hero(
                              child: Material(
                                elevation: 1,
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(5),
                                child: Ink.image(
                                  width: widget.imgURL != null ? 400 : 0,
                                  height: widget.imgURL != null ? 200 : 0,
                                  fit: BoxFit.cover,
                                  image:
                                      CachedNetworkImageProvider(widget.imgURL),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        new MaterialPageRoute(
                                          builder: (BuildContext bc) =>
                                              ImageViewer(
                                                  imgURL: widget.imgURL,
                                                  heroTag: widget.heroTag),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              tag: widget.heroTag,
                            )
                          : null,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: Text(DateTimeFormat.convertBasicTimeFormat(_time)),
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
                            fun: () => commentBottomSheet(context),
                            ico: Icon(Icons.mode_comment_outlined),
                            txt: commentCount.toString(),
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: ActionButton(
                            fun: () => shareNetworkImage(widget.imgURL),
                            ico: Icon(Icons.share_outlined),
                          ),
                        ),
                      ]),
                    ),
                    Divider(thickness: 2),
                    Column(
                      children: loadState
                          ? commentList
                          : [Center(child: Icon(Icons.hourglass_top_rounded))],
                    )
                  ]),
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: InkWell(
                    onTap: () => commentBottomSheet(context),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.send,
                            decoration: InputDecoration(
                              enabled: false,
                              hintText: '发布回复',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.photo_outlined,
                            color: Colors.blue,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NewCommentScreen(
                                targetPostID: widget.postID,
                                contentText: _commentController.text,
                                imgURL: null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void commentBottomSheet(BuildContext bc) {
    TextEditingController _commentController = new TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      context: bc,
      builder: (bc) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 5),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.send,
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: '发布回复',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.open_in_full_rounded),
                    tooltip: '全屏撰写',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => NewCommentScreen(
                          targetPostID: widget.postID,
                          contentText: _commentController.text,
                          imgURL: null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      flex: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo_rounded,
                          color: Colors.blue,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => NewCommentScreen(
                              targetPostID: widget.postID,
                              contentText: _commentController.text,
                              imgURL: null,
                            ),
                          ),
                        ),
                      )),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 0,
                    child: FlatButton(
                      child: Text('发送'),
                      colorBrightness: Brightness.dark,
                      color: Colors.blue,
                      onPressed: () {},
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _starButtonClick() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Response res = await Dio().post('$apiServerAddress/starPost/',
        options: new Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          "userID": sp.getInt('userID'),
          "postID": widget.postID,
        });
    if (res.data == 'success.') {
      setState(() {
        isCollect = !isCollect;
      });
    }
  }

  Future<void> _likeButtonClick() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Response res = await Dio().post('$apiServerAddress/thumbUp/',
        options: new Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          "userID": sp.getInt('userID'),
          "postID": widget.postID,
        });
    if (res.data == 'success.') {
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
  }

  Future<void> _dislikeButtonClick() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Response res = await Dio().post('$apiServerAddress/thumbDown/',
        options: new Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          "userID": sp.getInt('userID'),
          "postID": widget.postID,
        });
    if (res.data == 'success.') {
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
                ),
              ))
          .toList());
    }
  }

  Future<void> _refresh() async {
    sp = await SharedPreferences.getInstance();
    commentList.clear();
    Recordset rs = await getPostDetail(widget.postID);
    if (rs != null) {
      setState(() {
        fullText = rs.body;
        authorUserName = rs.username;
        _time = rs.lastEditTime.toString();
      });
    }
    var _list = await getComment(widget.postID, sp.getInt('userID')) ?? [];
    setState(() {
      commentList.addAll(_list);
      loadState = true;
    });
  }

  deleteConfirmDialog() async {
    bool result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Icon(
              Icons.help_rounded,
              size: 40,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text('删除帖子?'),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton.icon(
            textColor: Colors.blue,
            icon: Icon(Icons.arrow_back_rounded),
            label: Text('取消'),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton.icon(
            textColor: Colors.redAccent,
            icon: Icon(Icons.delete_forever_rounded),
            label: Text('确认'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (result) {
      Response res = await Dio().delete(
        '$apiServerAddress/deletePost/',
        options: new Options(contentType: Headers.formUrlEncodedContentType),
        data: {"postID": widget.postID},
      );
      if (res.data == 'success.') {
        // Fluttertoast.showToast(msg: '帖子已删除.');
        Navigator.pop(context, '0');
      }
    }
  }
}
