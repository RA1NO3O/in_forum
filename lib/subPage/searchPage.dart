import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/service/fuzzySearchService.dart';
import 'package:inforum/service/searchHistoryService.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sp;

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  @override
  void initState() {
    _init();
    super.initState();
  }

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
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (bc) => SearchResultPage(query: '新冠病毒'))),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.tag),
          title: Text('美俄关系'),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (bc) => SearchResultPage(query: '美俄关系'))),
        ),
        Divider(),
      ],
    );
  }

  Future<void> _init() async {
    sp = await SharedPreferences.getInstance();
  }
}

class CustomSearchDelegate extends SearchDelegate<String?> {
  List<Widget> sh = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> h = sp.getStringList('searchHistory') ?? [];
    final suggestionsList = query.isEmpty
        ? h
        : h.where((input) => input.startsWith(query)).toList();
    //判断集合中的字符串是否以搜索框内输入的字符串开头，
    //是则返回true，并将筛选出来的结果以list的方式储存在searchList里
    return ListView.builder(
        itemCount: suggestionsList.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: ListTile(
              title: RichText(
                //富文本
                text: TextSpan(
                    text: suggestionsList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: suggestionsList[index].substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => new SearchResultPage(
                    query: h[index],
                  ),
                ),
              );
            },
          );
        });
  }
}

class SearchResultPage extends StatefulWidget {
  final String query;

  const SearchResultPage({Key? key, required this.query}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List<List<Widget>> sr = [];
  Future<void> _init() async {
    sr = await fuzzySearch(widget.query);
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fuzzySearch(widget.query),
        builder: (bc, ss) {
          if (ss.hasData) {
            return DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('\"${widget.query}\" 的搜索结果'),
                    bottom: TabBar(
                      tabs: [
                        Tab(
                          text: '帖子',
                        ),
                        Tab(
                          text: '用户',
                        )
                      ],
                    ),
                  ),
                  body: TabBarView(children: [
                    ListView(
                      children: sr[0],
                    ),
                    ListView(
                      children: sr[1],
                    )
                  ]),
                ));
          }
          return Icon(Icons.hourglass_bottom);
        });
  }
}
