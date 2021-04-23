import 'dart:math';

String getRandom(int num) {
  String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  String left = '';
  for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
    left = left + alphabet[Random().nextInt(alphabet.length)];
  }
  return left;
}
