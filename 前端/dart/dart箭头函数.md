Dart中的箭头函数，跟kotlin很像。

```dart
// 其实=> runApp(MyApp()); 等同于
{
return new MyApp();
}
```

### 箭头函数例子1
```DART
//所以｛codeBlock｝等同于 =>codeBlock，举个例子：

var list = ['apples', 'bananas', 'oranges'];
list.forEach((item) {
  print('${list.indexOf(item)}: $item');
});


//箭头函数如下：
list.forEach((item) => print('${list.indexOf(item)}: $item'));
```

参考

https://flutterbyexample.com/lesson/arrow-functions