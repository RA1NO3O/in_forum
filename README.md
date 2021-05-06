
# inforum_app

A cross-platform forum application, the service are based on Microsoft SQL Server, NodeJs(with express) and aliyun OSS server.

- 🚪Portal to [Inforum_API](http://github.com/RA1NO3O/Inforum_API)
- 🔵Come check my brother app! It's using iOS-style UI layout. [Inforum_Alter](https://github.com/RA1NO3O/Inforum_Alter)

This App can automaticlly fit your screen to display information, with this app, you can easily make a post, leave a comment or share media contents on anywhere by any device.

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
~~You should use [hover](https://github.com/go-flutter-desktop/hover)(which is powered by Go) tools with flutter engine to run and build app, the platform dedicated function(such as filePicker) will need it to work on Desktop.And you'd better follow the step by link:~~ https://github.com/go-flutter-desktop/hover/blob/master/README.md
> Now the app has migrated to the official file_selector plugin, no need to worry about. Thanks to the flutter community❤.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Screenshots
![android](https://user-images.githubusercontent.com/25654559/115859025-3782c780-a462-11eb-9b72-214b569c379b.png)
![截屏2021-04-29 15 02 45](https://user-images.githubusercontent.com/25654559/116516015-a4cda700-a8ff-11eb-870a-2d866c7995f5.png)
![image](https://user-images.githubusercontent.com/25654559/115859512-e1faea80-a462-11eb-900e-c8ffeb0d99de.png)
![截屏2021-04-26 22 20 11](https://user-images.githubusercontent.com/25654559/116098439-a91a7a00-a6dd-11eb-871d-b64183abe195.png)

