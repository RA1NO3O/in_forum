import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inforum/component/tagItem.dart';

class EditPostScreen extends StatefulWidget {
  final String titleText;
  final String summaryText;

  const EditPostScreen({Key key, this.titleText, this.summaryText}) : super(key: key);
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  var tagChips;
  @override
  void initState() {
    tagChips=List<Widget>();
    tagChips.add(Text('标签:    '));
    //TODO:在非编辑状态下导入标签
    // for(var i in ){
    //   tagChips.add()
    // }
    tagChips.add(ActionChip(
      onPressed: () {},
      avatar: const Icon(Icons.add),
      label: Text('添加标签'),
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('编辑帖子'),
          actions: [
            new IconButton(
              icon: Icon(Icons.save),
              //TODO:存为草稿
              onPressed: () => print('saved.'),
              tooltip: '存为草稿',
            ),
            new IconButton(
              icon: Icon(Icons.send_rounded),
              //TODO:发布新帖
              onPressed: ()=>print('posted.'),
              tooltip: '发帖',
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
          child: Column(
            children: [
              new TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    labelText: '标题',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              new Container(
                margin: EdgeInsets.only(top: 10),
                child: new TextField(
                  maxLines: 10,
                  decoration: InputDecoration(
                      labelText: '正文',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              new Row(
                children: tagChips,
              )
            ],
          ),
        ));
  }
  void addTag(){

  }
  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    super.dispose();
  }
}
