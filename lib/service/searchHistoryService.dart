import 'package:shared_preferences/shared_preferences.dart';

pushSearchHistory(String recent) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  var l = sp.getStringList('searchHistory') ?? [];
  if (!l.contains(recent)) {
    l.add(recent);
    await sp.setStringList('searchHistory', l);
  }
}

clearSearchHistory() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  await sp.setStringList('searchHistory', []);
}
