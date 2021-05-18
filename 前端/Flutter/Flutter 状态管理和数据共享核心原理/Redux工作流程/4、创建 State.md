```dart
class GSYState {
  ///用户信息
  User userInfo;

  ///主题数据
  ThemeData themeData;

  ///语言
  Locale locale;

  ///当前手机平台默认语言
  Locale platformLocale;

  ///是否登录
  bool login;

  ///构造方法
  GSYState({this.userInfo, this.themeData, this.locale, this.login});
}

```