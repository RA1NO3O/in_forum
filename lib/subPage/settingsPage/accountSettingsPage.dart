import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/component/passwordConfirm.dart';
import 'package:inforum/component/statefulDialog.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/main.dart';
import 'package:inforum/service/loginService.dart';
import 'package:inforum/service/userAccountService.dart';
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
  GlobalKey<FormState> _mk = GlobalKey<FormState>();
  GlobalKey<FormState> _pnk = GlobalKey<FormState>();

  int? userID;
  String? userName = 'unknown';
  String? nickName = 'unknown';
  String? _phoneNumber = 'unknown';
  String? _emailAddress = 'unknown';
  TextEditingController userNameController = new TextEditingController();

  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController emailAddressController = new TextEditingController();

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
                    subtitle: Text(userName ?? ''),
                    onTap: () async {
                      userNameController.text = userName ?? '';
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
                              .showSnackBar(doneSnackBar('用户名已更新.\n'
                                  '  今后,请使用更新后的用户名进行登录.'));
                          break;
                        case '1':
                          ScaffoldMessenger.of(bc)
                              .showSnackBar(errorSnackBar('更新失败,\n'
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
                    subtitle: Text('点按以更新供他人查看的个人资料.'),
                    onTap: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (bc) => EditProfilePage(
                                    userID: userID,
                                  )));
                      if (result == 0) {
                        ScaffoldMessenger.of(bc)
                            .showSnackBar(doneSnackBar('个人资料已更新.'));
                      }
                    },
                  ),
                ),
                Builder(
                  builder: (BuildContext bc) => ListTile(
                    leading: Icon(Icons.lock_rounded),
                    shape: roundedRectangleBorder,
                    title: Text('密码'),
                    subtitle: Text('点按以更新密码.'),
                    onTap: () async {
                      final result = await showDialog(
                          context: context,
                          builder: (bc) => ConfirmPasswordDialog(
                              userName: userName ?? '', bc: bc));
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
                                .showSnackBar(doneSnackBar('密码更新成功.'));
                            break;

                          case 'error.':
                            ScaffoldMessenger.of(bc)
                                .showSnackBar(errorSnackBar('密码更新失败!'));
                            break;

                          default:
                            ScaffoldMessenger.of(bc)
                                .showSnackBar(errorSnackBar('用户取消了密码更新.'));
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
                Builder(
                  builder: (bc) => ListTile(
                      leading: Icon(Icons.phone_android_rounded),
                      title: Text('电话号码'),
                      subtitle: Text(_phoneNumber ?? ''),
                      onTap: () async {
                        final result = await showDialog(
                            context: context,
                            builder: (bc) => StatefulDialog(
                                  title: Row(
                                    //确保对话框不会占满空间
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.phone_android_rounded,
                                          size: 32),
                                      Text('   输入新的电话号码.')
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Form(
                                        key: _pnk,
                                        child: TextFormField(
                                          keyboardType: TextInputType.phone,
                                          autofillHints: [
                                            AutofillHints.telephoneNumber
                                          ],
                                          autofocus: true,
                                          validator: (value) =>
                                              userNameController.text ==
                                                      userName
                                                  ? '请使用新的电话号码.'
                                                  : null,
                                          onEditingComplete: () async {
                                            await onPhoneNumberEditDone(bc);
                                          },
                                          controller: phoneNumberController,
                                          decoration: InputDecoration(
                                              border: inputBorder),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          '若要移除电话号码,请留空此字段.',
                                          style: invalidTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton.icon(
                                        onPressed: () async {
                                          await onPhoneNumberEditDone(bc);
                                        },
                                        icon: Icon(Icons.done),
                                        label: Text('完成'))
                                  ],
                                ));
                        switch (result) {
                          case '0':
                            ScaffoldMessenger.of(bc)
                                .showSnackBar(doneSnackBar('已更新电话号码.'));
                            break;
                          case '1':
                            ScaffoldMessenger.of(bc)
                                .showSnackBar(errorSnackBar('更新失败,\n'
                                    '  该电话号码可能已存在.'));
                        }
                      }),
                ),
                Builder(
                  builder: (bc) => ListTile(
                      leading: Icon(Icons.email_rounded),
                      title: Text('邮箱'),
                      subtitle: Text(_emailAddress ?? ''),
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (bc) => StatefulDialog(
                            title: Row(
                              //确保对话框不会占满空间
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.email_rounded, size: 32),
                                Text('   输入新的邮箱地址.')
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Form(
                                  key: _mk,
                                  child: TextFormField(
                                    autofillHints: [AutofillHints.email],
                                    keyboardType: TextInputType.emailAddress,
                                    autofocus: true,
                                    validator: (value) =>
                                        emailAddressController.text == userName
                                            ? '请使用新的邮箱地址.'
                                            : null,
                                    onEditingComplete: () async {
                                      await onEmailAddressEditDone(bc);
                                    },
                                    controller: emailAddressController,
                                    decoration:
                                        InputDecoration(border: inputBorder),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    '若要移除电子邮箱,请留空此字段.',
                                    style: invalidTextStyle,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton.icon(
                                  onPressed: () async {
                                    await onEmailAddressEditDone(bc);
                                  },
                                  icon: Icon(Icons.done),
                                  label: Text('完成'))
                            ],
                          ),
                        );
                        switch (result) {
                          case '0':
                            ScaffoldMessenger.of(bc)
                                .showSnackBar(doneSnackBar('邮箱地址已更新.'));
                            break;
                          case '1':
                            ScaffoldMessenger.of(bc)
                                .showSnackBar(errorSnackBar('更新失败,\n'
                                    '  该邮箱地址可能已存在.'));
                        }
                      }),
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
                          case null: //通常退出时,不显示提示.
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
      bool r = await tryUpdateUserName(userNameController.text);
      if (r) {
        Navigator.pop(bc, '0');
      } else {
        Navigator.pop(bc, '1');
      }
    }
  }

  onPhoneNumberEditDone(BuildContext bc) async {
    if (_pnk.currentState!.validate()) {
      bool r = await tryUpdatePhoneNumber(phoneNumberController.text);
      if (r) {
        Navigator.pop(bc, '0');
      } else {
        Navigator.pop(bc, '1');
      }
    }
  }

  onEmailAddressEditDone(BuildContext bc) async {
    if (_mk.currentState!.validate()) {
      bool r = await tryUpdateEmailAddress(emailAddressController.text);
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
    });
    var rs = await getUserAccountSettings(userID!);
    if (rs != null) {
      setState(() {
        _phoneNumber = rs.phone!.replaceFirst(new RegExp(r'\d{4}'), '****', 3);
        _emailAddress = rs.email;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> tryUpdateUserName(String newUserName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (await searchUser(newUserName) == null) {
      Response res = await Dio().post('$apiServerAddress/updateUserName/',
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

  tryUpdatePhoneNumber(String newPhoneNumber) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (await searchUser(newPhoneNumber) == null) {
      Response res = await Dio().post(
          '$apiServerAddress/updateUserPhoneNumber/',
          options: new Options(contentType: Headers.formUrlEncodedContentType),
          data: {
            "userID": sp.getInt('userID'),
            "phoneNumber": newPhoneNumber.isEmpty ? 'null' : newPhoneNumber,
          });
      if (res.data == 'success.') {
        setState(() {
          _phoneNumber = newPhoneNumber;
        });
        return true;
      }
    }
    return false;
  }

  tryUpdateEmailAddress(String newEmailAddress) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (await searchUser(newEmailAddress) == null) {
      Response res = await Dio().post(
          '$apiServerAddress/updateUserEmailAddress/',
          options: new Options(contentType: Headers.formUrlEncodedContentType),
          data: {
            "userID": sp.getInt('userID'),
            "emailAddress": newEmailAddress.isEmpty ? 'null' : newEmailAddress,
          });
      if (res.data == 'success.') {
        setState(() {
          _emailAddress = newEmailAddress;
        });
        return true;
      }
    }
    return false;
  }
}
