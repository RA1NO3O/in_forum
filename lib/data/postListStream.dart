import 'package:inforum/component/postListItem.dart';
import 'package:inforum/service/postStreamService.dart';

Future<List<PostListItem>> getList(String userID) async {
  List<PostListItem> psis = [];
  List<Recordset> psl = await getPostStream(userID);
  psl.asMap().forEach((index, value) {
    String t = value.tags;
    psis.add(PostListItem(
      postID: value.postId,
      titleText: value.title,
      contentText: value.bodyS,
      likeCount: value.likeCount,
      dislikeCount: value.dislikeCount,
      likeState: value.likeState ?? 0,
      commentCount: value.commentCount,
      collectCount: value.collectCount,
      isCollect: value.isCollected ?? false,
      imgURL: value.imageUrl ?? null,
      authorName: value.nickname,
      imgAuthor: value.avatarUrl ?? null,
      isAuthor: value.isEditor == 1 ? true : false,
      time: value.lastEditTime.toString(),
      tags: t != null ? t.split(',') : null,
      index: index,
    ));
  });
  return psis;
}
