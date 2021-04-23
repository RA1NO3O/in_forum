import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

shareNetworkImage(String imgURL) async {
  var tempImage = await DefaultCacheManager().getSingleFile(imgURL);
  Uint8List finalPngBytes = tempImage.readAsBytesSync();
  final tempDir = await getTemporaryDirectory();
  final p = Directory(tempDir.path + '/tempImage.png');
  final imageFile = File(p.path);
  await imageFile.writeAsBytes(finalPngBytes);
  if(!Platform.isWindows){
    Share.shareFiles([imageFile.path]);
  }else{
    throw('Desktop platform doesn\'t support share right now.');
  }
}
shareTexts(String txt) async {
  Share.share(txt);
}
