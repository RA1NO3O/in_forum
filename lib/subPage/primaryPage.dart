import 'package:flutter/material.dart';
import 'package:inforum/component/forumListItem.dart';
import 'package:inforum/data/forumListStream.dart';

class PrimaryPage extends StatefulWidget {
  final String userId;
  final ScrollController scrollController;

  const PrimaryPage({Key key, this.userId, this.scrollController})
      : super(key: key);

  @override
  _PrimaryPage createState() {
    return _PrimaryPage();
  }
}

class _PrimaryPage extends State<PrimaryPage> {
  List<ForumListItem> _list = [];

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
      child: _list.isNotEmpty
          ? ListView(
              controller: widget.scrollController,
              children: _list,
            )
          : ListView(
              controller: widget.scrollController,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.signal_wifi_off_rounded,
                        color: Colors.black26,
                        size: 100,
                      ),
                      Text(
                        '未连接到网络',
                        style: TextStyle(color: Colors.black26),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _refresh() async {
    await _getStream();
  }

  _getStream() async {
    List<ForumListItem> fli = await getList() ?? null;
    setState(() {
      _list.clear();
      if (fli != null) {
        _list.addAll(fli);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
