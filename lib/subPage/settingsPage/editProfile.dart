import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inforum/component/imageViewer.dart';
import 'package:inforum/data/webConfig.dart';
import 'package:inforum/service/dateTimeFormat.dart';
import 'package:inforum/service/profileService.dart';
import 'package:inforum/service/randomGenerator.dart';
import 'package:intl/intl.dart';

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
    setState(() {
      _avatarURL = rs?.avatarUrl ?? '';
      _bannerURL = rs?.bannerUrl ?? '';
      _nickNameController.text = rs!.nickname!;
      _bioController.text = rs.bio!;
      _locationController.text = rs.location!;
      _birthdayController.text = convertBasicDateFormat(rs.birthday.toString());
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
              icon: Icon(Icons.done_rounded),
              tooltip: '保存',
              onPressed: () async {
                Response res = await Dio().post(
                  '$apiServerAddress/editProfile/?userID=${widget.userID}',
                  options: new Options(
                      contentType: Headers.formUrlEncodedContentType),
                  data: {
                    "avatarURL": _avatarURL,
                    "bannerURL": _bannerURL,
                    "nickName": _nickNameController.text,
                    "bio": _bioController.text,
                    "location": _locationController.text,
                    "birthday": DateFormat.yMMMd('zh_CN')
                        .parse(_birthdayController.text),
                  },
                );
                if (res.data == 'success.') {
                  Navigator.pop(context, 0);
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
                  ? CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image_rounded),
                      imageUrl: _bannerURL,
                      fit: BoxFit.cover,
                      height: 150,
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
              maxLength: 50,
              decoration: InputDecoration(labelText: '昵称'),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              controller: _bioController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: '简介',
                alignLabelWithHint: false,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              controller: _locationController,
              maxLines: 1,
              maxLength: 50,
              decoration: InputDecoration(labelText: '位置'),
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
              decoration: InputDecoration(labelText: '生日'),
            ),
          )
        ],
      ),
    );
  }
}
