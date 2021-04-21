import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/data/webConfig.dart';

class DeleteAccountPage extends StatefulWidget {
  final int userID;

  const DeleteAccountPage({Key? key, required this.userID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  GlobalKey<FormState> _dpk = GlobalKey<FormState>();
  TextEditingController _passwordController = new TextEditingController();
  bool _options = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('删除账户'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever_rounded),
            onPressed: () async {
              Response res = await Dio().post('$apiServerAddress/deleteUser/',
                  options: new Options(
                      contentType: Headers.formUrlEncodedContentType),
                  data: {
                    "userID": widget.userID,
                    "password": _passwordController.text,
                    "deleteAll": _options,
                  });
              Navigator.pop(context, res.data);
            },
          ),
        ],
      ),
    );
  }
}
