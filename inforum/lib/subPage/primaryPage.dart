import 'package:flutter/material.dart';
import 'package:inforum/component/forumListItem.dart';
class PrimaryPage extends StatefulWidget{
  final String userId;

  const PrimaryPage({Key key, this.userId}) : super(key: key);
  @override
  _PrimaryPage createState() {
    return _PrimaryPage();
  }
}
class _PrimaryPage extends State<PrimaryPage>{
  @override
  Widget build(BuildContext context) {
      return Container(
        margin: EdgeInsets.only(top: 25),
        //TODO:动态创建
        child: Scrollbar(
          child: ListView(
            children: [
              ForumListItem(
                //TODO:从API获取信息并填充
                titleText: '以下的内容仅供测试.',
                summaryText: 'This is a Test. All of the text below is used to test widget.'
                    '\nThis is 2nd line. '
                    '\nThis is 3rd line.'
                    '\nThis is 4th line.',
                likeCount: 10000,
                likeState: 0,
                dislikeCount: 0,
                commentCount: 1,
                collectCount: 5,
                isCollect: false,
                imgThumbnail: 'images/test.jpg',
                authorName: 'レエイン',
                imgAuthor: 'images/test.jpg',
                isAuthor: true,
              ),
              ForumListItem(
                titleText: 'Hello World',
                likeState: 1,
                likeCount: 1,
                dislikeCount: 0,
                commentCount: 0,
                isCollect: true,
                collectCount: 1,
                summaryText: 'This is a Test2.',
                authorName: 'RA1N',
                imgAuthor: 'images/test.jpg',
                isAuthor: false,
              ),
              ForumListItem(
                titleText: '3',
                likeCount: 0,
                likeState: 2,
                dislikeCount: 1,
                collectCount: 0,
                commentCount: 0,
                isCollect: false,
                summaryText: 'This is a Test3.',
                authorName: 'RA1N',
                imgAuthor: 'images/test.jpg',
                isAuthor: false,
              ),
              ForumListItem(
                titleText: '4',
                likeState: 0,
                likeCount: 0,
                dislikeCount: 0,
                commentCount: 0,
                collectCount: 0,
                isCollect: false,
                summaryText: 'This is a Test.',
                authorName: 'RA1N',
                imgAuthor: 'images/test.jpg',
                isAuthor: false,
              ),ForumListItem(
                titleText: '5',
                likeState: 0,
                likeCount: 0,
                dislikeCount: 0,
                commentCount: 0,
                collectCount: 0,
                isCollect: false,
                summaryText: 'This is a Test.',
                authorName: 'RA1N',
                imgAuthor: 'images/test.jpg',
                isAuthor: false,
              ),ForumListItem(
                titleText: '6',
                likeState: 0,
                likeCount: 0,
                dislikeCount: 0,
                commentCount: 0,
                collectCount: 0,
                isCollect: false,
                summaryText: 'This is a Test.',
                authorName: 'RA1N',
                imgAuthor: 'images/test.jpg',
                isAuthor: false,
              ),ForumListItem(
                titleText: '7',
                likeState: 0,
                likeCount: 0,
                dislikeCount: 0,
                commentCount: 0,
                collectCount: 0,
                isCollect: false,
                summaryText: 'This is a Test.',
                authorName: 'RA1N',
                imgAuthor: 'images/test.jpg',
                isAuthor: false,
              )
            ],
          ),
        ),
      );
  }
}