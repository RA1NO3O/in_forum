import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPostScreen extends StatefulWidget {
  final String titleText;
  final String contentText;
  final List<String> tags;
  final int mode; //0为新建,1为编辑

  const EditPostScreen(
      {Key key, this.titleText, this.contentText, this.mode, this.tags})
      : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final titleController = new TextEditingController();
  final contentController = new TextEditingController();
  var tags = List<String>();
  var tagChips;
  bool saved = false;
  bool edited = false;
  String draftTitle;
  String draftContent;
  List<String> draftTags;

  @override
  void initState() {
    if (widget.mode == 0) {
      getDraft();
    }
    if (widget.mode == 1) {
      titleController.text = widget.titleText;
      contentController.text = widget.contentText;
      tags.addAll(widget.tags);
    }
    titleController.addListener(textListener);
    contentController.addListener(textListener);

    super.initState();
  }

  void refreshTagList() {
    tagChips = [
      Container(
        margin: EdgeInsets.only(top: 6, bottom: 6, right: 5),
        child: Text('标签：'),
      ),
      Builder(
        builder: (BuildContext bc) {
          return Container(
            height: 32,
            child: ActionChip(
              label: Text('添加标签'),
              avatar: Icon(Icons.add_rounded),
              onPressed: () => addTag(bc),
            ),
          );
        },
      ),
    ];
    tagChips.addAll(tags
        .map((s) => Container(
              height: 32,
              child: InputChip(
                label: Text('$s'),
                avatar: Icon(Icons.tag),
                onDeleted: () {
                  setState(() {
                    tags.remove('$s');
                    refreshTagList();
                  });
                },
              ),
            ))
        .toList());
    if (IterableEquality().equals(tags, draftTags)) {
      edited = false;
    }
  }

  Future<void> getDraft() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    draftTitle = sp.getString('draft_title');
    draftContent = sp.getString('draft_content');
    draftTags = sp.getStringList('draft_tags');
    titleController.text = draftTitle;
    contentController.text = draftContent;
    if (draftTags != null) {
      tags = draftTags;
    }
    refreshTagList();
  }

  @override
  Widget build(BuildContext context) {
    refreshTagList();
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Color(0xFFFAFAFA),
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              widget.mode == 0 ? '新帖子' : '编辑帖子',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              Builder(builder: (BuildContext bc) {
                return IconButton(
                  icon: Icon(Icons.save_rounded),
                  onPressed: edited
                      ? () {
                          save(titleController.text, contentController.text,
                              tags);
                          Scaffold.of(bc).showSnackBar(doneSnackBar('已存为草稿.'));
                          saved = true;
                        }
                      : null,
                  tooltip: '存为草稿',
                );
              }),
              new IconButton(
                icon: widget.mode == 0
                    ? Icon(Icons.send_rounded)
                    : Icon(Icons.done),
                //TODO:api接入发布新帖
                onPressed: () => print('posted.'),
                tooltip: widget.mode == 0 ? '发帖' : '提交更改',
              )
            ],
          ),
          body: ListView(
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 10),
                child: Column(
                  children: [
                    new TextFormField(
                      maxLength: 32,
                      style: new TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      controller: titleController,
                      decoration: InputDecoration(
                          labelText: '标题',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height),
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: new TextFormField(
                        controller: contentController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: new TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            labelText: '正文',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 1,
                        children: tagChips,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
      onWillPop: _onBackPressed,
    );
  }

  void textListener() {
    setState(() {
      if (widget.mode == 0) {
        if (titleController.text.trim().isNotEmpty ||
            contentController.text.trim().isNotEmpty) {
          if ((titleController.text == draftTitle) &&
              (contentController.text == draftContent)) {
            edited = false;
          }else{
            edited = true;
          }
        } else {
          edited = false;
        }
      }
      if (widget.mode == 1) {
        if (titleController.text == widget.titleText &&
            contentController.text == widget.contentText) {
          edited = false;
        } else {
          edited = true;
        }
      }
    });
  }

  void addTag(BuildContext bc) {
    TextEditingController _tagEditor = new TextEditingController();
    Scaffold.of(bc).showBottomSheet(
      (bc) => Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: TextField(
          autofocus: true,
          controller: _tagEditor,
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            setState(() {
              tags.add(_tagEditor.text);
              refreshTagList();
              Navigator.pop(context);
            });
          },
          decoration: InputDecoration(
            hintText: '输入标签名称',
            suffixIcon: IconButton(
              icon: Icon(
                Icons.done_rounded,
                color: Colors.blue,
              ),
              onPressed: () {
                tags.add(_tagEditor.text);
                refreshTagList();
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  //退出前事件，返回true时即退出
  Future<bool> _onBackPressed() async {
    //如果没有改动内容或内容为空或是已保存,不拦截退出
    if (saved || (!edited)) {
      return Future<bool>.value(true);
    }
    bool result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Column(
                children: [
                  Icon(
                    Icons.help_rounded,
                    size: 40,
                    color: Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text('要保存为草稿吗?'),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.save),
                  label: Text('保存'),
                  onPressed: () {
                    save(titleController.text, contentController.text, tags);
                    Navigator.pop(context, true);
                  },
                ),
                FlatButton.icon(
                  textColor: Colors.redAccent,
                  icon: Icon(Icons.delete_rounded),
                  label: Text('舍弃'),
                  onPressed: () async {
                    Navigator.pop(context, true);
                    //舍弃时会清空草稿存储
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.setString('draft_title', '');
                    sp.setString('draft_content', '');
                    sp.setStringList('draft_tags', null);
                  },
                ),
              ],
            ));
    if (result == null) {
      return false;
    }
    return result;
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> save(String title, String content, List<String> tags) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('draft_title', title);
    sp.setString('draft_content', content);
    sp.setStringList('draft_tags', tags);
  }
}
