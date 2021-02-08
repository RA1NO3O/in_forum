import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inforum/component/actionButton.dart';
import 'package:inforum/component/commentListItem.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/data/forumCommentStream.dart';
import 'package:inforum/service/uploadPictureService.dart';
import 'package:inforum/subPage/editPost.dart';
import 'package:inforum/subPage/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumDetailPage extends StatefulWidget {
  final int forumID;
  final String titleText;
  final String contentText;
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

  const ForumDetailPage(
      {Key key,
      this.titleText,
      this.contentText,
      this.likeCount,
      this.dislikeCount,
      this.commentCount,
      this.imgURL,
      this.isCollect,
      this.likeState,
      this.authorName,
      this.imgAuthor,
      this.isAuthor,
      this.forumID,
      this.tags,
      this.time})
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
  List<CommentListItem> commentList = [];
  bool loadState = false;
  String _imagePath;

  @override
  void initState() {
    isAuthor = widget.isAuthor;
    isCollect = widget.isCollect;
    likeCount = widget.likeCount;
    dislikeCount = widget.dislikeCount;
    likeState = widget.likeState;
    commentCount = widget.commentCount;
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
                                  ? NetworkImage(widget.imgAuthor)
                                  : AssetImage('images/test.jpg'),
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return ProfilePage(
                                      userId: widget.authorName,
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
                                  child: Text(
                                    '@ra1n7246',
                                  ),
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
                          widget.contentText,
                          style: new TextStyle(fontSize: 18),
                        )),
                    new Container(
                      margin: EdgeInsets.only(
                          left: 25, right: 25, top: 5, bottom: 10),
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
                      width: widget.imgURL != null ? 400 : 0,
                      child: widget.imgURL != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                widget.imgURL,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : null,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: Text(widget.time),
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
                                fun: () => Scaffold.of(c)
                                    .showBottomSheet((c) => commentContainer()),
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
                    Column(
                      children: loadState ? commentList : [],
                    )
                  ]),
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: InkWell(
                        onTap: () => Scaffold.of(c)
                            .showBottomSheet((c) => commentContainer()),
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
                                onPressed: getImage)
                          ],
                        ))),
              ),
            ],
          ),
        );
      }),
    );
  }

  Container commentContainer() {
    TextEditingController _commentController = new TextEditingController();
    return Container(
        height: 102,
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                      onPressed: () {})),
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
                        onPressed: getImage)),
                Expanded(
                    flex: 0,
                    child: Container(
                      height: 45,
                      width: 45,
                      child: _imagePath != null
                          ? Image.file(File(_imagePath), fit: BoxFit.fitWidth)
                          : null,
                    )),
                Expanded(flex: 1, child: Container()),
                Expanded(
                    flex: 0,
                    child: FlatButton(
                      child: Text('发送'),
                      colorBrightness: Brightness.dark,
                      color: Colors.blue,
                      onPressed: () {},
                    ))
              ],
            )
          ],
        ));
  }

  @override
  void dispose() {
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
                ),
              ))
          .toList());
    }
  }

  Future<void> _refresh() async {
    commentList.clear();
    var _list = await getComment(widget.forumID) ?? [];
    commentList.addAll(_list);
    setState(() {
      loadState = true;
    });
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      } else {
        print('No image selected.');
      }
    });
  }
}
