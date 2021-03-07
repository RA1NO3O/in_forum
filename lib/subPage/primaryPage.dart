import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:inforum/component/postListItem.dart';
import 'package:inforum/service/postStreamService.dart';
import 'package:skeleton_text/skeleton_text.dart';

class PrimaryPage extends StatefulWidget {
  final int userID;
  final ScrollController scrollController;

  const PrimaryPage({Key key, this.userID, this.scrollController})
      : super(key: key);

  @override
  _PrimaryPageState createState() => _PrimaryPageState();
}

class _PrimaryPageState extends State<PrimaryPage> {
  static List<PostListItem> streamList = [];
  bool loadState = false;
  ScaffoldState scaffold;

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
                  maxCrossAxisExtent: 240,
                  itemCount: streamList.length,
                  itemBuilder: (context, index) => streamList[index],
                  staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                )
              : StaggeredGridView.extentBuilder(
                  maxCrossAxisExtent: 240,
                  itemCount: 4,
                  itemBuilder: (bc, index) => Card(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    elevation: 1,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Container(
                            child: Flex(direction: Axis.vertical, children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 10, left: 5, bottom: 5),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                                child: SkeletonAnimation(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  shimmerColor: Colors.white,
                                                  shimmerDuration: 2000,
                                                  child: Container(
                                                    height: 35,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(35)),
                                                  ),
                                                ),
                                              ),
                                              SkeletonAnimation(
                                                shimmerColor: Colors.white,
                                                shimmerDuration: 2000,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  color: Colors.grey,
                                                  height: 20,
                                                  width: 60,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 6),
                                          child: SkeletonAnimation(
                                            shimmerColor: Colors.white,
                                            shimmerDuration: 2000,
                                            child: Container(
                                              color: Colors.grey,
                                              width: 70,
                                              height: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.all(5),
                                    child: SkeletonAnimation(
                                      shimmerColor: Colors.white,
                                      shimmerDuration: 2000,
                                      child: Container(
                                        color: Colors.grey,
                                        width: 350,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.all(5),
                                    child: SkeletonAnimation(
                                      shimmerColor: Colors.white,
                                      shimmerDuration: 2000,
                                      child: Container(
                                        color: Colors.grey,
                                        width: 350,
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.all(5),
                                    child: SkeletonAnimation(
                                      shimmerColor: Colors.white,
                                      shimmerDuration: 2000,
                                      child: Container(
                                        color: Colors.grey,
                                        width: 350,
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: SkeletonAnimation(
                                    shimmerColor: Colors.white,
                                    shimmerDuration: 2000,
                                    child: Container(
                                      color: Colors.grey,
                                      height: 200,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                alignment: Alignment.centerLeft,
                                child: SkeletonAnimation(
                                  borderRadius: BorderRadius.circular(20),
                                  shimmerColor: Colors.white,
                                  shimmerDuration: 2000,
                                  child: Container(
                                    width: 80,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(6),
                                child:
                                    Flex(direction: Axis.horizontal, children: [
                                  Expanded(
                                    flex: 1,
                                    child: SkeletonAnimation(
                                      shimmerColor: Colors.white,
                                      shimmerDuration: 2000,
                                      child: Container(
                                        height: 30,
                                        width: 75,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SkeletonAnimation(
                                      shimmerColor: Colors.white,
                                      shimmerDuration: 2000,
                                      child: Container(
                                        height: 30,
                                        width: 75,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SkeletonAnimation(
                                      shimmerColor: Colors.white,
                                      shimmerDuration: 2000,
                                      child: Container(
                                        height: 30,
                                        width: 75,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SkeletonAnimation(
                                      shimmerColor: Colors.white,
                                      shimmerDuration: 2000,
                                      child: Container(
                                        height: 30,
                                        width: 75,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ]),
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                ),
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
