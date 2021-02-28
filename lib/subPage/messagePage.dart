import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePage createState() {
    return _MessagePage();
  }
}

class _MessagePage extends State<MessagePage> {
  bool isEmpty;
  ScrollController _listViewController;

  @override
  void initState() {
    isEmpty = true;
    _listViewController = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outline_rounded,
                    size: 100,
                  ),
                  Text('尝试发起一个聊天')
                ],
              )
            : ListView(
                controller: _listViewController,
                children: [],
              ),
      ),
    );
  }
// 滚动消息至聊天底部
// void scrollMsgBottom() {
//   timer = Timer(Duration(milliseconds: 100), () => _msgController.jumpTo(_msgController.position.maxScrollExtent));
// }
}
