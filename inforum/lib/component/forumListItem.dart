import 'package:flutter/material.dart';
import 'package:inforum/component/actionButton.dart';
import 'package:inforum/component/tagItem.dart';
import 'package:inforum/subPage/forumDetail.dart';

class ForumListItem extends StatefulWidget {
  final String titleText;
  final String summaryText;
  final int likeState;
  final int likeCount;
  final int dislikeCount;
  final int commentCount;
  final int collectCount;
  final String imgThumbnail;
  final bool isCollect;
  final String authorName;
  final String imgAuthor;

  const ForumListItem(
      {Key key,
      this.titleText,
      this.summaryText,
      this.likeCount,
      this.dislikeCount,
      this.commentCount,
      this.collectCount,
      this.imgThumbnail,
      this.likeState,
      this.isCollect,
      this.imgAuthor,
      this.authorName})
      : super(key: key);

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
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Card(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Container(
            child: Flex(direction: Axis.vertical, children: [
              InkWell(
                  onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ForumDetailPage(
                          titleText: widget.titleText,
                          summaryText: widget.summaryText,
                          likeCount: likeCount,
                          dislikeCount: dislikeCount,
                          likeState: likeState,
                          commentCount: commentCount,
                          imgThumbnail: widget.imgThumbnail,
                          isCollect: isCollect,
                          imgAuthor: widget.imgAuthor,
                          authorName: widget.authorName,
                        );
                      })),
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 5,bottom: 5),
                          child: Flex(direction: Axis.horizontal, children: [
                            Text(
                              widget.titleText,
                              style: new TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Container(
                                padding: EdgeInsets.only(right: 13),
                                child: Row(children: [
                                  Text(widget.authorName),
                                  Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: CircleAvatar(
                                          radius: 15,
                                          backgroundImage:
                                              AssetImage(widget.imgAuthor)))
                                ]))
                          ])),
                      Flex(direction: Axis.horizontal, children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              widget.summaryText,
                            ),
                          ),
                        ),
                        Container(
                          width: widget.imgThumbnail != null ? 100 : 0,
                          height: widget.imgThumbnail != null ? 80 : 0,
                          child: widget.imgThumbnail != null
                              ? Image.asset(widget.imgThumbnail)
                              : null,
                        ),
                      ]),
                      Row(
                        children: [TagItem(label: 'Test', v: 1)],
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
                        //TODO:实现评论按钮
                        fun: () => print('clicked comment button'),
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
      ),
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
