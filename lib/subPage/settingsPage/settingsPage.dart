import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inforum/subPage/settingsPage/logPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'displaySettingsPage.dart';
import 'notificationSettingsPage.dart';
import 'accountSettingsPage.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPage();
  }
}

class _SettingsPage extends State<SettingsPage> {
  RoundedRectangleBorder roundedRectangleBorder =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
  int _counter = 0;
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: ListView(
        children: [
          Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 5),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_rounded),
                    shape: roundedRectangleBorder,
                    title: Text('账号'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (bc) => AccountSettingsPage()));
                    },
                  ),
                  ListTile(
                    shape: roundedRectangleBorder,
                    leading: Icon(Icons.notifications_rounded),
                    title: Text('通知'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (bc) => NotificationSettingsPage())),
                  ),
                  ListTile(
                    shape: roundedRectangleBorder,
                    leading: Icon(Icons.smartphone),
                    title: Text('显示'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (bc) => DisplaySettingsPage())),
                  ),
                  Divider(thickness: 1),
                  ListTile(
                    shape: roundedRectangleBorder,
                    leading: Icon(Icons.info_rounded),
                    title: Text('关于 Inforum'),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationVersion: '1.0.4',
                      applicationLegalese: '最后编译日期:2021/5/9 20:18\n'
                          '开发者网站:\n'
                          'https://github.com/RA1NO3O/\n'
                          '项目网站:\n'
                          'https://github.com/RA1NO3O/Inforum',
                      applicationIcon: Icon(
                        Icons.info_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                  Divider(thickness: 1),
                  _counter < 3
                      ? IconButton(
                          icon: Icon(Icons.developer_mode),
                          onPressed: () {
                            setState(() {
                              _counter++;
                            });
                          },
                        )
                      : ListTile(
                          leading: Icon(Icons.manage_search),
                          title: Text('查看服务器日志'),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (bc) => LogPage()));
                          },
                        )
                ],
              ))
        ],
      ),
    );
  }

  void _init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _counter = sp.getBool('isDeveloperMode') == true ? 3 : 0;
  }

  void writeDeveloperMode() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('isDeveloperMode', true);
  }
}
