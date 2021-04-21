import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/uploadPictureService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPostScreen extends StatefulWidget {
  final String? titleText;
  final String? contentText;
  final List<String>? tags;
  final int? mode; //0为新建,1为编辑
  final int? postID;
  final String? imgURL;
  final String? heroTag;

  const EditPostScreen(
      {Key? key,
      this.titleText,
      this.contentText,
      this.mode,
      this.tags,
      this.postID,
      this.imgURL,
      this.heroTag})
      : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late SharedPreferences sp;
  final titleController = new TextEditingController();
  final contentController = new TextEditingController();
  var tags = [];
  late var tagChips;
  bool saved = false;
  bool edited = false;
  String? draftTitle;
  String? draftContent;
  List<String>? draftTags;
  String? _localImagePath;
  String? _networkImageLink;

  @override
  void initState() {
    if (widget.mode == 0) {
      getDraft();
    }
    if (widget.mode == 1) {
      titleController.text = widget.titleText!;
      contentController.text = widget.contentText!;
      if (widget.tags != null) {
        tags.addAll(widget.tags!);
      }
      if (widget.imgURL != null) {
        _networkImageLink = widget.imgURL;
      }
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
                  setState(
                    () {
                      tags.remove('$s');
                      refreshTagList();
                    },
                  );
                },
              ),
            ))
        .toList());
  }

  Future<void> getDraft() async {
    sp = await SharedPreferences.getInstance();
    draftTitle = sp.getString('draft_title');
    draftContent = sp.getString('draft_content');
    draftTags = sp.getStringList('draft_tags');
    titleController.text = draftTitle!;
    contentController.text = draftContent!;
    tags = draftTags ?? [];
    refreshTagList();
  }

  @override
  Widget build(BuildContext context) {
    refreshTagList();
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Text(widget.mode == 0 ? '新帖子' : '编辑帖子'),
            actions: [
              widget.mode == 0
                  ? Builder(builder: (BuildContext bc) {
                      return IconButton(
                        icon: Icon(Icons.save_rounded),
                        onPressed: () {
                          save(titleController.text, contentController.text,
                              tags as List<String>);
                          ScaffoldMessenger.of(bc)
                              .showSnackBar(doneSnackBar('已存为草稿.'));
                          saved = true;
                        },
                        tooltip: '存为草稿',
                      );
                    })
                  : Container(),
              Builder(
                builder: (bc) => new IconButton(
                  icon: widget.mode == 0
                      ? Icon(Icons.send_rounded)
                      : Icon(Icons.done),
                  onPressed: titleController.text.trim().isNotEmpty &&
                          contentController.text.trim().isNotEmpty
                      ? () async {
                          String? uploadedImage;
                          if (_localImagePath != null) {
                            uploadedImage =
                                await uploadFile(File(_localImagePath!));
                          } else if (_networkImageLink != null) {
                            uploadedImage = _networkImageLink;
                          }
                          if (widget.mode == 0) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            int? editorID = prefs.getInt('userID');
                            Response res = await Dio().post(
                                '$apiServerAddress/newPost/',
                                options: new Options(
                                    contentType:
                                        Headers.formUrlEncodedContentType),
                                data: {
                                  "title": titleController.text,
                                  "content": contentController.text,
                                  "tags": tags,
                                  "imgURL": uploadedImage ?? 'null',
                                  "editorID": editorID,
                                });
                            if (res.data == 'success.') {
                              Navigator.pop(context, '0');
                            }
                          } else {
                            Response res = await Dio().post(
                                '$apiServerAddress/editPost/',
                                options: new Options(
                                    contentType:
                                        Headers.formUrlEncodedContentType),
                                data: {
                                  "postID": widget.postID,
                                  "title": titleController.text,
                                  "content": contentController.text,
                                  "tags": tags,
                                  "imgURL": uploadedImage ?? 'null',
                                });
                            if (res.data == 'success.') {
                              Navigator.pop(context, '0');
                            } else {
                              ScaffoldMessenger.of(bc)
                                  .showSnackBar(errorSnackBar(res.data));
                            }
                          }
                        }
                      : null,
                  tooltip: widget.mode == 0 ? '发帖' : '提交更改',
                ),
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
                          border: inputBorder),
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
                            border: inputBorder),
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
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: (_localImagePath == null) &&
                              (_networkImageLink == null)
                          ? Row(
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.photo_library_rounded),
                                  label: Text('添加图片'),
                                  onPressed: getImage,
                                ),
                                Text(' 或者 '),
                                Builder(
                                  builder: (bc) => TextButton.icon(
                                    icon: Icon(Icons.insert_link_rounded),
                                    label: Text('网络图片'),
                                    onPressed: () => addNetworkImage(bc),
                                  ),
                                )
                              ],
                            )
                          : Dismissible(
                              key: new Key(''),
                              // ignore: non_constant_identifier_names
                              onDismissed: (DismissDirection) {
                                setState(() {
                                  _localImagePath = null;
                                  _networkImageLink = null;
                                });
                              },
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: 400, maxWidth: 400),
                                child: _localImagePath != null
                                    ? Image.file(
                                        File(_localImagePath!),
                                        fit: BoxFit.cover,
                                      )
                                    : Hero(
                                        child: Image.network(
                                          _networkImageLink!,
                                          fit: BoxFit.cover,
                                        ),
                                        tag: widget.heroTag ?? '',
                                      ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          )),
      onWillPop: _onBackPressed,
    );
  }

  void addNetworkImage(BuildContext bc) {
    var imgLinkEditor = new TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      context: bc,
      builder: (bc) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: MediaQuery.of(bc).viewInsets.bottom + 5),
          child: TextField(
            autofocus: true,
            controller: imgLinkEditor,
            textInputAction: TextInputAction.done,
            onEditingComplete: () {
              setState(() {
                _networkImageLink = imgLinkEditor.text;
                Navigator.pop(bc);
              });
            },
            decoration: InputDecoration(
              hintText: '输入图片URL',
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.done_rounded,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    _networkImageLink = imgLinkEditor.text;
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void textListener() {
    setState(() {
      if (widget.mode == 0) {
        if (titleController.text.trim().isNotEmpty ||
            contentController.text.trim().isNotEmpty) {
          edited = true;
        } else {
          edited = false;
        }
      }
      if (widget.mode == 1) {
        if (titleController.text.trim() == widget.titleText &&
            contentController.text.trim() == widget.contentText) {
          edited = false;
        } else {
          edited = true;
        }
      }
    });
  }

  void addTag(BuildContext bc) {
    var _tagEditor = new TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (bc) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 5),
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
      ),
    );
  }

  //退出前事件，返回true时即退出
  Future<bool> _onBackPressed() async {
    //如果没有改动内容或内容为空或是已保存,不拦截退出
    if (saved || (!edited)) {
      return Future<bool>.value(true);
    }
    bool? result = await showDialog<bool>(
        context: context,
        builder: (bc) => AlertDialog(
              title: Column(
                children: [
                  Icon(
                    Icons.help_rounded,
                    size: 40,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child:
                        widget.mode == 0 ? Text('要保存为草稿吗?') : Text('舍弃更改并退出吗?'),
                  )
                ],
              ),
              actions: <Widget>[
                TextButton.icon(
                  icon: widget.mode == 0
                      ? Icon(Icons.save)
                      : Icon(Icons.arrow_back_rounded),
                  label: widget.mode == 0 ? Text('保存') : Text('返回'),
                  onPressed: () {
                    save(titleController.text, contentController.text,
                        tags as List<String>);
                    Navigator.pop(bc, true);
                  },
                ),
                TextButton.icon(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.redAccent),
                  ),
                  icon: Icon(Icons.delete_rounded),
                  label: Text('舍弃'),
                  onPressed: () async {
                    Navigator.pop(bc, true);
                    //舍弃时会清空草稿存储
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    await sp.setString('draft_title', '');
                    await sp.setString('draft_content', '');
                    await sp.setStringList('draft_tags', []);
                  },
                ),
              ],
            ));
    if (result == null) {
      return false;
    }
    return result;
  }

  Future getImage() async {
    // final picker = ImagePicker();
    FilePickerResult? picker = await FilePicker.platform
        .pickFiles(type: FileType.image);
    // final file = await picker.getImage(source: ImageSource.gallery);
    PlatformFile file = picker!.files.first;
    setState(() {
      _localImagePath = file.path;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> save(String title, String content, List<String> tags) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('draft_title', title);
    await sp.setString('draft_content', content);
    await sp.setStringList('draft_tags', tags);
  }
}
