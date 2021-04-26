import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';

class HelpCenterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('帮助中心'),
        actions: [
          IconButton(icon: Icon(Icons.search_rounded), onPressed: () {})
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              '您遇到了什么问题?',
              style: titleFontStyle,
            ),
            AboutListTile()
          ],
        ),
      ),
    );
  }
}
