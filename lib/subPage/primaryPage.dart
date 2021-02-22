import 'package:flutter/material.dart';
import 'package:inforum/component/forumListItem.dart';
import 'package:inforum/data/forumListStream.dart';

class PrimaryPage extends StatefulWidget {
  final String userID;
  final ScrollController scrollController;

  const PrimaryPage({Key key, this.userID, this.scrollController})
      : super(key: key);

  @override
  _PrimaryPage createState() {
    return _PrimaryPage();
  }
}

class _PrimaryPage extends State<PrimaryPage> {
  List<ForumListItem> _list = [];
  bool loadState = false;

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
        controller: widget.scrollController,
        children: loadState ? _list : [],
      ),
    );
  }

  Future<void> _refresh() async {
    await _getStream();
    return;
  }

  _getStream() async {
    _list.clear();
    List<ForumListItem> fli = await getList(widget.userID);
    _list.addAll(fli);
    setState(() {
      loadState = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
