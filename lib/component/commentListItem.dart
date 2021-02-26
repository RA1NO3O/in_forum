import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/actionButton.dart';
import 'file:///E:/DEV/SYNC_BY_GitHub/Inforum/lib/service/dateTimeFormat.dart';
import 'package:inforum/data/webConfig.dart';
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

  const CommentListItem(
      {Key key,
      this.postID,
      this.commenterAvatarURL,
      this.commenterName,
      this.commentTime,
      this.content,
      this.commentTarget,
      this.likeState,
      this.likeCount,
      this.imgURL})
      : super(key: key);

  @override
  _CommentListItem createState() => _CommentListItem();
}

class _CommentListItem extends State<CommentListItem> {
  int likeState; //0缺省,1为点赞,2为踩
  int likeCount;

  @override
  void initState() {
    likeState = widget.likeState;
    likeCount = widget.likeCount;
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
                        image: CachedNetworkImageProvider(
                            widget.commenterAvatarURL),
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
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                      //TODO:用户下拉菜单
                      onPressed: () {},
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
                widget.imgURL != null
                    ? Material(
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(5),
                        child: Ink.image(
                          width: widget.imgURL != null ? 400 : 0,
                          height: widget.imgURL != null ? 200 : 0,
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(widget.imgURL),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ImageViewer(
                                        imageProvider:
                                            CachedNetworkImageProvider(
                                                widget.imgURL),
                                      )));
                            },
                          ),
                        ),
                      )
                    : Container(),
                Row(
                  children: [
                    ActionButton(
                        fun: _likeButtonClick,
                        ico: likeState == 0
                            ? Icon(Icons.thumb_up_outlined)
                            : Icon(Icons.thumb_up),
                        txt: likeCount.toString()),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => NewCommentScreen(
                            targetPostID: widget.postID,
                            imgURL: null,
                          ),
                        ),
                      ),
                      icon: Icon(Icons.quickreply_rounded),
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

    if (res.statusCode == 200) {
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
}
