import 'package:inforum/component/forumListItem.dart';
import 'package:dio/dio.dart';

class ForumListStream {
  //TODO:改写为HTTP请求获取
  static void getHttp() async {
    try {
      Response response;
      var data = {'name': 'jack'};
      response = await Dio().get('http://www.baidu.com');
      return print(response);
    } catch (e) {
      return print(e);
    }
  }

  static List<ForumListItem> getList() {
    List<ForumListItem> streamList = [
      ForumListItem(
        forumID: 1,
        titleText: '以下的内容仅供测试.',
        contentText:
            'This is a Test. All of the text below is used to test widget.'
            '\nThis is 2nd line. '
            '\nThis is 3rd line.'
            '\nThis is 4th line.',
        likeCount: 1000,
        likeState: 0,
        dislikeCount: 0,
        commentCount: 1,
        collectCount: 5,
        isCollect: false,
        imgThumbnail: 'images/test.jpg',
        authorName: 'レエイン',
        imgAuthor: 'images/test.jpg',
        isAuthor: true,
        time: '2020/12/19 17:16:16',
        tags: ['Test', '123', '456'],
      ),
      ForumListItem(
        forumID: 2,
        titleText: 'Hello World',
        likeState: 1,
        likeCount: 1,
        dislikeCount: 0,
        commentCount: 0,
        isCollect: true,
        collectCount: 1,
        contentText: 'This is a Test2.',
        authorName: 'RA1N',
        imgAuthor: 'images/test.jpg',
        isAuthor: false,
        time: '2020/12/18 14:21:55',
        tags: ['321', '654'],
      ),
      ForumListItem(
        forumID: 3,
        titleText: '3',
        likeCount: 0,
        likeState: 2,
        dislikeCount: 1,
        collectCount: 0,
        commentCount: 0,
        isCollect: false,
        contentText: 'This is a Test3.',
        authorName: 'RA1N',
        imgAuthor: 'images/test.jpg',
        isAuthor: false,
        time: '2020/12/17 14:21:55',
      ),
      ForumListItem(
        forumID: 4,
        titleText: '4',
        likeState: 0,
        likeCount: 0,
        dislikeCount: 0,
        commentCount: 0,
        collectCount: 0,
        isCollect: false,
        contentText: 'This is a Test.',
        authorName: 'RA1N',
        imgAuthor: 'images/test.jpg',
        isAuthor: false,
        time: '2020/11/30 14:21:55',
      ),
      ForumListItem(
        forumID: 5,
        titleText: '5',
        likeState: 0,
        likeCount: 0,
        dislikeCount: 0,
        commentCount: 0,
        collectCount: 0,
        isCollect: false,
        contentText: 'This is a Test.',
        authorName: 'RA1N',
        imgAuthor: 'images/test.jpg',
        isAuthor: false,
        time: '2020/11/29 14:21:55',
      ),
      ForumListItem(
        forumID: 6,
        titleText: '6',
        likeState: 0,
        likeCount: 0,
        dislikeCount: 0,
        commentCount: 0,
        collectCount: 0,
        isCollect: false,
        contentText: 'This is a Test.',
        authorName: 'RA1N',
        imgAuthor: 'images/test.jpg',
        isAuthor: false,
        time: '2019/11/28 14:21:55',
      ),
      ForumListItem(
        forumID: 7,
        titleText: '7',
        likeState: 0,
        likeCount: 0,
        dislikeCount: 0,
        commentCount: 0,
        collectCount: 0,
        isCollect: false,
        contentText: 'This is a Test.',
        authorName: 'RA1N',
        imgAuthor: 'images/test.jpg',
        isAuthor: false,
        time: '2018/11/27 14:21:55',
      )
    ];
    return streamList;
  }
}
