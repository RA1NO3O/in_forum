import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/actionButton.dart';
import 'package:inforum/component/customStyles.dart';
import 'file:///E:/DEV/SYNC_BY_GitHub/Inforum/lib/service/dateTimeFormat.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/randomGenerator.dart';
import 'package:inforum/subPage/newComment.dart';
import 'package:inforum/subPage/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'imageViewer.dart';

class CommentListItem extends StatefulWidget {
  final int postID;
  final String commenterAvatarURL;
  final String commenterName;
  final String commentTime;
  final String content;
  final String commentTarget; //留空为直接回复在帖子下,否则为回复给指定ID的对话
  final int likeState;
  final int likeCount;
  final String imgURL;
  final bool isAuthor;

  const CommentListItem({
    Key key,
    @required this.postID,
    this.commenterAvatarURL,
    @required this.commenterName,
    @required this.commentTime,
    @required this.content,
    @required this.commentTarget,
    this.likeState,
    this.likeCount,
    this.imgURL,
    this.isAuthor,
  }) : super(key: key);

  @override
  _CommentListItem createState() => _CommentListItem();
}

class _CommentListItem extends State<CommentListItem> {
  String _imgURL;
  int likeState; //0缺省,1为点赞,2为踩
  int likeCount;
  String imgTag = getRandom(6);

  @override
  void initState() {
    _imgURL = widget.imgURL;
    likeState = widget.likeState ?? 0;
    likeCount = widget.likeCount ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Material(
                      elevation: 3,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: Ink.image(
                        image: widget.commenterAvatarURL != null
                            ? CachedNetworkImageProvider(
                                widget.commenterAvatarURL)
                            : AssetImage('images/test.jpg'),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ProfilePage(
                                userID: widget.commenterName,
                              );
                            }));
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            widget.commenterName,
                            style: new TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            '@${widget.commentTarget} · '
                            '${DateTimeFormat.handleDate(widget.commentTime)}',
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Builder(
                      builder: (bc) => PopupMenuButton(
                        // icon: Icon(Icons.keyboard_arrow_down_rounded),
                        itemBuilder: widget.isAuthor
                            ? (bc) => <PopupMenuEntry>[
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_rounded),
                                        Text('  编辑'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_rounded),
                                        Text('  删除'),
                                      ],
                                    ),
                                  ),
                                ]
                            : (bc) => <PopupMenuEntry>[
                                  PopupMenuItem(
                                    value: 'shield',
                                    child: Row(
                                      children: [
                                        Icon(Icons.do_disturb_alt_rounded),
                                        Text('  屏蔽'),
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
                        onSelected: (result) {
                          switch (result) {
                            case 'delete':
                              if (_deleteConfirmDialog() == '0') {
                                ScaffoldMessenger.of(bc)
                                    .showSnackBar(doneSnackBar('回复已删除.'));
                              }
                              break;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 10, left: 5),
                    child: Row(
                      children: [
                        Text(
                          '回复给 ',
                        ),
                        Text(
                          widget.commentTarget,
                          style: new TextStyle(color: Colors.blue),
                        )
                      ],
                    )),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 5, left: 5, top: 5),
                  child: Text(
                    widget.content,
                    style: new TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  margin: _imgURL != null
                      ? EdgeInsets.only(left: 5, right: 25, bottom: 5, top: 5)
                      : EdgeInsets.all(0),
                  child: _imgURL != null
                      ? Hero(
                          child: Material(
                            elevation: 2,
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(5),
                            child: Ink.image(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(_imgURL),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ImageViewer(
                                                imgURL: _imgURL,
                                                heroTag: imgTag,
                                              )));
                                },
                              ),
                            ),
                          ),
                          tag: imgTag,
                        )
                      : Container(),
                ),
                Row(
                  children: [
                    ActionButton(
                        fun: _likeButtonClick,
                        ico: likeState == 0
                            ? Icon(Icons.thumb_up_outlined)
                            : Icon(Icons.thumb_up),
                        txt: likeCount.toString()),
                    IconButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => NewCommentScreen(
                              targetPostID: widget.postID,
                              targetUserName: widget.commentTarget,
                              imgURL: null,
                            ),
                          ),
                        );
                        if (result == '0') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(doneSnackBar('  回复已送出.'));
                        }
                      },
                      icon: Icon(Icons.quickreply_outlined),
                      tooltip: '回复',
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
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
            likeCount++;
            break;
        }
      });
    }
  }
  _deleteConfirmDialog() async {
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
