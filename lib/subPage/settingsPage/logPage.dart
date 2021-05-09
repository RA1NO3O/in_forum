import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inforum/data/webConfig.dart';

class LogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String log = '';
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('服务器日志'),
      ),
      body: ListView(
        children: [Text(log)],
      ),
    );
  }

  Future<void> _init() async {
    Response res = await Dio().get('$apiServerAddress/log/?pwd=****');
    setState(() {
      log = res.data.toString().replaceAll('<br>', '\n');
    });
  }
}
