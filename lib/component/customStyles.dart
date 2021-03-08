import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

RoundedRectangleBorder roundedRectangleBorder =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
Color themeColor = Colors.blue;

void getStyleSettings() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  themeColor = Color(sp.getInt("ThemeColor")) ?? Colors.blue;
}

SnackBar errorSnackBar(String r) {
  return SnackBar(
    content: Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Icon(Icons.close_rounded),
        ),
        Text(r),
      ],
    ),
    backgroundColor: Colors.redAccent,
  );
}

SnackBar welcomeSnackBar(String r) {
  return SnackBar(
    content: Row(
      children: [
        Text('👏欢迎, ' + r),
      ],
    ),
    backgroundColor: Colors.greenAccent,
  );
}

SnackBar doneSnackBar(String r) {
  return SnackBar(
    content: Row(
      children: [
        Icon(Icons.done_rounded),
        Text(r),
      ],
    ),
    backgroundColor: Colors.blue,
  );
}

Widget emptyHint() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 100,
          ),
          Text('无内容')
        ],
      ),
    );

TextStyle titleFontStyle =
    new TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
TextStyle invalidTextStyle = new TextStyle(color: Colors.grey);
