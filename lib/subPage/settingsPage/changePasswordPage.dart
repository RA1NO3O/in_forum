import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/data/webConfig.dart';

class ChangePasswordPage extends StatefulWidget {
  final int userID;

  const ChangePasswordPage({Key? key, required this.userID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordPage();
  }
}

class _ChangePasswordPage extends State<ChangePasswordPage> {
  GlobalKey<FormState> _npk = GlobalKey<FormState>();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('修改密码'),
        actions: [
          IconButton(
              onPressed: submitNewPassword, icon: Icon(Icons.done_rounded))
        ],
      ),
      body: ListView(
        children: [
          Form(
            key: _npk,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    autofocus: true,
                    controller: newPasswordController,
                    obscureText: !passwordVisible,
                    textInputAction: TextInputAction.done,
                    validator: (value) =>
                        newPasswordController.text.isEmpty ? '密码不能为空.' : null,
                    decoration: InputDecoration(
                      labelText: '新密码',
                      prefixIcon: Icon(Icons.lock_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        tooltip: '显示/隐藏密码',
                        onPressed: () => setState(() {
                          passwordVisible = !passwordVisible;
                        }),
                      ),
                      border: inputBorder,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    autofocus: true,
                    controller: confirmPasswordController,
                    obscureText: !passwordVisible,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: submitNewPassword,
                    validator: (value) => newPasswordController.text !=
                            confirmPasswordController.text
                        ? '两次输入的密码不一致.'
                        : null,
                    decoration: InputDecoration(
                      labelText: '确认密码',
                      prefixIcon: Icon(Icons.lock_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        tooltip: '显示/隐藏密码',
                        onPressed: () => setState(() {
                          passwordVisible = !passwordVisible;
                        }),
                      ),
                      border: inputBorder,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitNewPassword() async {
    if (_npk.currentState!.validate()) {
      Response res = await Dio().post('$apiServerAddress/updateUserPassword/',
          options: new Options(contentType: Headers.formUrlEncodedContentType),
          data: {
            "userID": widget.userID,
            "password": newPasswordController.text,
          });
      Navigator.pop(context, res.data);
    }
  }
}
