import 'package:flutter/material.dart';

class EditPostScreen extends StatefulWidget {
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  IconData _actionIcon = Icons.delete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑帖子'),
        actions: [
          new IconButton(
            icon: Icon(Icons.save),
            onPressed: ()=> print('saved.'),
          ),
        ],
      ),
      body: new Column(
        children: [
          new TextFormField(),
          new TextFormField(),
          AnimatedSwitcher(
            transitionBuilder: (child, anim) {
              return ScaleTransition(child: child, scale: anim);
            },
            duration: Duration(milliseconds: 200),
            child: IconButton(
              key: ValueKey(_actionIcon),
              icon: Icon(_actionIcon),
              onPressed: (){},
            ),
          ),
          RaisedButton(
            child: Text("切换图标"),
            onPressed: () {
              setState(() {
                if (_actionIcon == Icons.delete)
                  _actionIcon = Icons.done;
                else
                  _actionIcon = Icons.delete;
              });
            },
          ),
        ],
      ),
    );
  }
}
