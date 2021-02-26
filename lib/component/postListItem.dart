import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inforum/component/actionButton.dart';
import 'package:inforum/component/imageViewer.dart';
import 'package:inforum/data/dateTimeFormat.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/subPage/newComment.dart';
import 'package:inforum/subPage/postDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customStyles.dart';

class ForumListItem extends StatefulWidget {
  final int postID;
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
    this.postID,
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
  String imgTag = getRandom(6);
  String _imagePath;

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
                              postID: widget.postID,
                              time: widget.time,
                              heroTag: imgTag,
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
                                              backgroundImage: widget
                                                          .imgAuthor !=
                                                      null
                                                  ? CachedNetworkImageProvider(
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
                                image:
                                    CachedNetworkImageProvider(widget.imgURL),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ImageViewer(
                                                    imageProvider:
                                                        CachedNetworkImageProvider(
                                                            widget.imgURL),
                                                    heroTag: imgTag)));
                                  },
                                ),
                              ),
                            ),
                            tag: imgTag,
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
                            fun: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        NewCommentScreen(
                                      targetPostID: widget.postID,
                                      imgURL: null,
                                    ),
                                  ),
                                ),
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

  static String getRandom(int num) {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  Future<void> _starButtonClick() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Response res = await Dio().post('$apiServerAddress/starPost/',
        options: new Options(contentType: Headers.formUrlEncodedContentType),
        data: {
          "userID": sp.getInt('userID'),
          "postID": widget.postID,
        });
    if (res.statusCode == 200) {
      setState(() {
        isCollect = !isCollect;
        isCollect ? collectCount++ : collectCount--;
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
    if (res.statusCode == 200) {
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

  @override
  void dispose() {
    super.dispose();
  }
}
