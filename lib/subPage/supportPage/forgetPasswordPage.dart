import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('忘记密码'),
        actions: [],
      ),
      body: ListView(
        children: [
          Text(
            '请选择一种验证方式:',
            style: titleFontStyle,
          ),
        ],
      ),
    );
  }
}
