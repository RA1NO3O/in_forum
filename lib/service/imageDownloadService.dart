/// 使用 File api
import 'dart:io';

/// 使用 Uint8List 数据类型
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';

/// 使用 DefaultCacheManager 类（可能无法自动引入，需要手动引入）
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:inforum/service/randomGenerator.dart';
import 'package:path_provider/path_provider.dart';

/// 授权管理
import 'package:permission_handler/permission_handler.dart';

/// 图片缓存管理
import 'package:cached_network_image/cached_network_image.dart';

class AppUtil {
  /// 保存图片到相册
  ///
  /// 默认为下载网络图片，如需下载资源图片，需要指定 [isAsset] 为 `true`。
  static saveImage(String? imageUrl, {bool isAsset: false}) async {
    try {
      /// 保存的图片数据
      Uint8List imageBytes;
      File file;
      if (isAsset == true) {
        /// 保存资源图片
        ByteData bytes = await rootBundle.load(imageUrl!);
        imageBytes = bytes.buffer.asUint8List();
      } else {
        /// 保存网络图片
        CachedNetworkImage image = CachedNetworkImage(imageUrl: imageUrl!);
        DefaultCacheManager manager =
            image.cacheManager as DefaultCacheManager? ?? DefaultCacheManager();
        Map<String, String>? headers = image.httpHeaders;
        file = await manager.getSingleFile(
          image.imageUrl,
          headers: headers,
        );
        imageBytes = await file.readAsBytes();
      }

      /// 权限检测
      if ((!Platform.isWindows) && (!Platform.isLinux) && (!Platform.isMacOS)) {
        PermissionStatus storageStatus = await Permission.storage.status;
        if (storageStatus != PermissionStatus.granted) {
          storageStatus = await Permission.storage.request();
          if (storageStatus != PermissionStatus.granted) {
            throw '无法存储图片，请先授权！';
          }
        }

        // 保存图片
        var appDocDir = await getTemporaryDirectory();
        String savePath = appDocDir.path + '${getRandom(8)}.png';
        await Dio().download(imageUrl, savePath);
        final result = await ImageGallerySaver.saveFile(savePath);
        print(result);
        return result;
      } else {
        final path = await getSavePath(acceptedTypeGroups: <XTypeGroup>[
          XTypeGroup(
              label: '图片文件', extensions: ['png'], mimeTypes: ['image/png'])
        ]);
        final name = "${getRandom(8)}.png";
        final file = XFile.fromData(imageBytes, name: name);
        if (path != null) {
          await file.saveTo(path);
          print(path);
          return path;
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
