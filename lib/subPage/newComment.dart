import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/uploadPictureService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCommentScreen extends StatefulWidget {
  final String contentText;
  final int targetPostID;
  final String imgURL;

  const NewCommentScreen(
      {Key key, this.contentText, this.imgURL, this.targetPostID})
      : super(key: key);

  @override
  _NewCommentScreenState createState() => _NewCommentScreenState();
}

class _NewCommentScreenState extends State<NewCommentScreen> {
  final commentController = new TextEditingController();
  String _localImagePath;
  String _networkImageLink;
  bool isNull = true;

  @override
  void initState() {
    commentController.addListener(() {
      setState(() {
        if (commentController.text.trim().isEmpty) {
          isNull = true;
        } else {
          isNull = false;
        }
      });
    });
    commentController.text = widget.contentText;
    if (widget.imgURL != null) {
      _networkImageLink = widget.imgURL;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('撰写回复'),
        actions: [
          new IconButton(
            icon: Icon(Icons.send_rounded),
            onPressed: !isNull
                ? () async {
                    String uploadedImage;
                    if (_localImagePath != null) {
                      uploadedImage = await uploadFile(File(_localImagePath));
                    } else if (_networkImageLink != null) {
                      uploadedImage = _networkImageLink;
                    }
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int editorID = prefs.getInt('userID');
                    Response res = await Dio().post(
                        '$apiServerAddress/newComment/',
                        options: new Options(
                            contentType: Headers.formUrlEncodedContentType),
                        data: {
                          "targetPostID": widget.targetPostID,
                          "content": commentController.text,
                          "imgURL": uploadedImage ?? 'null',
                          "editorID": editorID
                        });
                    if (res.data == 'success.') {
                      // Fluttertoast.showToast(msg: '回复已送出.');
                      Navigator.pop(context, '0');
                    }
                  }
                : null,
            tooltip: '发送回复',
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 10),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height),
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: new TextFormField(
                    autofocus: true,
                    controller: commentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    maxLength: 200,
                    style: new TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        hintText: '在此处撰写回复.',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
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
                            Text('或者'),
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
                            constraints:
                                BoxConstraints(maxHeight: 400, maxWidth: 400),
                            child: _localImagePath != null
                                ? Image.file(
                                    File(_localImagePath),
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    _networkImageLink,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                  _networkImageLink = imgLinkEditor.text;
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        setState(() {
          _localImagePath = pickedFile.path;
        });
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
