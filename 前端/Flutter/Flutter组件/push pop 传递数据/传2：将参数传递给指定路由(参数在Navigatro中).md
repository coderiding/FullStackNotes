### 发送参数

```DART

//我们先定义一个实体类：

class People {
  String name;
  int age;
  People(this.name, this.age);
}

//将参数数据传递给PageB，可以有如下四种传参方式，效果都一样
Navigator.pushNamed(
  context,
  pageB,
  arguments: People("yzq", 25),//要传递的数据
);

Navigator.of(context).pushNamed(pageB, arguments: People("yzq", 25));

//通过 RouteSettings
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PageB(),
    settings: RouteSettings(
      arguments: People("yuzhiqiang", 26),
    ),
  ),
);

Navigator.of(context).push(
  MaterialPageRoute(
      builder: (context) => PageB(),
      settings: RouteSettings(
          arguments: People("yuzhiqiang", 26),
      )
  ),
);

Navigator.of(context).pushNamed(
  "/router/data2",
  arguments: {"data": "Hello"},
);

Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => ChildDataDemo4(),
    settings: RouteSettings(
      arguments: {"data": "Hello"},
    ),
  ),
);
```

### 接收参数

```DART
//在PageB接收数据，接收数据要通过 ModalRoute.of 方法。此方法返回带有参数的当前路由。
import 'package:flutter/material.dart';
import 'package:flutter_router/people.dart';

class PageB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*获取传递过来的参数*/
    People _people = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("B页面"),
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
        child: Text("姓名：${_people.name},年龄：${_people.age}"),
      ),
    );
  }
}




class RouterChildDateDemo2 extends StatefulWidget {
  @override
  _RouterChildDateDemo2State createState() => _RouterChildDateDemo2State();
}

class _RouterChildDateDemo2State extends State<RouterChildDateDemo2> {
  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    String data = arguments['data'];
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text("data: $data"),
        ],
      ),
    );
  }
}

```