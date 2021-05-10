import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/service/searchHistoryService.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: Text(
            '时下热门🔥',
            style: titleFontStyle,
          ),
        ),
        ListTile(
          leading: Icon(Icons.tag),
          title: Text('新冠病毒'),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.tag),
          title: Text('美俄关系'),
          onTap: () {},
        ),
        Divider(),
      ],
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String?> {
  List<Widget> sh = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(true);
    final ThemeData theme = Theme.of(context);
    assert(true);
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
    //TODO:实现搜索功能
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
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.all(12),
        child: ListView(children: sh));
  }

  Future<void> getHistory(BuildContext context) async {
    List<Widget> searchHistory = await getSearchHistory();
    sh = [
      Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 1,
            child: Text('搜索历史'),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
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
