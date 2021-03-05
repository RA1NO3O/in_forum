import 'package:inforum/component/postListItem.dart';
import 'package:inforum/service/postCollectionService.dart';

List<PostListItem> pcls = [];
Future<List<PostListItem>> getCollectionList(String userID) async {
  pcls.clear();
  List<CollectionRecordset> pcl = await getPostCollection(userID);
  pcl.forEach((rs) {
    String t = rs.tags;
    pcls.add(PostListItem(
      postID: rs.postId,
      titleText: rs.title,
      contentText: rs.bodyS,
      likeCount: rs.likeCount,
      dislikeCount: rs.dislikeCount,
      likeState: rs.likeState ?? 0,
      commentCount: rs.commentCount,
      collectCount: rs.collectCount,
      isCollect: rs.isCollected ?? false,
      imgURL: rs.imageUrl ?? null,
      authorName: rs.nickname,
      isAuthor: rs.isEditor == 1 ? true : false,
      imgAuthor: rs.avatarUrl ?? null,
      time: rs.collectTime.toString(),
      tags: t != null ? t.split(',') : null,
    ));
  });
  return pcls;
}
