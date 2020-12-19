import 'package:flutter/material.dart';
import 'package:inforum/data/collectionListStream.dart';

class CollectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CollectionPage();
  }
}

class _CollectionPage extends State<CollectionPage> {
  List<Widget> _collectionList = new List<Widget>();
  bool isEmpty = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getList();
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            '收藏',
            style: new TextStyle(color: Colors.black),
          ),
          // centerTitle: true,
          actions: [
            IconButton(
                tooltip: '搜索收藏', icon: Icon(Icons.search), onPressed: () {}),
          ],
        ),
        body: RefreshIndicator(
          strokeWidth: 2.5,
          onRefresh: _refresh,
          child: isEmpty
              ? ListView(
                  children: _collectionList,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_outline_rounded,
                        color: Colors.black26,
                        size: 100,
                      ),
                      Text(
                        '您收藏的所有帖子都将位于此处',
                        style: TextStyle(color: Colors.black26),
                      )
                    ],
                  ),
                ),
        ));
  }

  Future<void> _refresh() async {
    await getList();
  }

  getList() {
    setState(() {
      if (CollectionListStream.getCollections().isNotEmpty) {
        _collectionList.clear();
        _collectionList.addAll(CollectionListStream.getCollections());
        isEmpty = false;
      } else {
        isEmpty = true;
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
}
