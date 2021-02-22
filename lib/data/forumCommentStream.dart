import 'package:inforum/component/commentListItem.dart';
import 'package:inforum/service/postCommentService.dart';

List<CommentListItem> pcis = [];

Future<List<CommentListItem>> getComment(int postID) async {
  pcis.clear();
  List<Recordset> pcl = await getPostComment(postID);
  pcl.forEach((rs) {
    pcis.add(CommentListItem(
      commenterAvatarURL: rs.avatarUrl,
      postID: rs.postId,
      commenterName: rs.nickname,
      commentTime: rs.lastEditTime.toString(),
      content: rs.body,
      commentTarget: rs.username,
    ));
  });
  pcis.sort((a,b)=>b.postID.compareTo(a.postID)); //按ID排序,ID数字越大越新
  return pcis;
}
