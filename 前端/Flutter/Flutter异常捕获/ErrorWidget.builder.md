https://flutter.cn/docs/testing/errors

当构建期间发生错误时，回调函数 ErrorWidget.builder 会被调用，来生成一个新的 widget，用来代替构建失败的 widget。默认情况，debug 模式下会显示一个红色背景的错误页面， release 模式下会展示一个灰色背景的空白页面。

这些回调方法都可以被重写，通常在 void main() 方法中重写。

```dart
class MyApp extends StatelessWidget {
...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
      builder: (BuildContext context, Widget widget) {
        Widget error = Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator)
          error = Scaffold(body: Center(child: error));
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
        return widget;
      },
    );
  }
}

```