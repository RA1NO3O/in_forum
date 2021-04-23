import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:inforum/component/postListItem.dart';
import 'package:inforum/data/collectionListStream.dart';

class CollectionPage extends StatefulWidget {
  final int? userID;

  const CollectionPage({Key? key, this.userID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CollectionPage();
  }
}

class _CollectionPage extends State<CollectionPage> {
  List<PostListItem> _collectionList = [];
  bool loadState = false;

  @override
  void initState() {
    _getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('收藏'),
        // centerTitle: true,
        actions: [
          IconButton(
              tooltip: '搜索收藏', icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        strokeWidth: 2.5,
        onRefresh: _refresh,
        child: !loadState
            ? _collectionList.isNotEmpty
                ? StaggeredGridView.extentBuilder(
                    physics: AlwaysScrollableScrollPhysics(),
                    maxCrossAxisExtent: 240,
                    itemCount: _collectionList.length,
                    itemBuilder: (context, index) => _collectionList[index],
                    staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_outline_rounded,
                          size: 100,
                        ),
                        Text('您收藏的所有帖子都将位于此处')
                      ],
                    ),
                  )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_top_rounded,
                      size: 100,
                    ),
                    Text('请稍等')
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _refresh() async {
    await _getList();
    return;
  }

  _getList() async {
    setState(() {
      loadState = true;
      _collectionList.clear();
    });
    List<PostListItem> pcl = await getCollectionList(widget.userID);
    setState(() {
      loadState = false;
      _collectionList.addAll(pcl);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
