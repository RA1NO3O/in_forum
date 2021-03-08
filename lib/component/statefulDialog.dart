import 'package:flutter/material.dart';

class StatefulDialog extends StatefulWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  const StatefulDialog({Key? key, this.actions, this.title, this.content})
      : super(key: key);

  @override
  _StatefulDialogState createState() => new _StatefulDialogState();
}

class _StatefulDialogState extends State<StatefulDialog> {
  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: widget.title,
          content: widget.content,
          actions: widget.actions,
        ),
      );
}
