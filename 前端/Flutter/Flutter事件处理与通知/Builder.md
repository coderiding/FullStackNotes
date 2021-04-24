Builder中有一个builder，返回一个Widget即可，那和直接使用Container有什么区别吗？

答案肯定是有的，用处主要体现在context上。

### 情况1：使用Builder解决context问题

* CustomNotification是作用在子Widget的

* 这段代码问题是，context表示全局context，它上面没有绑定 CustomNotification

```DART
NotificationListener<CustomNotification>(
  onNotification: (CustomNotification notification) {
    print('介绍事件——2：${notification.value}');
    return false;
  },
  child: Center(
    child: RaisedButton(
      child: Text('发送'),
      onPressed: () {
        CustomNotification('自定义事件').dispatch(context);
      },
    ),
  ),
)
```

---

* 通过Builder来构建RaisedButton，来获得按钮位置的context
* 按钮位置的context绑定了 CustomNotification
* 每个Widget都有自己的context

```DART
NotificationListener<CustomNotification>(
  onNotification: (CustomNotification notification) {
    print('介绍事件——2：${notification.value}');
    return false;
  },
  child: Center(
    child: Builder(
      builder: (context) {
        return RaisedButton(
          child: Text('发送'),
          onPressed: () {
            CustomNotification('自定义事件').dispatch(context);
          },
        );
      },
    ),
  ),
)
```
