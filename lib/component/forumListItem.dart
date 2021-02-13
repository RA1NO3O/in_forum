import 'package:flutter/material.dart';
import 'package:inforum/component/actionButton.dart';
import 'package:inforum/component/imageViewer.dart';
import 'package:inforum/data/dateTimeFormat.dart';
import 'package:inforum/subPage/forumDetail.dart';

import 'customStyles.dart';

class ForumListItem extends StatefulWidget {
  final int forumID;
  final String titleText;
  final String contentText;
  final int likeState;
  final int likeCount;
  final int dislikeCount;
  final int commentCount;
  final int collectCount;
  final String imgURL;
  final bool isCollect;
  final String authorName;
  final String imgAuthor;
  final bool isAuthor;
  final String time;
  final List<String> tags;

  const ForumListItem({
    Key key,
    this.titleText,
    this.contentText,
    this.likeCount,
    this.dislikeCount,
    this.commentCount,
    this.collectCount,
    this.imgURL,
    this.likeState,
    this.isCollect,
    this.imgAuthor,
    this.authorName,
    this.isAuthor,
    this.forumID,
    this.time,
    this.tags,
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
  List<String> tagStrings;
  List<Widget> tagWidgets;

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

  void _getTagWidgets() {
    tagWidgets = [];
    tagStrings = widget.tags;
    if (tagStrings != null) {
      tagWidgets.addAll(tagStrings
          .map((s) => Container(
                height: 32,
                child: Chip(
                  label: Text(
                    '$s',
                    style: new TextStyle(color: Colors.blue),
                  ),
                  avatar: Icon(
                    Icons.tag,
                    color: Colors.blue,
                  ),
                ),
              ))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    _getTagWidgets();
    return Builder(builder: (BuildContext bc) {
      return Card(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        elevation: 1,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              child: Container(
                child: Flex(direction: Axis.vertical, children: [
                  InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ForumDetailPage(
                              titleText: widget.titleText,
                              contentText: widget.contentText,
                              likeCount: likeCount,
                              dislikeCount: dislikeCount,
                              likeState: likeState,
                              commentCount: commentCount,
                              imgURL: widget.imgURL,
                              isCollect: isCollect,
                              imgAuthor: widget.imgAuthor,
                              authorName: widget.authorName,
                              isAuthor: widget.isAuthor,
                              tags: widget.tags,
                              forumID: widget.forumID,
                              time: widget.time,
                            );
                          })),
                      child: Column(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 5, bottom: 5),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(right: 5),
                                          child: CircleAvatar(
                                              radius: 15,
                                              backgroundImage:
                                                  widget.imgAuthor != null
                                                      ? NetworkImage(
                                                          widget.imgAuthor)
                                                      : AssetImage(
                                                          'images/test.jpg'))),
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
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              widget.titleText,
                              style: titleFontStyle,
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
                        ],
                      )),
                  Container(
                    padding: widget.imgURL != null
                        ? EdgeInsets.all(5)
                        : EdgeInsets.all(0),
                    child: widget.imgURL != null
                        ? Hero(
                            child: Material(
                              elevation: 2,
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(5),
                              child: Ink.image(
                                width: widget.imgURL != null ? 400 : 0,
                                height: widget.imgURL != null ? 200 : 0,
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.imgURL),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ImageViewer(
                                                    imageProvider: NetworkImage(
                                                        widget.imgURL),
                                                    heroTag: 'img')));
                                  },
                                ),
                              ),
                            ),
                            tag: 'img',
                          )
                        : null,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: tagWidgets != null
                          ? Wrap(
                              spacing: 5,
                              runSpacing: 1,
                              children: tagWidgets,
                            )
                          : null),
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
                            fun: () => Scaffold.of(bc)
                                .showBottomSheet((bc) => commentContainer()),
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
        ),
      );
    });
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

  Container commentContainer() {
    TextEditingController _commentController = new TextEditingController();
    return Container(
        height: 102,
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: _commentController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.send,
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
                          Icons.photo_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: () {})),
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
}
