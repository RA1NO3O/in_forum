import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final Icon ico;
  final Function fun;
  final String txt;

  const ActionButton({Key key, this.ico, this.fun, this.txt}) : super(key: key);

  @override
  _ActionButton createState() => _ActionButton();
}

class _ActionButton extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        IconButton(icon: widget.ico, onPressed: widget.fun),
        widget.txt!=null?Text(widget.txt):Container()
      ],
    );
  }
}
