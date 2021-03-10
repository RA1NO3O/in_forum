# inforum_app

A cross-platform forum application, the service are based on Microsoft SQL Server, NodeJs(with express) and aliyun OSS server.

- 🚪Portal to [Inforum_API](http://github.com/RA1NO3O/Inforum_API)

This App can automaticlly fit your screen to display information, with this app, you can easily make a post, leave a comment or share media contents on anywhere.

Project codeFile has been updated to the fresh flutter2.0 and migrated to null-safety so you're good to go.

## Getting Started
This project is a Flutter application.
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

If you want to build or run this app, you should make a webConfig file by your own first.
- Insert code:
```
// make file as /lib/data/webConfig.dart
String apiServerAddress = '';
String ossAccessKeyID = '';
String ossAccessKeySecret = '';
String ossServer = '';
String bucket = '';
// 发送请求的url,根据你自己设置的是哪个城市的
String url = 'https://$bucket.oss-cn-hangzhou.aliyuncs.com';
// 过期时间
String expiration = '2025-01-01T12:00:00.000Z';
```

## Run or build on Desktop
You should use [hover](https://github.com/go-flutter-desktop/hover)(which is powered by Go) tools with flutter engine to run and build app, the platform dedicated function(such as filePicker) will need it to work on Desktop.And you'd better follow the step by link: https://github.com/go-flutter-desktop/hover/blob/master/README.md

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Screenshots
# ![screenshot_1]
# ![screenshot_2]
# ![screenshot_3]
[screenshot_1]: https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE%202021-03-09%20224645.png
[screenshot_2]: https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/%E5%B1%8F%E5%B9%95%E6%88%AA%E5%9B%BE%202021-03-09%20224838.png
[screenshot_3]: https://ra1nbucket.oss-cn-hangzhou.aliyuncs.com/images/Screenshot_2021-02-10-18-39-46-503_org.ra1n.Inforum.jpg

A 100% NT by RA1NO3O😎
