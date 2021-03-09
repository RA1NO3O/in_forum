import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/component/statefulDialog.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/loginService.dart';
import 'package:inforum/subPage/settingsPage/editProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountSettingsPage();
  }
}

class _AccountSettingsPage extends State<AccountSettingsPage> {
  GlobalKey<FormState> _fk = GlobalKey<FormState>();
  late SharedPreferences sp;
  var userID;
  String? userName = 'unknown';
  String? nickName = 'unknown';
  String? avatarURL;
  TextEditingController userNameController = new TextEditingController();

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
                Builder(
                  builder: (BuildContext bc) => ListTile(
                    leading: Icon(Icons.account_box_rounded),
                    shape: roundedRectangleBorder,
                    title: Text('用户名'),
                    subtitle: Text(userName!),
                    onTap: () async {
                      userNameController.text = userName!;
                      final result = await showDialog(
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
                          content: Form(
                            key: _fk,
                            child: TextFormField(
                              autofocus: true,
                              validator: (value) =>
                                  (userNameController.text == userName) ||
                                          userNameController.text.isEmpty
                                      ? '请使用新的用户名.'
                                      : null,
                              onEditingComplete: () async {
                                await onUserNameEditDone(bc);
                              },
                              controller: userNameController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                            ),
                          ),
                          actions: [
                            TextButton.icon(
                                onPressed: () async {
                                  await onUserNameEditDone(bc);
                                },
                                icon: Icon(Icons.done),
                                label: Text('完成'))
                          ],
                        ),
                      );
                      switch (result) {
                        case '0':
                          ScaffoldMessenger.of(bc)
                              .showSnackBar(doneSnackBar('用户名已修改.\n'
                                  '  今后,请使用修改后的用户名进行登录.'));
                          break;
                        case '1':
                          ScaffoldMessenger.of(bc)
                              .showSnackBar(errorSnackBar('修改失败,\n'
                                  '  该用户名可能已存在.'));
                      }
                    },
                  ),
                ),
                Builder(
                  builder: (bc) => ListTile(
                    leading: Icon(Icons.emoji_people),
                    shape: roundedRectangleBorder,
                    title: Text('个人资料'),
                    subtitle: Text('修改可供他人查看的个人资料'),
                    onTap: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (bc) => EditProfilePage(
                                    userID: userID,
                                  )));
                      if (result == 0) {
                        ScaffoldMessenger.of(bc)
                            .showSnackBar(doneSnackBar('个人资料已修改.'));
                      }
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.all(10),
                  child: Text(
                    '危险区域',
                    style: new TextStyle(color: Colors.red),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  width: 350,
                  height: 45,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.delete_forever_rounded),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.redAccent),
                    ),
                    label: Text('删除账户'),
                    //TODO:删除账户
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  onUserNameEditDone(BuildContext bc) async {
    if (_fk.currentState!.validate()) {
      bool r = await tryEditUserName(userNameController.text);
      if (r) {
        Navigator.pop(bc, '0');
      } else {
        Navigator.pop(bc, '1');
      }
    }
  }

  void getUserInfo() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      userID = sp.getInt('userID');
      userName = sp.getString('userName');
      nickName = sp.getString('nickName');
      avatarURL = sp.getString('avatarURL');
    });
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
