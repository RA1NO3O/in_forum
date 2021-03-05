import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/randomGenerator.dart';

Future<String> uploadFile(File file) async {
  final String url = await UploadOss.upload(file: file);
  return url;
}

class UploadOss {
  // 过期时间
  static String expiration = '2025-01-01T12:00:00.000Z';

  /// @params file 要上传的文件对象
  /// @params rootDir 阿里云oss设置的根目录文件夹名字
  /// @param fileType 文件类型例如jpg,mp4等
  /// @param callback 回调函数我这里用于传cancelToken，方便后期关闭请求
  /// @param onSendProgress 上传的进度事件

  static Future<String> upload(
      {File file,
      String rootDir = 'images',
      String fileType,
      Function onSendProgress}) async {
    String policyText =
        '{"expiration": "$expiration","conditions": [{"bucket": "$bucket" },["content-length-range", 0, 1048576000]]}';

    // 获取签名
    String signature = getSignature(policyText);

    BaseOptions options = new BaseOptions();
    options.responseType = ResponseType.plain;

    //创建dio对象
    Dio dio = new Dio(options);
    // 生成oss的路径和文件名我这里目前设置的是moment/test.mp4
    String pathName =
        '$rootDir/${getRandom(12)}.${fileType == null ? getFileType(file.path) : fileType}';

    // 请求参数的form对象
    FormData data = new FormData.fromMap({
      'key': pathName,
      'policy': getSplicyBase64(policyText),
      'OSSAccessKeyId': ossAccessKeyID,
      'success_action_status': '200', //让服务端返回200，不然，默认会返回204
      'signature': signature,
      'contentType': 'multipart/form-data',
      'file': MultipartFile.fromFileSync(file.path),
    });

    Response response;
    try {
      // 发送请求
      response = await dio.post(url, data: data, cancelToken: CancelToken());
      // 成功后返回文件访问路径
      print(response.statusMessage);
      return '$url/$pathName';
    } catch (e) {
      throw (e.message);
    }
  }

  /*
  * 根据图片本地路径获取图片名称
  * */
  static String getImageNameByPath(String filePath) {
    // ignore: null_aware_before_operator
    return filePath?.substring(
        // ignore: null_aware_before_operator
        filePath?.lastIndexOf("/") + 1, filePath?.length);
  }

  /// 获取文件类型
  static String getFileType(String path) {
    List<String> array = path.split('.');
    return array[array.length - 1];
  }

  /// 获取日期
  static String getDate() {
    DateTime now = DateTime.now();
    return '${now.year}${now.month}${now.day}';
  }

  // 获取police的base64
  static getSplicyBase64(String policyText) {
    //进行utf8编码
    List<int> policyTextUtf8 = utf8.encode(policyText);
    //进行base64编码
    String policyBase64 = base64.encode(policyTextUtf8);
    return policyBase64;
  }

  /// 获取签名
  static String getSignature(String policyText) {
    //进行utf8编码
    List<int> policyTextUtf8 = utf8.encode(policyText);
    //进行base64编码
    String policyBase64 = base64.encode(policyTextUtf8);
    //再次进行utf8编码
    List<int> policy = utf8.encode(policyBase64);
    //进行utf8 编码
    List<int> key = utf8.encode(ossAccessKeySecret);
    //通过hmac,使用sha1进行加密
    List<int> signaturePre = Hmac(sha1, key).convert(policy).bytes;
    //最后一步，将上述所得进行base64 编码
    String signature = base64.encode(signaturePre);
    return signature;
  }
}
