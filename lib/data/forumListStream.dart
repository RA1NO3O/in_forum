import 'package:inforum/component/forumListItem.dart';
import 'package:inforum/service/postStateService.dart';
import 'package:inforum/service/postStreamService.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
