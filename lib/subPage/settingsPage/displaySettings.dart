import 'package:flutter/material.dart';

class DisplaySettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DisplaySettingsPageState();
}

class _DisplaySettingsPageState extends State<DisplaySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('显示设置'),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
