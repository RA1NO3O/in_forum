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
        Icon(Icons.close_rounded),
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

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  focusColor: themeColor,
  buttonColor: themeColor,
);
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  accentColor: themeColor,
  primaryColor: Colors.black,
  buttonColor: themeColor,
);
TextStyle titleFontStyle =
    new TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
