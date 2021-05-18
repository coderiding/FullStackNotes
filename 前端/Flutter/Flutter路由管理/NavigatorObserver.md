有时候需要对程序路由栈变化进行监听，这里可以使用NavigatorObserver来进行处理，使用该代码可以获取当前栈中页面层数和判断是否是到了最后一个页面

https://blog.csdn.net/Mr_Tony/article/details/112269038  https://app.yinxiang.com/shard/s35/nl/9757212/4ca4beeb-e71d-4931-bf89-2d46bfc8901f

```dart
// flutter监听进入了那个界面

import 'package:flutter/material.dart';

///导航栈的变化监听
class MyNavigator extends NavigatorObserver{

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    var previousName = '';
    if (previousRoute == null) {
      previousName = 'null';
    }else {
      previousName = previousRoute.settings.name;
    }
    print('YM----->NavObserverDidPop--Current:' + route.settings.name + '  Previous:' + previousName);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);

    var previousName = '';
    if (previousRoute == null) {
      previousName = 'null';
    }else {
      previousName = previousRoute.settings.name;
    }
    print('YM-------NavObserverDidPush-Current:' + route.settings.name + '  Previous:' + previousName);

  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute,oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didRemove(route, previousRoute);
  }
}

```


```DART
import 'package:flutter/material.dart';
import 'navigator_test.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: "/",
      navigatorObservers: [
        MyNavigator()
      ],
    );
  }
}

```