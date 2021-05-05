import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/component/passwordConfirm.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountPage extends StatefulWidget {
  final int userID;
  const DeleteAccountPage({Key? key, required this.userID}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  bool _options = false;
  String _userName = '';
  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _userName = sp.getString('userName')!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('删除账户'),
        actions: [
          Builder(
            builder: (bc) => IconButton(
              icon: Icon(Icons.delete_forever_rounded),
              onPressed: () async {
                final r = await showDialog(
                    context: bc,
                    builder: (bc) =>
                        ConfirmPasswordDialog(userName: _userName, bc: bc));
                if (r == 'correct.') {
                  Response res = await Dio().delete(
                      '$apiServerAddress/deleteUser/',
                      options: new Options(
                          contentType: Headers.formUrlEncodedContentType),
                      data: {
                        "userID": widget.userID,
                        "deleteAll": _options,
                      });
                  Navigator.pop(context, res.data);
                }
              },
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                '删除账户相关事宜',
                style: titleFontStyle,
              ),
            ),
            Text('删除账号后,用户名、个人资料、绑定的电话号码和电子邮件地址'
                '等账号相关个人信息将被释放,可供再次注册.\n'
                '相应地,若发布的帖子及回复未予删除,与撰写人相关的用户信息也将显'
                '示为不存在.他人在此账号帖子名下回复的内容也将随之一并删除,'
                '此账号关注与被关注的账户列表也将对应地移除.\n\n'
                '本次操作无法撤销.但是在此之前,您有权决定以下内容的去留.'),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Checkbox(
                      value: _options,
                      onChanged: (newValue) =>
                          setState(() => _options = newValue ?? true)),
                  Text('删除此账号发布的一切内容')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
