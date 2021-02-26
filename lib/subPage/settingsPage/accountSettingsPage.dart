import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/data/webConfig.dart';
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
  String userName = '123';
  var textFieldController = new TextEditingController();

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
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (bc) => AlertDialog(
                        title: Row(
                          children: [
                            Icon(Icons.border_color, size: 32),
                            Text('   输入用户名.')
                          ],
                        ),
                        content: TextFormField(
                          autofocus: true,
                          controller: textFieldController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                        actions: [
                          FlatButton.icon(
                              onPressed: () {
                                //TODO:修改用户名
                                // Response res = await Dio()
                                //     .post('$apiServerAddress/setUserName/');
                                if (true) {
                                  setState(() {
                                    userName = textFieldController.text;
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              icon: Icon(Icons.done),
                              label: Text('完成'))
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void getUserInfo() async{
    sp=await SharedPreferences.getInstance();
  }
  @override
  void dispose() {
    super.dispose();
  }


}
