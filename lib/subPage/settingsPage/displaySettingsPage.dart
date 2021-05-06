import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplaySettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DisplaySettingsPageState();
}

class _DisplaySettingsPageState extends State<DisplaySettingsPage> {
  bool? _cupertinoMode;
  bool _changed = false;
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('显示设置'),
          ),
          body: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                child: Column(
                  children: [
                    SwitchListTile(
                      // leading: Icon(Icons.style_rounded),
                      shape: roundedRectangleBorder,
                      title: Text('使用iOS风格UI'),
                      value: _cupertinoMode ?? false,
                      onChanged: (value) => setState(() {
                        _changed = true;
                        _cupertinoMode = value;
                      }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onWillPop: _onWillPop);
  }

  void _init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      _cupertinoMode = sp.getBool('isCupertinoMode') ?? false;
    });
  }

  Future<bool> _onWillPop() async {
    if (_changed) {
      bool? result = await showDialog(
          context: context,
          builder: (bc) => AlertDialog(
                title: Column(
                  children: [
                    Icon(
                      Icons.info_rounded
                      size: 40,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text('更改将在应用重启后生效。'),
                    )
                  ],
                ),
                actions: [
                  TextButton.icon(
                      onPressed: () => Navigator.pop(bc, true),
                      icon: Icon(Icons.done),
                      label: Text('好'))
                ],
              ));
      if (result == true) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        await sp.setBool('isCupertinoMode', _cupertinoMode ?? false);
        return Future<bool>.value(true);
      }
    }
          return Future<bool>.value(false);
  }
}
