import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:toast/toast.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    this.imageProvider,
    this.loadingChild,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.heroTag,
  });

  final ImageProvider imageProvider;
  final Widget loadingChild;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        elevation: 1,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate_outlined),
            onPressed: () {
              Toast.show('图片已保存.', context, duration: 2);
            },
          ),
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: PhotoView(
                imageProvider: imageProvider,
                backgroundDecoration: backgroundDecoration,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered,
                heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
                enableRotation: false, //禁止旋转
              ),
            ),
          ],
        ),
      ),
    );
  }
}
