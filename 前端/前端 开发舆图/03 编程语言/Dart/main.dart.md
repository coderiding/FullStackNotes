Flutter启动类main.dart的函数

```dart
void main() {
  // mx：MyApp就是要启动的首页  
  runApp(MyApp());
  // mx：透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
```