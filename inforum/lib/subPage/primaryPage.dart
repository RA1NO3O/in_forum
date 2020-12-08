import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inforum/component/forumListItem.dart';
import 'package:inforum/data/fourmListStream.dart';

class PrimaryPage extends StatefulWidget {
  final String userId;

  const PrimaryPage({Key key, this.userId}) : super(key: key);

  @override
  _PrimaryPage createState() {
    return _PrimaryPage();
  }
}

class _PrimaryPage extends State<PrimaryPage> {
  List<ForumListItem> _list = ForumListStream.getList();

  @override
  void initState() {
    _getStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 2.5,
      onRefresh: _refresh,
      child: ListView(
        controller: PrimaryScrollController.of(context),
        children: _list,
      ),
    );
  }

  Future<void> _refresh() async {
    await _getStream();
  }

  _getStream() {
    setState(() {
      _list.clear();
      _list.addAll(ForumListStream.getList());
    });
  }
}
