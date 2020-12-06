import 'package:flutter/material.dart';

class PopUpTextField extends StatelessWidget {
  final String hintText;
  final ValueChanged onEditingCompleteText;
  final TextEditingController controller = TextEditingController();

  PopUpTextField({this.onEditingCompleteText, this.hintText});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: new Column(
        children: <Widget>[
          Expanded(
              child: new GestureDetector(
                child: new Container(
                  color: Colors.transparent,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
          ),
          new Container(
              color: Color(0xFFF4F4F4),
              padding: EdgeInsets.only(left: 16,top: 8,bottom: 8,right: 16),
              child:  Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFAFAFA)
                ),

                child: TextFormField(
                  controller: controller,
                  autofocus: true,
                  style: TextStyle(
                      fontSize: 16
                  ),
                  //设置键盘按钮为发送
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.multiline,
                  onEditingComplete: (){
                    //点击发送调用
                    onEditingCompleteText(controller.text);
                    Navigator.pop(context);

                  },
                  decoration: InputDecoration(
                    hintText: hintText,
                    isDense: true,
                    contentPadding: EdgeInsets.all(5),
                    border: const OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),

                  ),

                  minLines: 1,
                  maxLines: 5,
                ),
              )
          )
        ],
      ),
    );
  }
}
//过度路由
class PopRoute extends PopupRoute{
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;

}