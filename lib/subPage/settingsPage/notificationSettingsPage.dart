import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationSettingsPageState();
  }
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('通知设置'),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
