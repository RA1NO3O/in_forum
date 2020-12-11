import 'package:flutter/material.dart';
class MessagePage extends StatefulWidget{
  @override
  _MessagePage createState() {
    return _MessagePage();
  }
}
class _MessagePage extends State<MessagePage>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFAFAFA),
      child: ListView(
        children: [],
      ),
    );
  }
  // 滚动消息至聊天底部
  // void scrollMsgBottom() {
  //   timer = Timer(Duration(milliseconds: 100), () => _msgController.jumpTo(_msgController.position.maxScrollExtent));
  // }
}