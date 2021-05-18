### 方式1-普通跳转
```DART
Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) => PageA(),
    ),
);

Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => PageA(),
    ),
);

```

### 方式2-命名路由跳转 
```dart
Navigator.of(context).pushNamed(pageA);

Navigator.pushNamed(context, pageA);

Navigator.of(context).pushNamed("/router/nextPage");
```

### 方式4 ---  pushReplacementNamed
```DART
pushReplacementNamed

用法和popAndPushNamed类似，同样是退出当前页面并跳转新页面。但popAndPushNamed页面出栈和入栈都有动画，pushReplacementNamed则只有入栈动画

Navigator.of(context).pushReplacementNamed("/router/next5");

//前提是需要在程序主入口配置路由表

MaterialApp(
      navigatorObservers: [UserNavigatorObserver()],
      initialRoute: "/",
      routes: {
        "/router": (context) => RouterDemo(),
        "/router/nextPage": (context) => NextPage2(),
      },
    );
```

### 方式5 --- popAndPushName
```DART
//退出当前页面并跳转新页面
Navigator.of(context).popAndPushNamed("/router/nextPage");

//等同于如下操作
Navigator.of(context).pop();
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => NextPage1(),
  ),
);


路由功能

https://juejin.cn/post/6844904062954012680  https://app.yinxiang.com/shard/s35/nl/9757212/44881a8d-bac4-40cf-9ee5-246f02b2b902