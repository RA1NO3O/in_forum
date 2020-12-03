import 'package:flutter/material.dart';

class CommentListItem extends StatefulWidget {
  final int forumID;
  final String commenterAvatarURL;
  final String commenterName;
  final String commentTime;
  final String content;
  final String commentTarget; //留空为直接回复在帖子下,否则为回复给指定ID的对话

  const CommentListItem(
      {Key key,
      this.forumID,
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
    return Column(
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            CircleAvatar(
              radius: 33,
              backgroundImage: AssetImage(widget.commenterAvatarURL),
            ),
            Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 15, left: 10),
                      child: Text(
                        widget.commenterName,
                        style: new TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
                Container(
                  height: 25,
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    '@ra1n7246',
                    style: new TextStyle(color: Colors.black54),
                  ),
                )
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
      ],
    );
  }
}
