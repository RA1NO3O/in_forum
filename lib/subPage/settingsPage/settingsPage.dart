import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inforum/subPage/settingsPage/accountSettingsPage.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPage();
  }
}

class _SettingsPage extends State<SettingsPage> {
  RoundedRectangleBorder roundedRectangleBorder =
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));

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
                      Navigator.push(context, MaterialPageRoute(
                          builder: (bc) => AccountSettingsPage()));
                    },
                  ),
                  ListTile(
                    shape: roundedRectangleBorder,
                    leading: Icon(Icons.notifications_rounded),
                    title: Text('通知'),
                    onTap: () {},
                  ),
                  ListTile(
                    shape: roundedRectangleBorder,
                    leading: Icon(Icons.smartphone),
                    title: Text('显示'),
                    onTap: () {},
                  ),
                  Divider(thickness: 1),
                  ListTile(
                    shape: roundedRectangleBorder,
                    leading: Icon(Icons.info_rounded),
                    title: Text('关于 Inforum'),
                    onTap: () =>
                        showAboutDialog(
                          context: context,
                          applicationVersion: '1.0.0',
                          applicationLegalese: '最后编译日期:2020/12/8 15:46\n'
                              '开发者网站:\n'
                              'https://github.com/RA1NO3O/\n'
                              '项目网站:\n'
                              'https://github.com/RA1NO3O/Inforum',
                          //TODO:放置app图标
                          applicationIcon: Icon(
                            Icons.info_rounded,
                            size: 30,
                          ),
                        ),
                  ),
                  Divider(thickness: 1),
                ],
              ))
        ],
      ),
    );
  }
}
