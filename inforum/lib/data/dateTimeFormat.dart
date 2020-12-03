class DateTimeFormat {
  static handleDate(String oldTime) {
    String nowTime =
        new DateTime.now().toString().split('.')[0].replaceAll('-', '/');
    print(nowTime);
    int nowyear = int.parse(nowTime.split(" ")[0].split('/')[0]);
    int nowmonth = int.parse(nowTime.split(" ")[0].split('/')[1]);
    int nowday = int.parse(nowTime.split(" ")[0].split('/')[2]);
    int nowhour = int.parse(nowTime.split(" ")[1].split(':')[0]);
    int nowmin = int.parse(nowTime.split(" ")[1].split(':')[1]);

    int oldyear = int.parse(oldTime.split(" ")[0].split('/')[0]);
    int oldmonth = int.parse(oldTime.split(" ")[0].split('/')[1]);
    int oldday = int.parse(oldTime.split(" ")[0].split('/')[2]);
    int oldhour = int.parse(oldTime.split(" ")[1].split(':')[0]);
    int oldmin = int.parse(oldTime.split(" ")[1].split(':')[1]);

    var now = new DateTime(nowyear, nowmonth, nowday, nowhour, nowmin);
    var old = new DateTime(oldyear, oldmonth, oldday, oldhour, oldmin);
    var difference = now.difference(old);
    if (difference.inDays > 1 && difference.inDays < 10) {
      return (difference.inDays).toString() + '天前';
    } else if (difference.inDays == 1) {
      return '昨天'.toString();
    } else if (difference.inHours >= 1 && difference.inHours < 24) {
      return (difference.inHours).toString() + '小时前';
    } else if (difference.inMinutes > 5 && difference.inMinutes < 60) {
      return (difference.inMinutes).toString() + '分钟前';
    } else if (difference.inMinutes <= 5) {
      return '刚刚';
    }
    return '${oldyear}/${oldmonth}/${oldday}';
  }
}
