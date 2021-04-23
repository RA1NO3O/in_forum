import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Widget>> getSearchHistory() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  List<Widget> widgets = [];
  List<String> h = sp.getStringList('searchHistory') ?? [];
  h.forEach((value) {
    widgets.add(ListTile(title: Text(value), onTap: () {}));
  });
  return widgets;
}

pushSearchHistory(String recent) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  var l = sp.getStringList('searchHistory') ?? [];
  l.add(recent);
  await sp.setStringList('searchHistory', l);
}

clearSearchHistory() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  await sp.setStringList('searchHistory', []);
}
