import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/component/statefulDialog.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/loginService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountSettingsPage();
  }
}

class _AccountSettingsPage extends State<AccountSettingsPage> {
  SharedPreferences sp;
  var userID;
  String userName = 'unknown';

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('账号设置'),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.account_box_rounded),
                  shape: roundedRectangleBorder,
                  title: Text('用户名'),
                  subtitle: Text(userName),
                  trailing: Icon(Icons.more_horiz_rounded),
                  onTap: () async {
                    bool i;
                    TextEditingController userNameController =
                        new TextEditingController();
                    userNameController.addListener(() {
                      setState(() {
                        i = userNameController.text.trim().isNotEmpty;
                      });
                    });
                    userNameController.text = userName;
                    await showDialog(
                      context: context,
                      builder: (bc) => StatefulDialog(
                        title: Row(
                          //确保对话框不会占满空间
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.border_color, size: 32),
                            Text('   输入用户名.')
                          ],
                        ),
                        content: TextField(
                          autofocus: true,
                          controller: userNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        actions: [
                          FlatButton.icon(
                              onPressed:
                                  (userNameController.text != userName) && i
                                      ? () async {
                                          bool r = await tryEditUserName(
                                              userNameController.text);
                                          if (r) {
                                            Scaffold.of(context).showSnackBar(
                                                doneSnackBar('用户名修改成功'));
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                                errorSnackBar('修改失败,该用户名已存在.'));
                                          }
                                          Navigator.pop(context);
                                        }
                                      : null,
                              icon: Icon(Icons.done),
                              label: Text('完成'))
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.all(10),
                  child: Text(
                    '危险区域',
                    style: new TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void getUserInfo() async {
    sp = await SharedPreferences.getInstance();
    userName = sp.getString('userName');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> tryEditUserName(String newUserName) async {
    if (await searchUser(userName) == null) {
      Response res = await Dio().post('$apiServerAddress/editUserName/',
          options: new Options(contentType: Headers.formUrlEncodedContentType),
          data: {
            "userID": sp.getInt('userID'),
            "userName": newUserName,
          });
      if (res.data == 'success.') {
        setState(() {
          userName = newUserName;
        });
        return true;
      }
    }
    return false;
  }
}
