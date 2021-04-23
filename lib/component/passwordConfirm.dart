import 'package:flutter/material.dart';
import 'package:inforum/component/customStyles.dart';
import 'package:inforum/component/statefulDialog.dart';
import 'package:inforum/service/loginService.dart';

class ConfirmPasswordDialog extends StatefulWidget {
  final String userName;
  final BuildContext bc;

  const ConfirmPasswordDialog(
      {Key? key, required this.userName, required this.bc})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ConfirmPasswordDialogState();
}

class _ConfirmPasswordDialogState extends State<ConfirmPasswordDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _pwdController = new TextEditingController();
    GlobalKey<FormState> _pk = GlobalKey<FormState>();
    return StatefulDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [new Icon(Icons.lock_rounded, size: 32), Text('  确认目前的密码')],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _pk,
            child: TextFormField(
              obscureText: true,
              autofocus: true,
              validator: (value) =>
                  _pwdController.text.isEmpty ? '密码是必需的.' : null,
              textInputAction: TextInputAction.done,
              onEditingComplete: () async {
                if (_pk.currentState!.validate()) {
                  final r =
                      await tryLogin(widget.userName, _pwdController.text);
                  if (r != null) {
                    Navigator.pop(widget.bc, 'correct.');
                  } else {
                    Navigator.pop(widget.bc, 'incorrect.');
                  }
                }
              },
              controller: _pwdController,
              decoration: InputDecoration(border: inputBorder),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '验证您的身份.',
              style: invalidTextStyle,
            ),
          ),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.pop(widget.bc, 'forgetPassword'),
          icon: Icon(Icons.help_center_rounded),
          label: Text('忘记密码?'),
        ),
        TextButton.icon(
          onPressed: () async {
            if (_pk.currentState!.validate()) {
              var r = await tryLogin(widget.userName, _pwdController.text);
              if (r != null) {
                Navigator.pop(widget.bc, 'correct.');
              } else {
                Navigator.pop(widget.bc, 'incorrect.');
              }
            }
          },
          icon: Icon(Icons.arrow_forward_rounded),
          label: Text('继续'),
        ),
      ],
    );
  }
}