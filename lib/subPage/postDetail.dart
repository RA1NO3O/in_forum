import 'dart:ui';
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
import 'package:inforum/service/randomGenerator.dart';
import 'package:inforum/subPage/editPost.dart';
import 'package:inforum/subPage/newComment.dart';
import 'package:inforum/subPage/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetailPage extends StatefulWidget {
  final int? postID;
  final int? editorID;
  final String? titleText;
  final String? contentShortText;
  final int? likeCount;
  final int? dislikeCount;
  final int? likeState;
  final int? commentCount;
  final String? imgURL;
  final bool? isCollect;
  final String? authorName;
  final String? imgAuthor;
  final bool isAuthor;
  final List<String>? tags;
  final String? time;
  final String? heroTag;

  const PostDetailPage({
    Key? key,
    this.titleText,
    this.likeCount,
    this.dislikeCount,
    this.commentCount,
    this.imgURL,
    this.isCollect,
    this.likeState,
    required this.authorName,
    this.imgAuthor,
    required this.isAuthor,
    required this.postID,
    this.tags,
    this.time,
    this.heroTag,
    this.contentShortText,
    required this.editorID,
  }) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  String? _title;
  String? _fullText;
  List<String>? _tags;
  bool? isCollect;
  String? _imgURL;
  int _editorID = 0;
  int likeState = 0; //0缺省,1为点赞,2为踩
  int likeCount = 0;
  int dislikeCount = 0;
  int commentCount = 0;
  late SharedPreferences sp;
  String? authorUserName = '';
  late bool isAuthor;
  List<String>? tagStrings;
  List<Widget>? tagWidgets;
  List<Widget> commentList = [];
  bool loadState = false;
  late TextEditingController _commentController;
  DateTime? dt;
  String? _time;
  String? _avatarHeroTag;

  @override
  void initState() {
    _avatarHeroTag = getRandom(6);
    _time = widget.time;
    isAuthor = widget.isAuthor;
    isCollect = widget.isCollect;
    likeCount = widget.likeCount!;
    dislikeCount = widget.dislikeCount!;
    likeState = widget.likeState!;
    commentCount = widget.commentCount!;
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
                              titleText: _title,
                              contentText: _fullText,
                              tags: _tags,
                              imgURL: _imgURL,
                              mode: 1,
                              postID: widget.postID,
                              heroTag: widget.heroTag,
                            );
                          }));
                          if (result == '0') {
                            ScaffoldMessenger.of(bc)
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
            icon: isCollect! ? Icon(Icons.star) : Icon(Icons.star_border),
            onPressed: () => _starButtonClick(),
            tooltip: isCollect! ? '取消收藏' : '收藏',
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
                          Hero(
                            child: Material(
                              elevation: 2,
                              shape: CircleBorder(),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.transparent,
                              child: Ink.image(
                                image: (widget.imgAuthor != null &&
                                            widget.imgAuthor!.isNotEmpty
                                        ? CachedNetworkImageProvider(
                                            widget.imgAuthor!)
                                        : AssetImage(
                                            'images/default_avatar.png'))
                                    as ImageProvider<Object>,
                                fit: BoxFit.contain,
                                width: 80,
                                height: 80,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return ProfilePage(
                                        userID: _editorID,
                                        avatarHeroTag: _avatarHeroTag,
                                        avatarURL: widget.imgAuthor,
                                      );
                                    }));
                                  },
                                ),
                              ),
                            ),
                            tag: _avatarHeroTag!,
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
                                    widget.authorName!,
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
                                  child: Text('@$authorUserName'),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          PopupMenuButton(
                            // icon: Icon(Icons.keyboard_arrow_down_rounded),
                            itemBuilder: (bc) => <PopupMenuEntry>[
                              PopupMenuItem(
                                value: 'forward',
                                child: Row(
                                  children: [
                                    Icon(
                                        Icons.subdirectory_arrow_right_rounded),
                                    Text('  转发'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'shield',
                                child: Row(
                                  children: [
                                    Icon(Icons.do_disturb_alt_rounded),
                                    Text('  屏蔽')
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'report',
                                child: Row(
                                  children: [
                                    Icon(Icons.report),
                                    Text('  举报'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (dynamic result) {
                              switch (result) {
                                case 'forward':
                                  break;
                                case 'shield':
                                  break;
                                case 'report':
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(top: 10, left: 25, right: 25),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _title ?? widget.titleText!,
                        style: titleFontStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    new Container(
                        margin: EdgeInsets.only(top: 10, left: 25, right: 25),
                        child: Text(
                          _fullText ?? widget.contentShortText!,
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
                              children: tagWidgets!,
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
                                  image: CachedNetworkImageProvider(
                                      widget.imgURL!),
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
                              tag: widget.heroTag!,
                            )
                          : null,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: Text(convertBasicTimeFormat(_time!)),
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
                            child: Builder(
                              builder: (BuildContext bc) => ActionButton(
                                fun: () => commentBottomSheet(bc),
                                ico: Icon(Icons.mode_comment_outlined),
                                txt: commentCount.toString(),
                              ),
                            )),
                        Expanded(
                          flex: 0,
                          child: ActionButton(
                            fun: () {
                              if (_imgURL != null) {
                                shareNetworkImage(widget.imgURL!);
                              } else {
                                shareTexts(_fullText!);
                              }
                            },
                            ico: Icon(Icons.share_outlined),
                          ),
                        ),
                      ]),
                    ),
                    Divider(thickness: 2),
                    Column(
                      children: loadState
                          ? commentList
                          : [
                              Center(child: Icon(Icons.hourglass_top_rounded)),
                              Text('载入中')
                            ],
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
                          onPressed: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    NewCommentScreen(
                                  targetUserID: widget.editorID,
                                  targetPostID: widget.postID,
                                  contentText: _commentController.text,
                                  targetUserName: authorUserName,
                                  imgURL: null,
                                ),
                              ),
                            );
                            if (result == '0') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(doneSnackBar('  回复已送出.'));
                            }
                          },
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

  Future<void> commentBottomSheet(BuildContext bc) async {
    TextEditingController _commentController = new TextEditingController();
    var result = await showModalBottomSheet(
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
                  hintText: '回复给@$authorUserName',
                  suffixIcon: IconButton(
                      icon: Icon(Icons.open_in_full_rounded),
                      tooltip: '全屏撰写',
                      onPressed: () {
                        Navigator.pop(bc);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => NewCommentScreen(
                              targetUserID: widget.editorID,
                              targetPostID: widget.postID,
                              contentText: _commentController.text,
                              targetUserName: authorUserName,
                              imgURL: null,
                            ),
                          ),
                        );
                      }),
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
                              targetUserID: widget.editorID,
                              targetPostID: widget.postID,
                              contentText: _commentController.text,
                              targetUserName: authorUserName,
                              imgURL: null,
                            ),
                          ),
                        ),
                      )),
                  Expanded(flex: 1, child: Container()),
                  Expanded(
                    flex: 0,
                    child: TextButton(
                      child: Text('发送'),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        int? editorID = prefs.getInt('userID');
                        Response res = await Dio().post(
                            '$apiServerAddress/newComment/',
                            options: new Options(
                                contentType: Headers.formUrlEncodedContentType),
                            data: {
                              "targetPostID": widget.postID,
                              "content": _commentController.text,
                              "imgURL": 'null',
                              "editorID": editorID
                            });
                        if (res.data == 'success.') {
                          Navigator.pop(context, '0');
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
    if (result == '0') {
      ScaffoldMessenger.of(bc).showSnackBar(doneSnackBar('  回复已送出.'));
    }
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
        isCollect = !isCollect!;
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
      tagWidgets!.addAll(tagStrings!
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
    PostDetailRecordset? rs = await getPostDetail(widget.postID);
    if (rs != null) {
      setState(() {
        _title = rs.title;
        _fullText = rs.body;
        authorUserName = rs.username;
        _imgURL = rs.imageUrl;
        _time = rs.lastEditTime.toString();
        _tags = rs.tags != null ? rs.tags!.split(',') : null;
        _editorID = rs.editorId!;
      });
    }
    var _list = await getComment(widget.postID, sp.getInt('userID'));
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
              TextButton.icon(
                icon: Icon(Icons.arrow_back_rounded),
                label: Text('取消'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton.icon(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent),
                ),
                icon: Icon(Icons.delete_forever_rounded),
                label: Text('确认'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
    if (result) {
      Response res = await Dio().delete(
        '$apiServerAddress/deletePost/',
        options: new Options(contentType: Headers.formUrlEncodedContentType),
        data: {"postID": widget.postID},
      );
      if (res.data == 'success.') {
        Navigator.pop(context, '0');
      }
    }
  }
}
