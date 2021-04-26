import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/component/imageViewer.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/dateTimeFormat.dart';
import 'package:inforum/service/profileService.dart';
import 'package:inforum/service/randomGenerator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final int? userID;

  const EditProfilePage({Key? key, this.userID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _avatarURL = '';
  String _avatarHeroTag = getRandom(6);
  String _bannerURL = '';
  String? _localBannerImagePath;
  TextEditingController _nickNameController = new TextEditingController();
  TextEditingController _bioController = new TextEditingController();
  TextEditingController _locationController = new TextEditingController();
  TextEditingController _birthdayController = new TextEditingController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    ProfileRecordset? rs = await getProfile(widget.userID);
    //取用本地缓存读取个人资料
    SharedPreferences sp = await SharedPreferences.getInstance();
    print(sp.getString('birthday'));
    setState(() {
      _avatarURL = sp.getString('avatarURL') ?? '';
      _bannerURL = sp.getString('bannerURL') ?? '';
      _nickNameController.text = sp.getString('nickName') ?? '';
      _bioController.text = sp.getString('bio') ?? '';
      _locationController.text = sp.getString('location') ?? '';
      _birthdayController.text = sp.getString('birthday') ?? '';
    });

    setState(() {
      _avatarURL = rs?.avatarUrl ?? '';
      _bannerURL = rs?.bannerUrl ?? '';
      _nickNameController.text = rs?.nickname ?? '';
      _bioController.text = rs?.bio ?? '';
      _locationController.text = rs?.location ?? '';
      _birthdayController.text =
          convertBasicDateFormat(rs?.birthday.toString() ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑个人资料'),
        actions: [
          Builder(
            builder: (bc) => IconButton(
              tooltip: '保存',
              icon: Icon(Icons.done_rounded),
              onPressed: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                Response res = await Dio().post(
                  '$apiServerAddress/editProfile/?userID=${widget.userID}',
                  options: new Options(
                      contentType: Headers.formUrlEncodedContentType),
                  data: {
                    "avatarURL": _avatarURL,
                    "bannerURL": _bannerURL,
                    "nickName": _nickNameController.text.isEmpty
                        ? 'null'
                        : _nickNameController.text,
                    "bio": _bioController.text.isEmpty
                        ? 'null'
                        : _bioController.text,
                    "location": _locationController.text.isEmpty
                        ? 'null'
                        : _locationController.text,
                    "birthday": _birthdayController.text.isEmpty
                        ? 'null'
                        : DateFormat.yMMMd('zh_CN')
                            .parse(_birthdayController.text, true),
                  },
                );
                if (res.data == 'success.') {
                  await sp.setString('nickName', _nickNameController.text);
                  await sp.setString('avatarURL', _avatarURL);
                  await sp.setString('bannerURL', _bannerURL);
                  await sp.setString('bio', _bioController.text);
                  await sp.setString('location', _locationController.text);
                  await sp.setString('birthday', _birthdayController.text);
                  Navigator.pop(context, 0);
                } else {
                  ScaffoldMessenger.of(bc)
                      .showSnackBar(errorSnackBar('个人资料修改失败,请检查网络.'));
                }
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              _bannerURL != ''
                  ? Material(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Ink.image(
                        image: CachedNetworkImageProvider(_bannerURL),
                        fit: BoxFit.cover,
                        height: 150,
                        child: InkWell(
                          onTap: () async {
                            // FilePickerResult? picker = await FilePicker.platform
                            //     .pickFiles(type: FileType.image);
                            // PlatformFile file = picker!.files.first;
                            final typeGroup = XTypeGroup(
                                label: 'images',
                                extensions: ['jpg', 'png', 'gif']);
                            final file =
                                await openFile(acceptedTypeGroups: [typeGroup]);
                            if (file != null) {
                              setState(() {
                                _localBannerImagePath = file.path;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  : Container(
                      height: 150,
                    ),
              Container(
                margin: EdgeInsets.only(top: 105, left: 20),
                child: Hero(
                  child: Material(
                    elevation: 1,
                    shape: CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.transparent,
                    child: Ink.image(
                      image: (_avatarURL != ''
                              ? CachedNetworkImageProvider(_avatarURL)
                              : AssetImage('images/default_avatar.png'))
                          as ImageProvider<Object>,
                      fit: BoxFit.contain,
                      width: 80,
                      height: 80,
                      child: InkWell(
                        onTap: () {
                          if (_avatarURL != '') {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ImageViewer(
                                imgURL: _avatarURL,
                                heroTag: _avatarHeroTag,
                              );
                            }));
                          }
                        },
                      ),
                    ),
                  ),
                  tag: _avatarHeroTag,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  border: Border.all(
                    width: 5,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              controller: _nickNameController,
              keyboardType: TextInputType.name,
              maxLines: 1,
              maxLength: 20,
              decoration: InputDecoration(labelText: '昵称', border: inputBorder),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              controller: _bioController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: '简介',
                alignLabelWithHint: false,
                border: inputBorder,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              controller: _locationController,
              maxLines: 1,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: '位置',
                border: inputBorder,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              controller: _birthdayController,
              onTap: () async {
                var result = await showDatePicker(
                  context: context,
                  initialDate: _birthdayController.text.isEmpty
                      ? DateTime.now()
                      : DateFormat.yMMMd('zh_CN')
                          .parse(_birthdayController.text),
                  firstDate: DateTime(DateTime.now().year - 100),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (result != null) {
                  _birthdayController.text =
                      convertBasicDateFormat(result.toString());
                }
              },
              decoration: InputDecoration(
                labelText: '生日',
                border: inputBorder,
              ),
            ),
          )
        ],
      ),
    );
  }
}
