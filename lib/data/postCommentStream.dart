import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:inforum/component/commentListItem.dart';
import 'package:inforum/service/postCommentService.dart';
import 'package:inforum/service/postDetailService.dart';

List<CommentListItem> pcis = [];
Future<List<Widget>> getComment(int? postID, int? userID) async {
  pcis.clear();

  List<CommentRecordset> pcl = (await getPostComment(postID, userID))!;
  var pd = await getPostDetail(postID);
  pcl.forEach((rs) {
    pcis.add(CommentListItem(
      commenterAvatarURL: rs.avatarUrl,
      postID: rs.postId,
      commenterName: rs.nickname,
      commentTime: rs.lastEditTime.toString(),
      content: rs.body,
      commentTarget: pd!.username,
      imgURL: rs.imageUrl,
      likeState: rs.likeState ?? 0,
      likeCount: rs.likeCount,
      isAuthor: rs.isEditor == 1 ? true : false,
      editorID: rs.editorId,
    ));
  });
  pcis.sort((a, b) => b.postID!.compareTo(a.postID!)); //按ID排序,ID数字越大越新
  return pcis;
}
