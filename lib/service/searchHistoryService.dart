import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sp;

_init() async {
  sp = await SharedPreferences.getInstance();
}

Future<List<Widget>> getSearchHistory() async {
  _init();
  List<Widget> widgets = [];
  List<String> h = sp.getStringList('searchHistory')??[];
    h.forEach((value) {
      widgets.add(ListTile(title: Text(value), onTap: () {}));
    });
  return widgets;
}

pushSearchHistory(String recent) async {
  _init();
  var l = sp.getStringList('searchHistory') ?? [];
  l.add(recent);
  sp.setStringList('searchHistory', l);
}

clearSearchHistory() async {
  _init();
  sp.setStringList('searchHistory', []);
}
