import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:inforum/service/randomGenerator.dart';
import 'package:inforum/subPage/profilePage.dart';

class FollowListItem extends StatelessWidget {
  final int userID;
  final String? avatarURL;
  final String nickName;
  final String userName;
  final String? bio;

  const FollowListItem(
      {Key? key,
      required this.userID,
      this.avatarURL,
      required this.nickName,
      required this.userName,
      this.bio})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: (avatarURL != null
                ? CachedNetworkImageProvider(avatarURL!,
                    maxWidth: 80, maxHeight: 80)
                : ResizeImage(
                    AssetImage(
                      'images/default_avatar.png',
                    ),
                    width: 80,
                    height: 80,
                  )) as ImageProvider<Object>,
          ),
          title: Text(nickName + ' @$userName'),
          subtitle: bio != null ? Text(bio!) : null,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (bc) => ProfilePage(
                      userID: this.userID, avatarHeroTag: getRandom(6)))),
        ),
      );
}
