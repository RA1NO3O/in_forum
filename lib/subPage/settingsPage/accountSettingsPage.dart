import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/component/statefulDialog.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/main.dart';
import 'package:inforum/service/loginService.dart';
import 'package:inforum/subPage/settingsPage/changePasswordPage.dart';
import 'package:inforum/subPage/settingsPage/deleteAccountPage.dart';
import 'package:inforum/subPage/settingsPage/editProfile.dart';
import 'package:inforum/subPage/supportPage/forgetPasswordPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountSettingsPage();
  }
}

class _AccountSettingsPage extends State<AccountSettingsPage> {
  GlobalKey<FormState> _fk = GlobalKey<FormState>();
  GlobalKey<FormState> _pk = GlobalKey<FormState>();

  int? userID;
  String? userName = 'unknown';
  String? nickName = 'unknown';
  String? avatarURL;
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

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
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Form(
                                key: _fk,
                                child: TextFormField(
                                  autofocus: true,
                                  validator: (value) => userNameController
                                              .text ==
                                          userName
                                      ? '请使用新的用户名.'
                                      : userNameController.text.trim().isEmpty
                                          ? '用户名是必要的.'
                                          : null,
                                  onEditingComplete: () async {
                                    await onUserNameEditDone(bc);
                                  },
                                  controller: userNameController,
                                  decoration:
                                      InputDecoration(border: inputBorder),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  '您的用户名会用于登录和用户区分,并且显示在您的昵称旁.',
                                  style: invalidTextStyle,
                                ),
                              ),
                            ],
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
                    subtitle: Text('点按以修改供他人查看的个人资料.'),
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
                Builder(
                  builder: (BuildContext bc) => ListTile(
                    leading: Icon(Icons.lock_rounded),
                    shape: roundedRectangleBorder,
                    title: Text('密码'),
                    subtitle: Text('点按以修改密码.'),
                    onTap: () async {
                      passwordController.text = '';
                      final result = await showDialog(
                        context: context,
                        builder: (bc) => StatefulDialog(
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_rounded, size: 32),
                              Text('   确认目前的密码')
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Form(
                                key: _pk,
                                child: TextFormField(
                                  obscureText: true,
                                  autofocus: true,
                                  validator: (value) =>
                                      passwordController.text.isEmpty
                                          ? '密码是必需的.'
                                          : null,
                                  textInputAction: TextInputAction.done,
                                  onEditingComplete: () async {
                                    if (_pk.currentState!.validate()) {
                                      var r = await tryLogin(
                                          userName!, passwordController.text);
                                      if (r != null) {
                                        Navigator.pop(bc, 'correct.');
                                      } else {
                                        Navigator.pop(bc, 'incorrect.');
                                      }
                                    }
                                  },
                                  controller: passwordController,
                                  decoration:
                                      InputDecoration(border: inputBorder),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  '验证您的身份.',
                                  style: invalidTextStyle,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton.icon(
                              onPressed: () =>
                                  Navigator.pop(bc, 'forgetPassword'),
                              icon: Icon(Icons.help_center_rounded),
                              label: Text('忘记密码?'),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                if (_pk.currentState!.validate()) {
                                  var r = await tryLogin(
                                      userName!, passwordController.text);
                                  if (r != null) {
                                    Navigator.pop(bc, 'correct.');
                                  } else {
                                    Navigator.pop(bc, 'incorrect.');
                                  }
                                }
                              },
                              icon: Icon(Icons.arrow_forward_rounded),
                              label: Text('继续'),
                            ),
                          ],
                        ),
                      );
                      if (result == 'correct.') {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordPage(
                              userID: userID!,
                            ),
                          ),
                        );
                        switch (result) {
                          case 'success.':
                            ScaffoldMessenger.of(bc)
                                .showSnackBar(doneSnackBar('密码修改成功.'));
                            break;

                          case 'error.':
                            ScaffoldMessenger.of(bc)
                                .showSnackBar(errorSnackBar('密码修改失败!'));
                            break;

                          default:
                            ScaffoldMessenger.of(bc)
                                .showSnackBar(errorSnackBar('用户取消了密码修改.'));
                            break;
                        }
                      } else if (result == 'forgetPassword') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgetPasswordPage()));
                      } else if (result == 'incorrect.') {
                        ScaffoldMessenger.of(bc)
                            .showSnackBar(errorSnackBar('密码错误.'));
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
                  child: Builder(
                    builder: (bc) => ElevatedButton.icon(
                      icon: Icon(Icons.delete_forever_rounded),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
                      ),
                      label: Text('删除账户'),
                      onPressed: () async {
                        final r = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (bc) => DeleteAccountPage(userID: userID!),
                          ),
                        );
                        switch (r) {
                          case 'success.':
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (bc) => MainPage(state: 0)));
                            break;
                          default:
                            ScaffoldMessenger.of(bc)
                                .showSnackBar(errorSnackBar('账户删除失败.'));
                        }
                      },
                    ),
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
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      userID = sp.getInt('userID');
      userName = sp.getString('userName');
      nickName = sp.getString('nickName');
      avatarURL = sp.getString('avatarURL');
    });
    print(userName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> tryEditUserName(String newUserName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (await searchUser(newUserName) == null) {
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
        await sp.setString('userName', newUserName);
        return true;
      }
    }
    return false;
  }
}
