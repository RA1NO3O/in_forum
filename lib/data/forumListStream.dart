import 'package:inforum/component/forumListItem.dart';
import 'package:inforum/service/postStateService.dart';
import 'package:inforum/service/postStreamService.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<ForumListItem> demoList = [
  ForumListItem(
    forumID: 1,
    titleText: '以下的内容仅供测试.',
    contentText: 'This is a Test. All of the text below is used to test widget.'
        '\nThis is 2nd line. '
        '\nThis is 3rd line.'
        '\nThis is 4th line.',
    likeCount: 1000,
    likeState: 0,
    dislikeCount: 0,
    commentCount: 1,
    collectCount: 5,
    isCollect: false,
    imgURL: 'images/test.jpg',
    authorName: 'レエイン',
    imgAuthor: 'https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/25654559.jpg?OSSAccessKeyId=LTAI4G3BU8muaDoumt3NKL2N&Expires=1612450315&Signature=GqLVircVhbWwSax%2Fbc7j00ZqO2o%3D',
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
    imgAuthor: 'https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/25654559.jpg?OSSAccessKeyId=LTAI4G3BU8muaDoumt3NKL2N&Expires=1612450315&Signature=GqLVircVhbWwSax%2Fbc7j00ZqO2o%3D',
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
    imgAuthor:
        'https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/25654559.jpg?OSSAccessKeyId=LTAI4G3BU8muaDoumt3NKL2N&Expires=1612450315&Signature=GqLVircVhbWwSax%2Fbc7j00ZqO2o%3D',
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
    imgAuthor: 'https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/25654559.jpg?OSSAccessKeyId=LTAI4G3BU8muaDoumt3NKL2N&Expires=1612450315&Signature=GqLVircVhbWwSax%2Fbc7j00ZqO2o%3D',
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
    imgAuthor: 'https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/25654559.jpg?OSSAccessKeyId=LTAI4G3BU8muaDoumt3NKL2N&Expires=1612450315&Signature=GqLVircVhbWwSax%2Fbc7j00ZqO2o%3D',
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
    imgAuthor: 'https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/25654559.jpg?OSSAccessKeyId=LTAI4G3BU8muaDoumt3NKL2N&Expires=1612450315&Signature=GqLVircVhbWwSax%2Fbc7j00ZqO2o%3D',
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
    imgAuthor: 'https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/25654559.jpg?OSSAccessKeyId=LTAI4G3BU8muaDoumt3NKL2N&Expires=1612450315&Signature=GqLVircVhbWwSax%2Fbc7j00ZqO2o%3D',
    isAuthor: false,
    time: '2018/11/27 14:21:55',
  ),
];
List<ForumListItem> psis = [];

Future<List<ForumListItem>> getList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userID = prefs.getString('userId');
  List<Recordset> psl = await getPostStream();

  psl.forEach((rs) async {
    PostStateRecordset state = await getPostState(userID, rs.postId);
    print('postID:${rs.postId}');
    String t = rs.tags;
    psis.add(ForumListItem(
      forumID: rs.postId,
      titleText: rs.title,
      contentText: rs.bodyS,
      likeCount: rs.likeCount,
      dislikeCount: rs.dislikeCount,
      likeState: state != null ? state.likeState : 0,
      commentCount: rs.commentCount,
      collectCount: rs.collectCount,
      isCollect: state != null ? state.isCollected : false,
      imgURL: rs.imageUrl != null ? rs.imageUrl : null,
      authorName: rs.nickname,
      imgAuthor: rs.avatarUrl != null ? rs.avatarUrl : null,
      isAuthor: rs.editorId.toString() == userID,
      time: rs.lastEditTime.toString(),
      tags: t != null ? t.split(',') : null,
    ));
  });

  return psis;
}
