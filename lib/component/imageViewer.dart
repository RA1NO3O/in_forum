import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/service/imageDownloadService.dart';
import 'package:inforum/service/imageShareService.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final String? imgURL;
  final Widget? loadingChild;
  final Decoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String? heroTag;

  const ImageViewer({
    this.loadingChild,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.heroTag,
    this.imgURL,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        elevation: 1,
        backgroundColor: Colors.transparent,
        actions: [
          Builder(
            builder: (bc) => IconButton(
                icon: Icon(Icons.download_rounded),
                onPressed: () {
                  AppUtil.saveImage(imgURL);
                  ScaffoldMessenger.of(bc)
                      .showSnackBar(doneSnackBar('  图片已保存至/Pictures/.'));
                }),
          ),
          IconButton(
            icon: Icon(Icons.share_rounded),
            onPressed: () => shareNetworkImage(imgURL!),
          )
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
                imageProvider: CachedNetworkImageProvider(imgURL!),
                backgroundDecoration: backgroundDecoration as BoxDecoration?,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered,
                heroAttributes: PhotoViewHeroAttributes(tag: heroTag!),
                enableRotation: false, //禁止旋转
              ),
            ),
          ],
        ),
      ),
    );
  }
}
