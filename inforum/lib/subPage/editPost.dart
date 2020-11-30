import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPostScreen extends StatefulWidget {
  final String titleText;
  final String summaryText;
  final int mode; //0为新建,1为编辑

  const EditPostScreen({Key key, this.titleText, this.summaryText, this.mode})
      : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  SharedPreferences sp;
  final titleController = new TextEditingController();
  final contentController = new TextEditingController();
  var tagChips;

  @override
  void initState() {
    titleController.text = widget.mode == 1 ? widget.titleText : '';
    contentController.text = widget.mode == 1 ? widget.summaryText : '';
    tagChips = List<Widget>();
    tagChips.add(Text('标签:    '));
    //TODO:非新建状态下导入标签
    // for(var i in ){
    //   tagChips.add()
    // }
    tagChips.add(ActionChip(
      onPressed: () => addTag(),
      avatar: const Icon(Icons.add),
      label: Text('添加标签'),
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('编辑帖子'),
              actions: [
                new IconButton(
                  icon: Icon(Icons.save),
                  //TODO:存为草稿
                  onPressed: ()=>save(context),
                  tooltip: '存为草稿',
                ),
                new IconButton(
                  icon: widget.mode == 0
                      ? Icon(Icons.send_rounded)
                      : Icon(Icons.done),
                  //TODO:发布新帖
                  onPressed: () => print('posted.'),
                  tooltip: widget.mode == 0 ? '发帖' : '提交更改',
                )
              ],
            ),
            body: Container(
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
              child: Column(
                children: [
                  new TextFormField(
                    maxLength: 128,
                    controller: titleController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        labelText: '标题',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 10),
                    child: new TextFormField(
                      controller: contentController,
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
            )),
        onWillPop: _onBackPressed);
  }

  void addTag() {}

  Future<void> save(BuildContext context) async {
    sp = await SharedPreferences.getInstance();
    sp.setString('draft_title', titleController.text);
    sp.setString('draft_content', contentController.text);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('已存为草稿.')));
  }

  Future<bool> _onBackPressed() async {
    sp = await SharedPreferences.getInstance();
    //如果没有改动或内容,不拦截退出
    if (widget.mode == 1 &&
        titleController.text == widget.titleText &&
        contentController.text == widget.summaryText) {
      return Future<bool>.value(true);
    }
    if (widget.mode == 0 &&
        titleController.text == sp.getString('draft_title') &&
        contentController.text == sp.getString('draft_content')) {
      return Future<bool>.value(true);
    }
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('要保存为草稿吗?'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.save),
                  label: Text('保存'),
                  onPressed: () {
                    save(context);
                    Navigator.pop(context, true);
                  },
                ),
                FlatButton.icon(
                  textColor: Colors.red,
                  icon: Icon(Icons.delete_rounded),
                  label: Text('舍弃'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    super.dispose();
  }
}
