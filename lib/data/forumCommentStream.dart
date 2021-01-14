import 'package:inforum/component/commentListItem.dart';

class ForumCommentStream{
  static List<CommentListItem> getComment(int forumID){
    if(forumID==1){
      return [
        CommentListItem(
          commenterAvatarURL: 'images/test.jpg',
          forumID: 1,
          commenterName: '评论者01',
          commentTime: '2020/12/19 17:23:00',
          content: 'Nice flutter!',
          commentTarget: '@ra1n7246',
        ),
        CommentListItem(
          commenterAvatarURL: 'images/test.jpg',
          forumID: 1,
          commenterName: '评论者02',
          commentTime: '2020/12/19 17:22:00',
          content: 'this is a comment.',
          commentTarget: '@dec16th',
        ),
      ];
    }
    if(forumID==2){
      return[
        CommentListItem(
          commenterAvatarURL: 'images/test.jpg',
          forumID: 2,
          commenterName: '评论者03',
          commentTime: '2020/12/19 17:21:00',
          content: 'Hello RA1N',
          commentTarget: '@ra1n7246',
        )
      ];
    }
    return null;
  }
}