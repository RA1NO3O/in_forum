import 'package:flutter/material.dart';

RoundedRectangleBorder roundedRectangleBorder =
RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));

SnackBar errorSnackBar(String r) {
  return SnackBar(
    content: Row(
      children: [
        Icon(Icons.close_rounded),
        Text(r),
      ],
    ),
    backgroundColor: Colors.redAccent,
  );
}

SnackBar welcomeSnackBar(String r) {
  return SnackBar(
    content: Row(
      children: [
        Text('👏欢迎, ' + r),
      ],
    ),
    backgroundColor: Colors.greenAccent,
  );
}

SnackBar doneSnackBar(String r) {
  return SnackBar(
    content: Row(
      children: [
        Icon(Icons.done_rounded),
        Text(r),
      ],
    ),
    backgroundColor: Colors.blue,
  );
}
