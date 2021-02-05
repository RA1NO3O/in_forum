import 'package:inforum/component/commentListItem.dart';
import 'package:inforum/service/postCommentService.dart';

List<CommentListItem> pcis = [];

Future<List<CommentListItem>> getComment(int forumID) async {
  pcis.clear();
  List<Recordset> pcl = await getPostComment(forumID);
  pcl.forEach((rs) {
    pcis.add(CommentListItem(
      commenterAvatarURL: rs.avatarUrl,
      forumID: rs.postId,
      commenterName: rs.nickname,
      commentTime: rs.lastEditTime.toString(),
      content: rs.body,
      commentTarget: rs.username,
    ));
  });
  pcis.sort((a,b)=>b.forumID.compareTo(a.forumID)); //按ID排序,ID数字越大越新
  return pcis;
}
