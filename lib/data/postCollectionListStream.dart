import 'package:inforum/component/postListItem.dart';

class ForumCollectionListStream {
  //
  static List<PostListItem> getList() {
    return [
      PostListItem(
        postID: 1,
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
        imgURL: 'images/default_avatar.png',
        authorName: 'レエイン',
        imgAuthor: 'images/default_avatar.png',
        isAuthor: true,
        time: '2020/12/05 15:02:16',
        tags: ['Test', '123', '456'],
      ),
    ];
  }
}
