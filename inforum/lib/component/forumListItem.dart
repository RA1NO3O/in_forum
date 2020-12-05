import 'package:flutter/material.dart';
import 'package:inforum/component/actionButton.dart';
import 'package:inforum/component/popUpTextField.dart';
import 'package:inforum/data/dateTimeFormat.dart';
import 'package:inforum/subPage/forumDetail.dart';

class ForumListItem extends StatefulWidget {
  final int forumID;
  final String titleText;
  final String contentText;
  final int likeState;
  final int likeCount;
  final int dislikeCount;
  final int commentCount;
  final int collectCount;
  final String imgThumbnail;
  final bool isCollect;
  final String authorName;
  final String imgAuthor;
  final bool isAuthor;
  final String time;

  const ForumListItem({
    Key key,
    this.titleText,
    this.contentText,
    this.likeCount,
    this.dislikeCount,
    this.commentCount,
    this.collectCount,
    this.imgThumbnail,
    this.likeState,
    this.isCollect,
    this.imgAuthor,
    this.authorName,
    this.isAuthor,
    this.forumID,
    this.time,
  }) : super(key: key);

  @override
  _ForumListItem createState() => _ForumListItem();
}

class _ForumListItem extends State<ForumListItem> {
  bool isCollect;
  int likeState; //0缺省,1为点赞,2为踩
  int collectCount;
  int likeCount;
  int dislikeCount;
  int commentCount;

  @override
  void initState() {
    likeState = widget.likeState;
    collectCount = widget.collectCount;
    likeCount = widget.likeCount;
    dislikeCount = widget.dislikeCount;
    commentCount = widget.commentCount;
    isCollect = widget.isCollect;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 1,
          height: 1,
        ),
        Container(
          padding: EdgeInsets.all(15.0),
          child: Container(
            child: Flex(direction: Axis.vertical, children: [
              InkWell(
                  onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ForumDetailPage(
                          titleText: widget.titleText,
                          contentText: widget.contentText,
                          likeCount: likeCount,
                          dislikeCount: dislikeCount,
                          likeState: likeState,
                          commentCount: commentCount,
                          imgThumbnail: widget.imgThumbnail,
                          isCollect: isCollect,
                          imgAuthor: widget.imgAuthor,
                          authorName: widget.authorName,
                          isAuthor: widget.isAuthor,
                          forumID: widget.forumID,
                        );
                      })),
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 5, bottom: 5),
                          child: Flex(direction: Axis.horizontal, children: [
                            Container(
                              child: Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: CircleAvatar(
                                          radius: 15,
                                          backgroundImage:
                                              AssetImage(widget.imgAuthor))),
                                  Text(widget.authorName),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Container(
                                padding: EdgeInsets.only(right: 13),
                                child: Text(
                                    DateTimeFormat.handleDate(widget.time)))
                          ])),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(5),
                        child: Text(
                          widget.titleText,
                          style: new TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(5),
                        child: Text(
                          widget.contentText,
                          style: new TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        width: widget.imgThumbnail != null ? 400 : 0,
                        height: widget.imgThumbnail != null ? 200 : 0,
                        child: widget.imgThumbnail != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Hero(
                                  tag: 'img',
                                  child: Image.asset(
                                    widget.imgThumbnail,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ))
                            : null,
                      ),
                      Row(
                        children: [
                          Chip(
                            avatar: const Icon(
                              Icons.tag,
                              color: Colors.blue,
                            ),
                            label: Text(
                              'Test',
                              style: new TextStyle(color: Colors.blue),
                            ),
                            backgroundColor: Color(0xffFFFFFF),
                          )
                        ],
                      ),
                    ],
                  )),
              Flex(direction: Axis.horizontal, children: [
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
                        fun: () => Navigator.push(
                            context,
                            PopRoute(
                                child: PopUpTextField(
                              hintText: '发表评论',
                              onEditingCompleteText: (text) {
                                setState(() {
                                  //TODO:添加评论
                                });
                              },
                            ))),
                        ico: Icon(Icons.mode_comment_outlined),
                        txt: commentCount.toString())),
                Expanded(
                  flex: 1,
                  child: ActionButton(
                      fun: () => _starButtonClick(),
                      ico: isCollect
                          ? Icon(Icons.star)
                          : Icon(Icons.star_border),
                      txt: collectCount.toString()),
                ),
              ]),
            ]),
          ),
        ),
      ],
    );
  }

  void _starButtonClick() {
    //TODO:异步收藏
    setState(() {
      isCollect = !isCollect;
      isCollect ? collectCount++ : collectCount--;
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
}
