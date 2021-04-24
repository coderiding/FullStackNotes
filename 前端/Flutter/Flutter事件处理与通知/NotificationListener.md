NotificationListener 继承自StatelessWidget类，所以它可以直接嵌套到Widget树中。

通过context找到对应的Widget，因为每个Widget都有自己的context，Widgete上可能会绑定监听，点击事件等，所以通过conext就找到了绑定的监听，找到了点击事件。

NotificationListener是监听的子树

### 滚动通知（ScrollNotification）
```DART
NotificationListener(
  onNotification: (notification){
    switch (notification.runtimeType){
      case ScrollStartNotification: print("开始滚动"); break;
      case ScrollUpdateNotification: print("正在滚动"); break;
      case ScrollEndNotification: print("滚动停止"); break;
      case OverscrollNotification: print("滚动到边界"); break;
    }
  },
  child: ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return ListTile(title: Text("$index"),);
      }
  ),
);
```

### SizeChangedLayoutNotification

### KeepAliveNotification

### LayoutChangedNotification

### 自定义通知
* dispatch(context)方法，它是用于分发通知的
* 注意：代码中注释的部分是不能正常工作的，因为这个context是根Context，而NotificationListener是监听的子树，所以我们通过Builder来构建RaisedButton，来获得按钮位置的context。

```DART
class MyNotification extends Notification {
  MyNotification(this.msg);
  final String msg;
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String _msg="";
  @override
  Widget build(BuildContext context) {
    //监听通知  
    return NotificationListener<MyNotification>(
      onNotification: (notification) {
        setState(() {
          _msg+=notification.msg+"  ";
        });
       return true;
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
//          RaisedButton(
//           onPressed: () => MyNotification("Hi").dispatch(context),
//           child: Text("Send Notification"),
//          ),  
            Builder(
              builder: (context) {
                return RaisedButton(
                  //按钮点击时分发通知  
                  onPressed: () => MyNotification("Hi").dispatch(context),
                  child: Text("Send Notification"),
                );
              },
            ),
            Text(_msg)
          ],
        ),
      ),
    );
  }
}
```

### 情况2
NotificationListener 可以指定一个模板参数，该模板参数类型必须是继承自Notification（就是只接收这种类型的通知）
```DART
//指定监听通知的类型为滚动结束通知(ScrollEndNotification)
//代码运行后便只会在滚动结束时在控制台打印出通知的信息。
NotificationListener<ScrollEndNotification>(
  onNotification: (notification){
    //只会在滚动结束时才会触发此回调
    print(notification);
  },
  child: ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return ListTile(title: Text("$index"),);
      }
  ),
);
```

https://book.flutterchina.club/chapter8/notification.html