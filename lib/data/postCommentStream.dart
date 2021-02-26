import 'package:inforum/component/commentListItem.dart';
import 'package:inforum/service/postCommentService.dart';

List<CommentListItem> pcis = [];

Future<List<CommentListItem>> getComment(int postID, int userID) async {
  pcis.clear();
  List<Recordset> pcl = await getPostComment(postID,userID);
  pcl.forEach((rs) {
    pcis.add(CommentListItem(
      commenterAvatarURL: rs.avatarUrl,
      postID: rs.postId,
      commenterName: rs.nickname,
      commentTime: rs.lastEditTime.toString(),
      content: rs.body,
      commentTarget: rs.username,
      likeState: rs.likeState?? 0,
      likeCount: rs.likeCount,
    ));
  });
  pcis.sort((a,b)=>b.postID.compareTo(a.postID)); //按ID排序,ID数字越大越新
  return pcis;
}
