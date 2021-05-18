把onGenerateRoute看作是一个拦截器，对传递的参数先进行拦截处理后再传递给指定的Widget。

```dart
MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: RoutePath,
      home: MyHomePage(title: '主页面'),
      onGenerateRoute: (settings) {
        /*如果路由名称是PageC.routeName 则进行处理*/
        if (settings.name == PageC.routeName) {
          People p = settings.arguments;

          return MaterialPageRoute(
              builder: (context) => PageCHome(
                    pageContext: context,
                    name: p.name,
                  ));
        }
      },
    );


```dart
Navigator.pushNamed(
            context,
            PageC.routeName,
            arguments: People("喻志强", 23),
          );


```dart
// 我们新建一个PageC，代码如下。
import 'package:flutter/material.dart';

class PageC extends StatelessWidget {
  /*路由别名*/
  static const routeName = '/pageC';

  /*需要的参数*/
  String name;

  PageC({this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("C页面"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Center(
        child: Text("姓名：${name}"),
      ),
    );
  }
}


