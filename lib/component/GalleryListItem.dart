import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inforum/service/randomGenerator.dart';

import 'imageViewer.dart';

class GalleryListItem extends StatefulWidget {
  final String? imgURL;
  final int? postID;
  final String? titleText;
  final String? contentText;
  final int? likeCount;
  final int? dislikeCount;
  final int? likeState;
  final int? commentCount;
  final int? collectCount;
  final bool? isCollect;
  final String? authorName;
  final String? imgAuthor;
  final String? time;
  final List<String>? tags;
  final int? index;
  final bool? isAuthor;

  const GalleryListItem(
      {Key? key,
      this.imgURL,
      this.postID,
      this.titleText,
      this.contentText,
      this.likeCount,
      this.dislikeCount,
      this.likeState,
      this.commentCount,
      this.collectCount,
      this.isCollect,
      this.authorName,
      this.imgAuthor,
      this.time,
      this.tags,
      this.index,
      this.isAuthor})
      : super(key: key);

  @override
  _GalleryListItemState createState() => _GalleryListItemState();
}

class _GalleryListItemState extends State<GalleryListItem> {
  String _imgHeroTag = getRandom(6);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Hero(
            child: Material(
              // elevation: 1,
              color: Colors.transparent,
              child: Ink.image(
                image: widget.imgURL != null
                    ? CachedNetworkImageProvider(widget.imgURL!)
                    : Center(child: Icon(Icons.broken_image_rounded)) as ImageProvider<Object>,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                child: InkWell(
                  onTap: () {
                    if (widget.imgURL != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (bc) => ImageViewer(
                                    imgURL: widget.imgURL,
                                    heroTag: _imgHeroTag,
                                  )));
                    }
                  },
                ),
              ),
            ),
            tag: _imgHeroTag,
          ),
        ],
      );
}
