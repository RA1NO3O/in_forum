import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/actionButton.dart';
import 'package:inforum/component/imageViewer.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/dateTimeFormat.dart';
import 'package:inforum/service/randomGenerator.dart';
import 'package:inforum/subPage/newComment.dart';
import 'package:inforum/subPage/postDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customStyles.dart';

class PostListItem extends StatefulWidget {
  final int? postID;
  final int? editorID;
  final String? titleText;
  @required
  final String? contentText;
  final int? likeState;
  final int? likeCount;
  final int? dislikeCount;
  final int? commentCount;
  final int? collectCount;
  final String? imgURL;
  final bool? isCollect;
  final String? authorName;
  final String? imgAuthor;
  final bool isAuthor;
  final String time;
  final List<String>? tags;
  final int? index;

  const PostListItem({
    Key? key,
    required this.titleText,
    required this.contentText,
    this.likeCount,
    this.dislikeCount,
    this.commentCount,
    this.collectCount,
    this.imgURL,
    this.likeState,
    this.isCollect,
    this.imgAuthor,
    required this.authorName,
    required this.isAuthor,
    this.postID,
    required this.time,
    this.tags,
    this.index,
    required this.editorID,
  }) : super(key: key);

  @override
  _PostListItem createState() => _PostListItem();
}

class _PostListItem extends State<PostListItem> {
  TextStyle? v;
  bool isCollect = false;
  int likeState = 0; //0缺省,1为点赞,2为踩
  int collectCount = 0;
  int likeCount = 0;
  int dislikeCount = 0;
  int commentCount = 0;
  List<String>? tagStrings;
  List<Widget>? tagWidgets;
  String imgTag = getRandom(6);

  // ignore: unused_field
  String? _imagePath;

  @override
  void initState() {
    v = widget.postID == null ? invalidTextStyle : new TextStyle();
    likeState = widget.likeState ?? 0;
    collectCount = widget.collectCount ?? 0;
    likeCount = widget.likeCount ?? 0;
    dislikeCount = widget.dislikeCount ?? 0;
    commentCount = widget.commentCount ?? 0;
    isCollect = widget.isCollect ?? false;
    super.initState();
  }

  void _getTagWidgets() {
    tagWidgets = [];
    tagStrings = widget.tags;
    if (tagStrings != null) {
      tagWidgets!.addAll(tagStrings!
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
        margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 2),
        elevation: 1,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              child: Container(
                child: Flex(direction: Axis.vertical, children: [
                  Builder(
                    builder: (bc) => InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return PostDetailPage(
                                editorID: widget.editorID,
                                titleText: widget.titleText,
                                contentShortText: widget.contentText,
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
                            },
                          ),
                        );
                        if (result == '0') {
                          ScaffoldMessenger.of(bc)
                              .showSnackBar(doneSnackBar('帖子已删除.'));
                        }
                      },
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
                                          backgroundImage: (widget.imgAuthor !=
                                                      null &&
                                                  widget.imgAuthor!.isNotEmpty
                                              ? CachedNetworkImageProvider(
                                                  widget.imgAuthor!,
                                                  maxWidth: 80,
                                                  maxHeight: 80)
                                              : ResizeImage(
                                                  AssetImage(
                                                    'images/default_avatar.png',
                                                  ),
                                                  width: 80,
                                                  height: 80,
                                                )) as ImageProvider<Object>,
                                        ),
                                      ),
                                      Text(widget.authorName!, style: v),
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
                                      DateTimeFormat.handleDate(widget.time),
                                      style: v),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              widget.titleText!,
                              maxLines: 2,
                              style: widget.postID != null
                                  ? titleFontStyle
                                  : new TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(5),
                            child: Text(
                              widget.contentText!,
                              maxLines: 5,
                              style: widget.postID != null
                                  ? new TextStyle(fontSize: 16)
                                  : new TextStyle(
                                      fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: widget.imgURL != null
                        ? EdgeInsets.all(5)
                        : EdgeInsets.all(0),
                    child: widget.imgURL != null
                        ? Hero(
                            child: Material(
                              elevation: 1,
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(5),
                              child: Ink.image(
                                width: 400,
                                height: 200,
                                fit: BoxFit.cover,
                                image: ResizeImage(
                                  CachedNetworkImageProvider(
                                    widget.imgURL!,
                                  ),
                                  width: MediaQuery.of(context)
                                          .devicePixelRatio
                                          .toInt() *
                                      400,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ImageViewer(
                                                imgURL: widget.imgURL,
                                                heroTag: imgTag),
                                      ),
                                    );
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
                              children: tagWidgets!,
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
                                      targetUserName: widget.authorName,
                                      targetUserID: widget.editorID,
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

  @override
  void dispose() {
    super.dispose();
  }
}
