import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/service/imageDownloadService.dart';
import 'package:inforum/service/imageShareService.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final int? mode;
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
    this.mode,
  });

  @override
  Widget build(BuildContext context) {
    String? _newImgURL;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        elevation: 1,
        backgroundColor: Colors.transparent,
        actions: [
          mode == 1
              ? Builder(
                  builder: (bc) => IconButton(
                      tooltip: '设定并上传图片',
                      icon: Icon(Icons.done_rounded),
                      onPressed: () {
                        Navigator.pop(bc, _newImgURL);
                      }),
                )
              : Builder(
                  builder: (bc) => IconButton(
                      tooltip: '保存图片',
                      icon: Icon(Icons.download_rounded),
                      onPressed: () async {
                        final r = await AppUtil.saveImage(imgURL);
                        if (r != null) {
                          ScaffoldMessenger.of(bc)
                              .showSnackBar(doneSnackBar('图片已保存.'));
                        }
                      }),
                ),
          IconButton(
            tooltip: '分享',
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
