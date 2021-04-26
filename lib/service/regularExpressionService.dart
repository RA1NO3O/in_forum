//用户名:只能输入数字和字母
bool isUserameFormat(String input) =>
    RegExp(r"^[ZA-ZZa-z0-9_]+$").hasMatch(input);

//电话号码：1开头，后面10位数字
bool isPhone(String input) => RegExp(r"1[0-9]\d{9}$").hasMatch(input);

//登录密码：6~16位数字和字符组合
bool isPasswordFormat(String input) =>
    RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$").hasMatch(input);

///邮箱验证
bool isEmail(String input) =>
    RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$").hasMatch(input);
