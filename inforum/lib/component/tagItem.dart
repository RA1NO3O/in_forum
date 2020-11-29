import 'package:flutter/material.dart';

class TagItem extends StatefulWidget {
  final String label;
  final int v;

  const TagItem({Key key, this.label, this.v}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TagItem();
}

class _TagItem extends State<TagItem> {
  int v;

  @override
  void initState() {
    v = widget.v;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: v == 2
          ? InputChip(
              onPressed: () {},
              onDeleted: () {
                setState(() {
                  v = 0;
                });
              },
              avatar: const Icon(Icons.tag),
              label: Text(widget.label),
            )
          : v == 1
              ? Chip(
                  avatar: const Icon(Icons.tag,color: Colors.blue,),
                  label: Text(widget.label,style: new TextStyle(color: Colors.blue),),
                  backgroundColor: Color(0xffFFFFFF),
                )
              : null,
    );
  }
}
