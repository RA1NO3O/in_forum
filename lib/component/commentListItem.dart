import 'package:flutter/material.dart';
import 'package:inforum/component/actionButton.dart';
import 'package:inforum/data/dateTimeFormat.dart';
import 'package:inforum/subPage/profilePage.dart';

class CommentListItem extends StatefulWidget {
  final int postID;
  final String commenterAvatarURL;
  final String commenterName;
  final String commentTime;
  final String content;
  final String commentTarget; //留空为直接回复在帖子下,否则为回复给指定ID的对话

  const CommentListItem(
      {Key key,
      this.postID,
      this.commenterAvatarURL,
      this.commenterName,
      this.commentTime,
      this.content,
      this.commentTarget})
      : super(key: key);

  @override
  _CommentListItem createState() => _CommentListItem();
}

class _CommentListItem extends State<CommentListItem> {
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
                        image: NetworkImage(widget.commenterAvatarURL),
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
                Row(
                  children: [
                    ActionButton(
                        fun: () {},
                        ico: Icon(Icons.thumb_up_outlined),
                        txt: '0'),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.quickreply_outlined),
                      tooltip: '快速回复',
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
}
