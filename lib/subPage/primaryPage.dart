import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/component/postListItem.dart';
import 'package:inforum/service/postStreamService.dart';

class PrimaryPage extends StatefulWidget {
  final int? userID;
  final ScrollController? scrollController;

  const PrimaryPage({Key? key, this.userID, this.scrollController})
      : super(key: key);

  @override
  PrimaryPageState createState() => PrimaryPageState();
}

class PrimaryPageState extends State<PrimaryPage> {
  List<PostListItem> streamList = [];
  bool loadState = false;
  ScaffoldState? scaffold;

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
        child: Scrollbar(
          radius: Radius.circular(5),
          child: !loadState
              ? StaggeredGridView.extentBuilder(
                  physics: AlwaysScrollableScrollPhysics(),
                  maxCrossAxisExtent: 240,
                  itemCount: streamList.length,
                  itemBuilder: (context, index) => streamList[index],
                  staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                )
              : emptyHint(),
        ));
  }

  Future<void> _refresh() async {
    await _getStream();
    return;
  }

  _getStream() async {
    setState(() {
      loadState = true;
      streamList.clear();
    });

    List<PostListItem> psis = await getPostStream(widget.userID);

    setState(() {
      loadState = false;
      streamList.addAll(psis);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
