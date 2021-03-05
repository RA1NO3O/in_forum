import 'dart:math';
import 'package:flutter/material.dart';
import 'package:inforum/service/searchHistoryService.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() {
    return _SearchPage();
  }
}

class _SearchPage extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  List<Widget> sh = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    getHistory(context);
    return [
      IconButton(
        tooltip: '清除',
        icon: const Icon(Icons.clear),
        onPressed: () async {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: '返回',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    pushSearchHistory(query);
    return ListView.builder(
      itemCount: Random().nextInt(10),
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('result $index'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(children: sh);
  }

  Future<void> getHistory(BuildContext context) async {
    List<Widget> searchHistory = await getSearchHistory() ?? [];
    sh = [
      Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(15),
                child: Text('搜索历史')),
          ),
          Expanded(
            flex: 0,
            child: TextButton(
              onPressed: () async {
                bool r = false;
                r = await showDialog(
                  context: context,
                  builder: (bc) => AlertDialog(
                    title: Column(
                      children: [
                        Icon(
                          Icons.help_rounded,
                          size: 40,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text('清空搜索历史记录?'),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton.icon(
                        icon: Icon(Icons.clear),
                        label: Text('取消'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.redAccent),
                        ),
                        icon: Icon(Icons.done_rounded),
                        label: Text('确认'),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                );
                if (r) {
                  clearSearchHistory();
                  query = '';
                }
              },
              child: Text('清空历史记录'),
            ),
          )
        ],
      ),
    ];
    sh.addAll(searchHistory);
  }
}
