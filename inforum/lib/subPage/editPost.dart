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
  final titleController = new TextEditingController();
  final contentController = new TextEditingController();
  var tagChips;
  bool edited = false;
  String draftTitle;
  String draftContent;

  @override
  void initState() {
    getDraft();
    titleController.addListener(txtListener);
    contentController.addListener(txtListener);
    if (widget.mode == 1) {
      titleController.text = widget.titleText;
      contentController.text = widget.summaryText;
    }
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

  Future<void> getDraft() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    draftTitle = sp.getString('draft_title');
    draftContent = sp.getString('draft_content');
    if (widget.mode == 0) {
      titleController.text = draftTitle;
      contentController.text = draftContent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('编辑帖子'),
            actions: [
              edited
                  ? _SaveButton(
                      title: titleController.text,
                      content: contentController.text,
                      style: 0,
                    )
                  : IconButton(icon: Icon(Icons.save_rounded)),
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
            padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
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
      onWillPop: _onBackPressed,
    );
  }

  void txtListener() {
    if (titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty) {
      setState(() {
        edited = false;
      });
    } else {
      setState(() {
        edited = true;
      });
    }
  }

  void addTag() {}

  //退出前事件，返回true时即退出
  Future<bool> _onBackPressed() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isAllEmpty = titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty;
    bool isNotChanged = titleController.text == sp.getString('draft_title') &&
        contentController.text == sp.getString('draft_content');
    //如果没有改动内容或内容为空,不拦截退出
    if (widget.mode == 1 &&
        titleController.text == widget.titleText &&
        contentController.text == widget.summaryText) {
      return Future<bool>.value(true);
    }
    if (widget.mode == 0) {
      if (isAllEmpty || isNotChanged) {
        return Future<bool>.value(true);
      }
    }
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('要保存为草稿吗?'),
              actions: <Widget>[
                _SaveButton(
                  style: 1,
                  title: titleController.text,
                  content: contentController.text,
                ),
                FlatButton.icon(
                  textColor: Colors.red,
                  icon: Icon(Icons.delete_rounded),
                  label: Text('舍弃'),
                  onPressed: () {
                    Navigator.pop(context, true);
                    //舍弃时会清空草稿存储
                    sp.setString('draft_title', '');
                    sp.setString('draft_content', '');
                  },
                ),
              ],
            ));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}

class _SaveButton extends StatelessWidget {
  final String title;
  final String content;
  final int style;

  const _SaveButton({Key key, this.title, this.content, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (style == 0) {
      return new IconButton(
        icon: Icon(Icons.save),
        //TODO:存为草稿
        onPressed: () => save(context, title, content),
        tooltip: '存为草稿',
      );
    }
    return FlatButton.icon(
      icon: Icon(Icons.save),
      label: Text('保存'),
      onPressed: () {
        save(context, title, content);
        Navigator.pop(context, true);
      },
    );
  }

  Future<void> save(
    BuildContext context,
    String title,
    String content,
  ) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('draft_title', title);
    sp.setString('draft_content', content);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('已存为草稿.')));
    print(sp.getString('draft_title'));
    print(sp.getString('draft_content'));
  }
}
