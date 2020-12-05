class DateTimeFormat {
  static handleDate(String oldTime) {
    String nowTime =
        new DateTime.now().toString().split('.')[0].replaceAll('-', '/');
    int nowYear = int.parse(nowTime.split(" ")[0].split('/')[0]);
    int nowMonth = int.parse(nowTime.split(" ")[0].split('/')[1]);
    int nowDay = int.parse(nowTime.split(" ")[0].split('/')[2]);
    int nowHour = int.parse(nowTime.split(" ")[1].split(':')[0]);
    int nowMinute = int.parse(nowTime.split(" ")[1].split(':')[1]);

    int oldYear = int.parse(oldTime.split(" ")[0].split('/')[0]);
    int oldMonth = int.parse(oldTime.split(" ")[0].split('/')[1]);
    int oldDay = int.parse(oldTime.split(" ")[0].split('/')[2]);
    int oldHour = int.parse(oldTime.split(" ")[1].split(':')[0]);
    int oldMinute = int.parse(oldTime.split(" ")[1].split(':')[1]);

    var now = new DateTime(nowYear, nowMonth, nowDay, nowHour, nowMinute);
    var old = new DateTime(oldYear, oldMonth, oldDay, oldHour, oldMinute);
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
    return '$oldYear/$oldMonth/$oldDay';
  }
}
